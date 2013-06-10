#!/usr/bin/env python
import sys
from struct import *

# -----------------------------------------------------------------------------
# main routine
# -----------------------------------------------------------------------------
while True:
  c = sys.stdin.read(2);
  if (len(c) < 2):
    break
  num = int(c, 16)
  sys.stdout.write(pack('B', num))
