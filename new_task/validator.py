#!/usr/bin/env python3

from limiti import *

import sys
import os


def usage():
    print("Usage: %s file_input.txt [subtask_number]" % sys.argv[0], file=sys.stderr)
    exit(1)


def run(f, st):
    for k, v in subtasks[st].items():
        globals()[k] = v

    N = int(next(f))
    assert 1 <= N <= MAX_N

    V = list(map(int, next(f).split()))
    assert len(V) == N
    
    assert all(0 <= v <= MAX_V for v in V)

    assert next(f, None) is None

if __name__ == "__main__":
    if len(sys.argv) < 2:
        usage()

    # Di default, ignora i subtask
    st = 0

    if len(sys.argv) == 3:
        st = int(sys.argv[2])

    f = open(sys.argv[1])
    run(f, st)
