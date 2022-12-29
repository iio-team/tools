#!/usr/bin/env python3

from limiti import *
from sys import argv, exit, stderr
import os
from random import random, randint, choice, sample, shuffle, seed
from inspect import signature

usage = """Generator for "__TASK_NAME__".

Parameters:
* N (array length)
* V (maximum value)
* S (seed)

Constraint:
* 1 <= N <= %d
* 0 <= V <= %d
""" % (
    MAX_N,
    MAX_V,
)


def run(N, V):
    for row in reversed(usage.split("\n")[:-1]):
        if row[0] != "*":
            break
        assert eval(row[2:]), row[2:]

    N = randint(1, N)
    V = [randint(0, V) for _ in range(N)]

    print(N)
    print(*V)


if __name__ == "__main__":
    num_args = len(signature(run).parameters) + 2
    if len(argv) != num_args:
        print("Got %d parameters, expecting %d" % (len(argv), num_args), file=stderr)
        print(usage, file=stderr)
        exit(1)

    def tryconv(x):
        for t in [int, float, str]:
            try:
                return t(x)
            except:
                pass

    *args, S = map(tryconv, argv[1:])
    seed(S)
    run(*args)
