#!/bin/bash
set -e
if [[ $# != 2 ]]; then
    echo "Usage: $0 old_name new_name"
    exit 1
fi

if [[ $(basename "$PWD") != $1 ]]; then
    echo "Please run this script in the task directory"
    exit 1
fi

set -x
# rename file names
for f in $(find ./ -name "*$1*"); do
    # rename file names if not image
    if [[ "$f" == *"$1"* ]] && [[ "$f" != *".png" ]] && [[ "$f" != *".jpg" ]] && [[ "$f" != *".jpeg" ]] && [[ "$f" != *".pdf" ]];then
        echo "renaming $f"
        mv "$f" "${f//$1/$2}"
    fi
done


for f in $(find ./); do
    # rename java class
    if [[ "$f" == *".java" ]];then
        echo "renaming class of $f"
        sed -i "s/class $1/class $2/" $f
    fi

    # fix symlinks
    if [[ -L $file ]];then
        echo "fixing symlink $f"
        old_path=$(readlink $f)
        new_path="${old_path//$1/$2}"
        rm $f
        ln -s $new_path $f
    fi

    #fix testo
    if [[ "$f" == *".tex" ]];then
        echo "fixing file $f"
        sed -i "s/$1.\*/$2.\*/" $f
        sed -i "s/$1.input/$2.input/" $f
        sed -i "s/$1.output/$2.output/" $f
    fi
done

# replace in task.yaml
echo "fixing task.yaml and GEN"
sed -i "s/name: $1/name: $2/" task.yaml
sed -i "s/$1.input/$2.input/" gen/GEN

# fix contest.yaml
echo "fixing contest.yaml"
if [ -f ../contest.yaml ]; then
    sed -i "s/^- $1$/- $2/" ../contest.yaml
else
    echo "contest.yaml not found."
fi

#rename current directory
echo "renaming directory"
mv ../{$1,$2}