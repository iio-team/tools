#!/bin/bash

if [ "$1" == "" ]; then
    echo "usage: $(basename "$0") name"
    exit 0
fi

name=$1
folder=`realpath "${0%.sh}"`
fname=`basename $0 .sh`

echo "This script will create a new empty task of name \"$name\" into the current folder."
if [ ! -f contest.yaml ]; then
    echo "FATAL ERROR: the current folder is not a contest folder."
    exit 1
fi
echo "Press enter to proceed, CTRL-C to quit..."
read x

up=`echo ${name:0:1} | tr 'a-z' 'A-Z'`"${name:1}"
mkdir "$name"
mkdir "$name/att"
mkdir "$name/cor"
mkdir "$name/gen"
mkdir "$name/sol"
mkdir "$name/testo"
cat "$folder"/task.yaml | sed "s/nome/$name/g;s/Nome/$up/g" > "$name/task.yaml"
cat "$folder"/t.c | grep -v "brief" > "$name/att/$name.c"
cat "$folder"/t.cpp | grep -v "brief" > "$name/att/$name.cpp"
cat "$folder"/t.cpp | grep -v "NOTE" > "$name/sol/soluzione.cpp"
cat "$folder"/t.java | sed "s/nome/$name/g" > "$name/att/$name.java"
cat "$folder"/t.pas > "$name/att/$name.pas"
cat "$folder"/t.py | grep -v "brief" > "$name/att/$name.py"
cat "$folder"/t.py | grep -v "NOTE" > "$name/sol/soluzione_py.py"
ln -s "../att/$name.c" "$name/sol/template_c.c"
ln -s "../att/$name.cpp" "$name/sol/template_cpp.cpp"
ln -s "../att/$name.py" "$name/sol/template_py.py"
ln -s "../testo/$name.input0.txt" "$name/att/input0.txt"
ln -s "../testo/$name.input1.txt" "$name/att/input1.txt"
ln -s "../testo/$name.output0.txt" "$name/att/output0.txt"
ln -s "../testo/$name.output1.txt" "$name/att/output1.txt"
cat "$folder"/english.tex | sed "s/nome/$name/g" > "$name/testo/english.tex"
touch "$name/testo/english.pdf"
echo 1 > "$name/testo/$name.input0.txt"
echo 10 >> "$name/testo/$name.input0.txt"
echo 2 > "$name/testo/$name.input1.txt"
echo 3 7 >> "$name/testo/$name.input1.txt"
echo 42 > "$name/testo/$name.output0.txt"
echo 42 > "$name/testo/$name.output1.txt"
ln -s "english.pdf" "$name/testo/testo.pdf"
ln -s ../../../tools/$fname/logo.pdf "$name/testo/logo.pdf"
cat "$folder"/generatore.py | sed "s/nome/$name/g" > "$name/gen/generatore.py"
cat "$folder"/GEN | sed "s/nome/$name/g" > "$name/gen/GEN"
cp "$folder"/{limiti.py,valida.py} "$name/gen/"
cp "$folder"/correttore.cpp "$name/cor/"
chmod a+x "$name/gen/generatore.py"

mv contest.yaml __temp__
cat __temp__ | sed "s/^tasks:$/tasks:\n- $name/" > contest.yaml
rm __temp__
