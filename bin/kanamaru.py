#!/usr/bin/env python3
import argparse
import subprocess
import os

MORE_HELP='''
Kanamaru, a markdown viewer

This program uses markdown-it. You can install it as

    npm install markdown-it --save
'''

HTML_TEMPLATE = '''
<html>
<head>
<style type="text/css">
<!--
%s
-->
</style>
</head>
<body>
%s
</body>
</html>
'''

CSS_COMMON = '''
h1,h2 {
  margin: 1.0rem 0.4rem;
}
h3,h4,h5,p {
  margin: 0.6rem 0.4rem;
}
pre {
  margin: 0.4rem;
  padding: 0.6rem 0.8rem;
  border: solid 1px;
}
code {
  padding: 0.2em 0.4em;
}
pre code {
  padding: 0em;
}
ul {
  margin: 0em;
}
'''

CSS_LIGHT = CSS_COMMON + '''
h1,h2 {
  border-bottom: solid 1px #e0e0e0;
}
pre {
  border-color: #e0e0e0;
  background-color: #f0f0f0;
}
code {
  background-color: #f0f0f0;
}
'''

CSS_DARK = CSS_COMMON + '''
body {
  color: #e0e0f0;
  background-color: #202020;
}
h1,h2 {
  border-bottom: solid 1px #505050;
}
pre {
  border-color: #303030;
  background-color: #080808;
}
code {
  background-color: #080808;
}
'''

CSS_MAP = {
    'default': CSS_LIGHT,
    'light': CSS_LIGHT,
    'dark': CSS_DARK,
}

def create_html(args, body_core):
    css = CSS_MAP[args.style]
    with open(args.out_filename, 'w') as f:
        html = HTML_TEMPLATE % (css, body_core)
        f.write(html)

def process_input_file(args):
    cmd = ['npx', 'markdown-it', '/dev/stdin']

    params = {
        'input': args.infile.read().encode(),
        'stdout': subprocess.PIPE,
        'check': True,
    }
    result = subprocess.run(cmd, **params)
    body_core = result.stdout.decode()

    create_html(args, body_core)


def launch_inotifywait(args):
    abs_path = os.path.abspath(args.infile.name)
    base_dir = os.path.dirname(abs_path)
    cmd = ['inotifywait', '-m', '-e', 'modify', base_dir]
    args.proc = subprocess.Popen(cmd, stdout=subprocess.PIPE)
    args.file_name =  os.path.basename(abs_path)
    print(f'Monitor dir : {base_dir}')
    print(f'Monitor file: {args.file_name}')


def wait_update(args):
    while True:
        line = args.proc.stdout.readline().decode().strip()
        words = line.split()
        if len(words) != 3:
            continue
        dirname, event, filename = words
        if filename == args.file_name and event == 'MODIFY':
            print(f'Detect modification: {filename}')
            break


def run(args):
    if args.monitor:
        launch_inotifywait(args)

    while (True):
        process_input_file(args)
        if not args.monitor:
            break
        wait_update(args)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('infile', type=argparse.FileType('r'), default='-')
    parser.add_argument('--more-help', action='store_true')
    parser.add_argument('-p', '--port', default=8000)
    parser.add_argument('-o', '--out-filename')
    parser.add_argument('-s', '--style', choices=CSS_MAP.keys(),
                        default='default')
    parser.add_argument('-m', '--monitor', action='store_true')
    args = parser.parse_args()

    if args.more_help:
        print(MORE_HELP)
        return

    if args.out_filename is None:
        args.out_filename = args.infile.name + '.html'

    print(f'Input : {args.infile.name}')
    print(f'Output: {args.out_filename}')
    print(f'Style : {args.style}')
    run(args)


if __name__ == '__main__':
    main()
