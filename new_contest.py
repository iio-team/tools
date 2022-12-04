#!/usr/bin/env python3

import argparse
import datetime
import os.path
from pathlib import Path

import pytz


def day_suffix(day: int):
    if day in (1, 21, 31):
        return "st"
    if day in (2, 22):
        return "nd"
    if day in (3, 23):
        return "rd"
    return "th"


def format_date_range(start: datetime.datetime, stop: datetime.datetime):
    if start.date() == stop.date():
        month = start.strftime("%B")
        suffix = day_suffix(start.day)
        return f"{month} {start.day}{suffix}, {start.year}"
    elif start.month == stop.month:
        month = start.strftime("%B")
        suffix = day_suffix(stop.day)
        return f"{month} {start.day}-{stop.day}{suffix}, {start.year}"
    else:
        start_month = start.strftime("%B")
        start_suffix = day_suffix(start.day)
        stop_month = stop.strftime("%B")
        stop_suffix = day_suffix(stop.day)
        return f"{start_month} {start.day}{start_suffix} to {stop_month} {stop.day}{stop_suffix}, {stop.year}"


def main(args):
    if not os.path.exists(".git"):
        raise RuntimeError("This script should be run from the repo root")

    cwd = os.getcwd()
    if not os.path.basename(cwd).startswith("iiot-202"):
        raise RuntimeError("The current folder does not correspond to a IIOT year")

    start = datetime.datetime.fromisoformat(args.start)
    if not start.tzinfo:
        tz = pytz.timezone("Europe/Rome")
        start = tz.localize(start)

    duration = list(map(int, args.duration.split(":")))
    duration = (duration + [0, 0])[:3]
    duration = datetime.timedelta(
        hours=duration[0],
        minutes=duration[1],
        seconds=duration[2],
    )
    stop = start + duration

    name = f"round{args.round}"
    description = f"IIOT{args.year} -- Round {args.round}"
    date = format_date_range(start, stop)

    with open(Path(__file__).parent / "new_contest" / "countries.yaml") as f:
        countries = f.read()

    contest_yaml = f"""
name: {name}
description: {description}
date: {date}
start: {int(start.timestamp())}
stop: {int(stop.timestamp())}
token_mode: disabled
allow_registration: true
timezone: Europe/Rome
location: Online
logo: logo.pdf

tasks:

{countries}"""

    os.makedirs(name, exist_ok=True)
    with open(Path(name) / "contest.yaml", "w") as f:
        f.write(contest_yaml)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "round",
        type=int,
        help="Number of this round (1-based)",
    )
    parser.add_argument(
        "year",
        help="The IIOT year (not specific to the round)",
    )
    parser.add_argument(
        "start",
        help="Start date of the contest (ISO 8601: yyyy-mm-ddThh:mm:ss+TZ:TZ). Timezone defaults to Europe/Rome",
    )
    parser.add_argument(
        "duration",
        help="Duration (format hh or hh:mm or hh:mm:ss)",
    )

    main(parser.parse_args())
