# Task Development Tools for the IIOT

This repository contains a selection of task development tools, to be used for the preparation of the rounds of the IIOT. 

## Setup

All tools should be used in a unix bash: either Linux, MacOS, or WSL under Windows. Task development requires task maker: a setup guide for it, including documentation of the main features, is available online [here](https://github.com/edomora97/task-maker-rust#readme).

## Intended workflow

The preparation of an edition of the IIOT should follow the following workflow.

1. Create a new repository for the edition, through tool `new_year.sh` (requires `gh` installed)
1. In this repository, create contests skeletons as they occur through tool `new_contest.sh`
1. In a contest folder, create task skeletons through tool `new_task.sh`
1. Edit the skeleton task until it matches the intended task. The `cor/` folder may be erased, if plain white-diff comparison is sufficient for scoring; the other folders are mandatory. You can find a description of the task format [here](https://github.com/iio-team/tools#task-format-description).
1. As you prepare the task, you can test the solutions (including partial and wrong ones) through task maker, running command `task-maker-rust`
1. Once the task is ready, and all solutions are correctly scored, you can run `task-maker-tools add-solution-checks -i` to store the result 
1. Every time a push is being made to the main branch, GitHub should update a CMS instance running all tasks in the edition 

## Task format description

## Tool list

<details>
<summary>`new_contest.sh`</summary>

More help.

</details>

<details>
<summary>`new_task.sh`</summary>

More help.

</details>

<details>
<summary>`new_year.sh`</summary>

More help.

</details>

<details>
<summary>`update_tools.sh`</summary>

If run in an edition repository, it updates the tools folder to the latest version.

</details>
