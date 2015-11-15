#!/usr/bin/env python

import urllib
import urllib2
import argparse
import socket

IP_CHECK_URL = "http://ieserver.net/ipcheck.shtml"
UPDATE_URL = "http://ieserver.net/cgi-bin/dip.cgi"

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("username", type=str)
    parser.add_argument("password", type=str)
    parser.add_argument("--domain", type=str, default="dip.jp")
    parser.add_argument("--page-code", type=str, default="euc_jp")
    parser.add_argument("-f", "--force-update", action="store_true")
    args = parser.parse_args()

    # Get the public IP address
    response = urllib2.urlopen(IP_CHECK_URL)
    my_addr = response.read()
    print "Public addr.: %s" % my_addr

    # Get the public address
    print "Force update: %s" % args.force_update
    hostname = "%s.%s" % (args.username, args.domain)
    dns_addr = socket.gethostbyname(hostname)
    if not args.force_update and my_addr == dns_addr:
        print "Skip IP addr. update"
        return

    params = {
        "username": args.username,
        "domain": args.domain,
        "password": args.password,
        "updatehost": 1,
    }
    url = UPDATE_URL + "?" + urllib.urlencode(params)
    response = urllib2.urlopen(url)
    page_html = response.read()
    print page_html.decode(args.page_code)

if __name__ == "__main__":
    main()
