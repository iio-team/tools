#!/bin/bash

if [ "$1" == "" ]; then
    echo "usage: $(basename "$0") name"
    exit 0
fi

name=$1
folder=`realpath "${0%.sh}"`
fname=`basename "$0" .sh`

echo "This script will create a new empty task of name \"$name\" into the current folder."
if [ ! -f contest.yaml ]; then
    echo "FATAL ERROR: the current folder is not a contest folder."
    exit 1
fi
echo "Press enter to proceed, CTRL-C to quit..."
read x

mkdir "$name"
mkdir "$name/att"
mkdir "$name/check"
mkdir "$name/editorial"
mkdir "$name/gen"
mkdir "$name/sol"
mkdir "$name/statement"
cp "$folder/task.yaml.orig" "$name/task.yaml.orig"
cp "$folder/inout.slide" "$name/inout.slide"
grep -v "brief" "$folder/t.c" > "$name/att/$name.c"
grep -v "brief" "$folder/t.cpp" > "$name/att/$name.cpp"
grep -v "NOTE" "$folder/t.cpp" > "$name/sol/solution.cpp"
sed "s/__TASK_NAME__/$name/g" "$folder/t.java" > "$name/att/$name.java"
cat "$folder/t.pas" > "$name/att/$name.pas"
grep -v "brief" "$folder/t.py" > "$name/att/$name.py"
grep -v "NOTE" "$folder/t.py" > "$name/sol/solution_py.py"
ln -s "../att/$name.c" "$name/sol/template_c.c"
ln -s "../att/$name.cpp" "$name/sol/template_cpp.cpp"
ln -s "../att/$name.py" "$name/sol/template_py.py"
ln -s "../statement/$name.input0.txt" "$name/att/input0.txt"
ln -s "../statement/$name.input1.txt" "$name/att/input1.txt"
ln -s "../statement/$name.output0.txt" "$name/att/output0.txt"
ln -s "../statement/$name.output1.txt" "$name/att/output1.txt"
sed "s/__TASK_NAME__/$name/g" "$folder/statement/english.tex" > "$name/statement/english.tex"
touch "$name/statement/english.pdf"
cat <<EOF > "$name/statement/$name.input0.txt"
1
10
EOF
cat <<EOF > "$name/statement/$name.input1.txt"
2
3 7
EOF
echo 42 > "$name/statement/$name.output0.txt"
echo 42 > "$name/statement/$name.output1.txt"
ln -s "../../../tools/$fname/logo.pdf" "$name/statement/logo.pdf"
ln -s "../../../tools/$fname/logo.pdf" "$name/editorial/logo.pdf"
sed "s/__TASK_NAME__/$name/g" "$folder/generator.py" > "$name/gen/generator.py"
sed "s/__TASK_NAME__/$name/g" "$folder/GEN" > "$name/gen/GEN"
cp "$folder"/{constraints.py,validator.py} "$name/gen/"
cp "$folder/checker.cpp" "$name/check/"
chmod a+x "$name/gen/generator.py"
cp "$folder/editorial/english.tex" "$name/editorial/"

# append new task name in a way that works on both GNU- and BSD/macOS-sed
if sed --version >/dev/null 2>&1; then
  # GNU sed
  sed -i "s/^tasks:$/tasks:\n- $name/" contest.yaml
else
  # BSD/macOS sed
  sed -i '' "/^tasks:$/a\\
- $name
" contest.yaml
fi
