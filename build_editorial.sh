#!/bin/bash

if [ "$1" == "--help" ]; then
    echo "usage: $(basename "$0") [name]"
    echo "This script must be run from a contest folder."
    echo "If [name] is specified, it builds the editorial pdf for task [name]. Otherwise, it builds the editorial for the whole contest."
    exit 0
fi

name=$1
folder=`realpath "${0%.sh}"`
fname=`basename "$0" .sh`
language="english"

if [ ! -f contest.yaml ]; then
    echo "FATAL ERROR: the current folder is not a contest folder."
    exit 1
fi

description=`awk -F': ' '/description:/{print $2}' contest.yaml`
date=`awk -F': ' '/date:/{print $2}' contest.yaml`
location=`awk -F': ' '/location:/{print $2}' contest.yaml`
logo=`awk -F': ' '/logo:/{print $2}' contest.yaml`
if [ "$name" == "" ]; then
    name=`awk '/tasks:/,/^$/{if($2 != ""){print $2}}' contest.yaml`
fi

if [ -d "temp" ]; then
    rm -rf "temp"
fi
mkdir "temp"
mkdir "temp/locale"
cp "$folder/cms-contest.cls" "temp/cms-contest.cls"
cp "$folder/locale/$language.tex" "temp/locale/$language.tex"
sed "s/__LANGUAGE__/$language/g" "$folder/editorial.tex" > "temp/_editorial.tex"
sed "s/__DESCRIPTION__/$description/g" temp/_editorial.tex > "temp/__editorial.tex"
sed "s/__DATE__/$date/g" temp/__editorial.tex > "temp/_editorial.tex"
sed "s/__LOCATION__/$location/g" temp/_editorial.tex > "temp/__editorial.tex"
sed "s/__LOGO__/$logo/g" temp/__editorial.tex > "temp/editorial.tex"

for task in $name; do
    title=`awk -F': ' '/title:/{print $2}' $task/task.yaml.orig`
    author=`awk -F': ' '/author:/{print $2}' $task/task.yaml.orig`
    developer=`awk -F': ' '/developer:/{print $2}' $task/task.yaml.orig`
    syllabuslevel=`awk -F': ' '/syllabuslevel:/{print $2}' $task/task.yaml.orig`
    mkdir "temp/$task"
    cp -r "$task/editorial/"* "temp/$task/"
    sed "s/__NAME__/$task/g" "$folder/problem.tex" > "temp/_$task.tex"
    sed "s/__TITLE__/$title/g" "temp/_$task.tex" > "temp/__$task.tex"
    sed "s/__SYLLABUSLEVEL__/$syllabuslevel/g" "temp/__$task.tex" > "temp/_$task.tex"
    sed "s/__AUTHOR__/$author/g" "temp/_$task.tex" > "temp/__$task.tex"
    sed "s/__DEVELOPER__/$developer/g" "temp/__$task.tex" > "temp/_$task.tex"
    sed "s/__SOLUTION_BODY__/$task\/$language.tex/g" "temp/_$task.tex" > "temp/$task/$task.tex"
    cp "$task/editorial/$language.tex" "temp/$task/$language.tex"
    ln -r -sf "$task/editorial/logo.pdf" "temp/logo.pdf"
    sed "s/%__PROBLEM__/\\\import{$task}{$task.tex}\n%__PROBLEM__/g" "temp/editorial.tex" > "temp/_editorial.tex"
    cp "temp/_editorial.tex" "temp/editorial.tex"
done

cd "temp"
pdflatex "editorial.tex"
pdflatex "editorial.tex"
cd ".."
cp "temp/editorial.pdf" "."

#rm -rf "temp"
