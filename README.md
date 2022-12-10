# Task Development Tools for the IIOT

This repository contains a selection of task development tools, to be used for the preparation of the rounds of the IIOT.

## Setup

All tools should be used in a unix bash: either Linux, MacOS, or WSL under Windows. Task development requires task maker: a setup guide for it, including documentation of the main features, is available online [here](https://github.com/edomora97/task-maker-rust#readme).

## Intended workflow

The preparation of an edition of the IIOT should follow the following workflow.

1. Create a new repository for the edition, through tool `new_year.sh` (requires `gh` installed).
1. In this repository, create contests skeletons as they occur through tool `new_contest.sh`
1. In a contest folder, create task skeletons through tool `new_task.sh`
1. Edit the skeleton task until it matches the intended task. The `check/` folder may be erased, if plain white-diff comparison is sufficient for scoring; the other folders are mandatory. You can find a description of the task format [here](https://github.com/iio-team/tools#task-format-description).
1. As you prepare the task, you can test the solutions (including partial and wrong ones) through task maker, running command `task-maker-rust`
1. Once the task is ready, and all solutions are correctly scored, you can run `task-maker-tools add-solution-checks -i` to store the result.
1. Every time a push is being made to the main branch, GitHub should update a CMS instance running all tasks in the edition (work in progress).

## Task format description

### Main folder

The main folder only contains the single file `task.yaml`, with general setup information about the task. Some entries are meant to be updated:

- `title`, with a meaningful long title
- `syllabuslevel`, with the actual [syllabus level](https://squadre.olinfo.it/resources/syllabus.pdf) from 1 to 5
- `memory_limit`, with the wanted memory limit
- `time_limit`, with the wanted time limit

 The other entries are unlikely to be modified.

 ### `att` folder

This folder contains files that the contestants can download while browsing the task on CMS. By default those include templates in various languages, and sample input/outputs.

### `check` folder

This folder contains a single source file of a checker, that attributes a score (from 0 to 1) to a test output, knowing the test input and the correct test output. Many tasks do not need a checker, as plain white-diff scoring is sufficient: in that case, the folder can be fully omitted. For the remaining tasks, the skeleton includes a general-purpose checker with safe read operations that can be modified to fit various needs.

### `gen` folder

This folder contains the input generation data, split into few files:
- `limiti.py` with a description of the limits of the various subtasks;
- `validator.py` with a script that double-checks whether an input is valid;
- `generator.py` which generates inputs given some command-line parameters;
- `GEN` which lists the set of parameters to be fed to the generator for each subtask, together with some auxiliary information (subtask score and name).

### `sol` folder

This folder contain the full, partial, and wrong solutions that should be checked for correctness. File `solution.cpp` is used to generate the official output. A Python solution should also be included, in order to know how many points can be scored in Python. Templates are symlinked from the `att` folder, and should produce wrong answers (without crashing). Further solutions, for subtasks or other reasons, can be added here.

### `statement` folder

This folder contains the task statement. The statement is compiled from a (patched) LaTex source `english.tex`, which is provided in the skeleton. The statement is compiled to `english.pdf` by default by task maker, while it tests solutions. You can also build only the statement through command:
```
task-maker-tools booklet
```
Pictures to be included in the statement should be added here. Beware that in order to enable booklet compilation, pictures should have unique names **across different tasks in a same contest**. It is therefore suggested to name pictures taking inspiration from the task name.

## Tool list

<details>
<summary>new_contest.py</summary>

Creates a contest main folder. Requires to specify the round number, the year, the start and duration of the contest.

</details>

<details>
<summary>new_task.sh</summary>

Creates a task skeleton, given its name.

</details>

<details>
<summary>new_year.sh</summary>

Creates an edition repository, given the year.

</details>

<details>
<summary>update_tools.sh</summary>

If run in an edition repository, it updates the tools folder to the latest version.

</details>
<summary>rename_task.sh</summary>

If run in an task repository, given its current name and a new one, it renames the task.

</details>
