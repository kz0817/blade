#!/usr/bin/env python

import urllib
import urllib2
import argparse

IP_CHECK_URL = "http://ieserver.net/ipcheck.shtml"
UPDATE_URL = "http://ieserver.net/cgi-bin/dip.cgi"

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("username", type=str)
    parser.add_argument("password", type=str)
    parser.add_argument("--domain", type=str, default="dip.jp")
    args = parser.parse_args()

    response = urllib2.urlopen(IP_CHECK_URL)
    my_addr = response.read()
    print "Public addr.: %s" % my_addr

    params = {
        "username": args.username,
        "domain": args.domain,
        "password": args.password,
        "updatehost": 1,
    }
    url = UPDATE_URL + "?" + urllib.urlencode(params)
    response = urllib2.urlopen(url)
    print response.read()

if __name__ == "__main__":
    main()
