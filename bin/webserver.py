#!/usr/bin/env python3
import argparse
import http.server
import threading

def run(args):
    print(f'serving: {args.bind_address}:{args.port}')
    handler = http.server.SimpleHTTPRequestHandler
    server_addr = (args.bind_address, args.port)
    server = http.server.ThreadingHTTPServer(server_addr, handler)
    server.serve_forever()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-b', '--bind-address', default='127.0.0.1')
    parser.add_argument('-p', '--port', type=int, default=8000)
    args = parser.parse_args()
    run(args)


if __name__ == '__main__':
    main()
