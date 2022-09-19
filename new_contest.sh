#!/bin/bash

if [ $# -lt 5 ]; then
    echo "usage: $(basename "$0") round year date start [date] stop"
    echo
    echo "Round should be a single digit number, and year refers to the IIOT year (not the specific round year)."
    echo "Format for date: mm-dd"
    echo "Format for time: HH:MM (assumed in CET--solar time)"
    exit
fi

MONTHS=( X January February March April May June July August September October November December )
ORDS=( X st nd rd th th th th th th th th th th th th th th th th th st nd rd th th th th th th th st )

round="$1"
year="$2"
shift 2
ds="$1"
hs="$2"
shift 2
if [ "${1:2:1}" == ":" ]; then
    de="$ds"
else
    de="$1"
    shift 1
fi
he="$1"
shift 1
folder=`realpath "${0%.sh}"`
name="round$round"
description="IIOT$year -- Round $round"

echo "This script will create a contest folder for $description."
if ! [[ $(git rev-parse --show-toplevel 2>/dev/null) == "$PWD" ]]; then
    echo "FATAL ERROR: the current folder is not the root of a git repository."
    exit 1
fi
if ! [[ "`basename $PWD`" =~ ^iiot-202[0-9]$ ]]; then
    echo "FATAL ERROR: the current folder does not correspond to a IIOT year."
    exit 1
fi
echo "Press enter to proceed, CTRL-C to quit..."
read x

# true year
if [ "${de:0:2}" -gt 6 ]; then
    dy=$[year-1]
else
    dy=$[year]
fi

# calculate timestamps
function month {
    m="${1:0:2}"
    echo -n "${MONTHS[m]}"
}
function day {
    d="${1:3:2}"
    echo -n "$[d]${ORDS[d]}"
}
if [ "$ds" == "$de" ]; then
    date="`month $ds` `day $ds`, $dy"
elif [ "${ds:0:2}" == "${de:0:2}" ]; then
    d="${ds:3:2}"
    date="`month $ds` $[d]-`day $de`, $dy"
else
    date="`month $ds` `day $ds` to `month $de` `day $de`, $dy"
fi

function timestamp {
    if which gdate > /dev/null; then
        cmd=gdate
    else
        cmd=date
    fi
    m="${2:0:2}"
    d="${2:3:2}"
    $cmd "+%s" -d "$m/$d/$1 $3:00 CET"
}
start=`timestamp $dy $ds $hs`
stop=`timestamp $dy $de $he`
mstop=$[start+108000]
if [ $mstop -lt $stop ]; then
    mstop=$stop
fi

function header {
    echo "name: $name"
    echo "description: $description"
    echo "date: $date"
    echo "start: $start"
    echo "stop: $stop"
    echo "token_mode: disabled"
    echo "allow_registration: true"
    echo "timezone: Europe/Rome"
    echo "location: Online"
    echo "logo: logo.pdf"
    echo
    echo "tasks:"
    echo
    cat "$folder/countries.yaml"
}

mkdir "$name"
header > "$name/contest.yaml"
