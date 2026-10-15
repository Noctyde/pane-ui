#!/usr/bin/env python3
"""Obfuscate a Lua file with the Luraph API in one command.

    python tools/obfuscate.py                          # src/PaneUI.lua -> dist/PaneUI.lua
    python tools/obfuscate.py scripts/my-script.lua    # any file -> dist/my-script.lua
    python tools/obfuscate.py --bundle scripts/my-script.lua
        # inlines src/PaneUI.lua into the script first (one file, no loadstring)
    python tools/obfuscate.py --list-options           # what the Luraph node accepts

The API key comes from --key, or the LURAPH_API_KEY / LPH_API_KEY environment
variable. Options for the obfuscator go in tools/luraph.json:

    { "node": null, "options": { "TARGET_VERSION": "..." } }

or on the command line as --option NAME=VALUE (repeatable). Run
--list-options once to see the names and allowed values for your plan.

Only the Python standard library is used.
"""

import argparse
import base64
import json
import os
import re
import sys
import time
import urllib.error
import urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DEFAULT_INPUT = os.path.join(ROOT, "src", "PaneUI.lua")
DEFAULT_CONFIG = os.path.join(ROOT, "tools", "luraph.json")
API_URL = "https://api.lura.ph/v1/"
STATUS_ATTEMPTS = 3  # the status endpoint waits up to 60s and allows 3 calls per job


class LuraphError(Exception):
    pass


class Luraph:
    def __init__(self, key, base_url=API_URL):
        self.key = key
        self.base_url = base_url if base_url.endswith("/") else base_url + "/"

    def _request(self, method, path, body=None, raw=False, timeout=90):
        data = json.dumps(body).encode() if body is not None else None
        request = urllib.request.Request(self.base_url + path, data=data, method=method)
        request.add_header("Luraph-API-Key", self.key)
        request.add_header("Content-Type", "application/json")
        try:
            with urllib.request.urlopen(request, timeout=timeout) as response:
                payload = response.read()
                headers = response.headers
        except urllib.error.HTTPError as error:
            raise LuraphError(describe_error(error.code, error.read())) from None
        except urllib.error.URLError as error:
            raise LuraphError("could not reach the Luraph API: %s" % error.reason) from None
        except TimeoutError:
            raise LuraphError("the request timed out") from None
        if raw:
            return payload, headers
        result = json.loads(payload.decode() or "{}")
        for warning in result.get("warnings") or []:
            print("warning: %s" % warning, file=sys.stderr)
        return result

    def nodes(self):
        return self._request("GET", "obfuscate/nodes")

    def create_job(self, node, script, file_name, options, enforce):
        return self._request("POST", "obfuscate/new", {
            "node": node,
            "script": base64.b64encode(script).decode(),
            "fileName": file_name,
            "options": options,
            "useTokens": False,
            "enforceSettings": enforce,
        })["jobId"]

    def wait(self, job_id):
        for _ in range(STATUS_ATTEMPTS):
            try:
                status = self._request("GET", "obfuscate/status/%s" % job_id)
            except LuraphError as error:
                if "timed out" in str(error).lower():
                    continue
                raise
            if status.get("error"):
                raise LuraphError("obfuscation failed: %s" % status["error"])
            return
        raise LuraphError("the job did not finish in time")

    def download(self, job_id):
        payload, _ = self._request("GET", "obfuscate/download/%s" % job_id, raw=True)
        return payload


def describe_error(code, body):
    try:
        errors = json.loads(body.decode()).get("errors") or []
        messages = []
        for error in errors:
            if error.get("param"):
                messages.append("%s: %s" % (error["param"], error.get("message")))
            else:
                messages.append(str(error.get("message")))
        if messages:
            return "HTTP %d: %s" % (code, "; ".join(messages))
    except (ValueError, AttributeError):
        pass
    return "HTTP %d: %s" % (code, body.decode(errors="replace")[:300])


def bundle(library_path, script_path):
    """Same as tools/build-dev.sh: the library inlined, the loadstring line dropped."""
    with open(library_path, "r", encoding="utf-8") as file:
        library = file.read()
    with open(script_path, "r", encoding="utf-8") as file:
        lines = file.read().splitlines(keepends=True)
    for index, line in enumerate(lines):
        if re.match(r"^local Library = ", line):
            rest = "".join(lines[index + 1:])
            break
    else:
        raise LuraphError("%s has no 'local Library = ...' line to replace" % script_path)
    return "local Library = (function()\n%s\nend)()\n%s" % (library, rest)


def load_config(path):
    if not os.path.isfile(path):
        return {}
    with open(path, "r", encoding="utf-8") as file:
        return json.load(file)


def parse_value(text):
    lowered = text.lower()
    if lowered in ("true", "false"):
        return lowered == "true"
    return text


def pick_node(client, wanted):
    nodes = client.nodes()
    node_id = wanted or nodes.get("recommendedId")
    if not node_id or node_id not in nodes.get("nodes", {}):
        available = ", ".join(nodes.get("nodes", {}).keys()) or "none"
        raise LuraphError("node %r is not available (available: %s)" % (node_id, available))
    return node_id, nodes["nodes"][node_id]


def list_options(node_id, node):
    print("Node %s (cpu usage %s)" % (node_id, node.get("cpuUsage")))
    for name, info in sorted(node.get("options", {}).items()):
        flags = []
        if info.get("required"):
            flags.append("required")
        if info.get("tier") and info["tier"] != "CUSTOMER_ONLY":
            flags.append(info["tier"].lower())
        line = "  %s  [%s%s]" % (name, info.get("type", "?").lower(), ", " + ", ".join(flags) if flags else "")
        print(line)
        if info.get("description"):
            print("      %s" % info["description"])
        if info.get("choices"):
            print("      choices: %s" % ", ".join(info["choices"]))


def main():
    parser = argparse.ArgumentParser(description="Obfuscate a Lua file with the Luraph API.")
    parser.add_argument("input", nargs="?", default=DEFAULT_INPUT, help="file to obfuscate (default: src/PaneUI.lua)")
    parser.add_argument("-o", "--output", help="where to write the result (default: dist/<input name>)")
    parser.add_argument("--bundle", action="store_true", help="inline src/PaneUI.lua into INPUT before obfuscating")
    parser.add_argument("--key", help="Luraph API key (default: $LURAPH_API_KEY or $LPH_API_KEY)")
    parser.add_argument("--node", help="node id (default: the recommended node)")
    parser.add_argument("--option", action="append", default=[], metavar="NAME=VALUE", help="obfuscator option, repeatable")
    parser.add_argument("--config", default=DEFAULT_CONFIG, help="JSON file with node and options (default: tools/luraph.json)")
    parser.add_argument("--strict", action="store_true", help="make Luraph require a value for every option")
    parser.add_argument("--list-options", action="store_true", help="print the options the node accepts and exit")
    parser.add_argument("--dry-run", action="store_true", help="show what would be sent without calling the API")
    parser.add_argument("--base-url", default=API_URL, help=argparse.SUPPRESS)
    args = parser.parse_args()

    config = load_config(args.config)
    options = dict(config.get("options") or {})
    for item in args.option:
        if "=" not in item:
            parser.error("--option needs NAME=VALUE, got %r" % item)
        name, value = item.split("=", 1)
        options[name.strip()] = parse_value(value.strip())

    key = args.key or os.environ.get("LURAPH_API_KEY") or os.environ.get("LPH_API_KEY") or config.get("key")
    if not key and not args.dry_run:
        parser.error("no API key: pass --key or set LURAPH_API_KEY")

    try:
        if args.bundle:
            source = bundle(DEFAULT_INPUT, args.input)
        else:
            with open(args.input, "r", encoding="utf-8") as file:
                source = file.read()
        script = source.encode("utf-8")
        file_name = os.path.basename(args.input)
        output = args.output or os.path.join(ROOT, "dist", file_name)

        if args.dry_run:
            print("would obfuscate %s (%d bytes%s)" % (args.input, len(script), ", bundled with the library" if args.bundle else ""))
            print("node: %s" % (args.node or config.get("node") or "recommended"))
            print("options: %s" % (json.dumps(options) if options else "none"))
            print("output: %s" % output)
            return 0

        client = Luraph(key, args.base_url)
        node_id, node = pick_node(client, args.node or config.get("node"))
        if args.list_options:
            list_options(node_id, node)
            return 0

        unknown = [name for name in options if name not in node.get("options", {})]
        if unknown:
            raise LuraphError("unknown option(s) for node %s: %s (see --list-options)" % (node_id, ", ".join(unknown)))

        started = time.time()
        print("uploading %s (%d bytes) to node %s..." % (file_name, len(script), node_id))
        job_id = client.create_job(node_id, script, file_name, options, args.strict)
        print("job %s queued, waiting..." % job_id)
        client.wait(job_id)
        result = client.download(job_id)

        os.makedirs(os.path.dirname(os.path.abspath(output)), exist_ok=True)
        with open(output, "wb") as file:
            file.write(result)
        print("done in %.1fs: %s (%d bytes)" % (time.time() - started, output, len(result)))
        return 0
    except LuraphError as error:
        print("error: %s" % error, file=sys.stderr)
        return 1
    except OSError as error:
        print("error: %s" % error, file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
