#!/usr/bin/env python3
import argparse
import subprocess
import os

DESCRIPTION = 'kanamaru, a converter from a markdown file to an HTML file'

EPILOG = '''
This program uses markdown-it. You can install it as

    npm install markdown-it --save

The -m or --monitor option requires inotifywait command. On Debin/Ubuntu,
you can install it as

    sudo apt install inotify-tools
'''

HTML_TEMPLATE = '''
<html>
<head>
<meta charset="utf-8"/>
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
table {
  border-collapse: collapse;
}
table th, table td {
  border: solid 1px;
  padding: 0.2em 0.5em;
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
table th {
  background-color: #e8e8e8;
}
table th, table td {
  border-color: #a0a0a0;
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
a {
    color: cyan
}
a:link {
    color: cyan
}
table th {
  background-color: #404040;
}
table th, table td {
  border-color: #808080;
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
    print(f'Wrote: {args.out_filename}')

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
        args.infile = open(args.file_name, 'r') # reload the file

class Formatter(argparse.ArgumentDefaultsHelpFormatter,
                argparse.RawDescriptionHelpFormatter):
    pass

def main():
    argparser_param = {
        'description': DESCRIPTION,
        'epilog': EPILOG,
        'formatter_class': Formatter,
    }
    parser = argparse.ArgumentParser(**argparser_param)
    parser.add_argument('infile', type=argparse.FileType('r'), default='-')
    parser.add_argument('-o', '--out-filename')
    parser.add_argument('-s', '--style', choices=CSS_MAP.keys(),
                        default='default', help='style name')
    parser.add_argument('-m', '--monitor', action='store_true',
                        help='recreate if infile is modified')
    args = parser.parse_args()

    if args.out_filename is None:
        args.out_filename = args.infile.name + '.html'

    print(f'Input : {args.infile.name}')
    print(f'Output: {args.out_filename}')
    print(f'Style : {args.style}')
    run(args)


if __name__ == '__main__':
    main()
