#!/usr/bin/env python3

import sys
import os.path
import http.server
import socketserver
import subprocess

port = int(sys.argv[1])

def parse_action(line):
    parts = line.split(' ')
    return (parts[0], parts[1], parts[2:])

with open(sys.argv[2]) as f:
    actions = map(parse_action, f.read().strip().split('\n'))
    actions = {path: (dir, cmd) for (path, dir, cmd) in actions}

class HookHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.handle_webhook()

    def do_POST(self):
        self.handle_webhook()

    def handle_webhook(self):
        self.send_response(200)
        self.end_headers()

        try:
            dir, cmd = actions[self.path]
        except KeyError:
            print('error: no handler for {}'.format(self.path), file=sys.stderr)
            return
        cmd = ' '.join(cmd)

        os.chdir(dir)
        subprocess.run(['git', 'pull'])
        subprocess.run(cmd, shell=True)

socketserver.TCPServer.allow_reuse_address = True
httpd = socketserver.TCPServer(('127.0.0.1', port), HookHandler)

try:
    httpd.serve_forever()
except KeyboardInterrupt:
    httpd.shutdown()
