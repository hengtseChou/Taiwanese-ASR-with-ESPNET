# taiwanese-speech-recognition-using-espnet-toolkit-A112092

img link example:

![acc](https://github.com/Deep-Learning-NYCU/taiwanese-speech-recognition-using-espnet-toolkit-A112092/blob/main/img/task2/acc.png)


<p align="center">
  <img src="https://github.com/Deep-Learning-NYCU/taiwanese-speech-recognition-using-espnet-toolkit-A112092/blob/main/img/task2/acc.png?raw=true" alt="acc"/>
</p>

## Environment

## Setup

Run `setup.sh` under this directory, it will do the following things sequentially:

- Create a directory `nycu-iass-dl2024-taiwanese-asr` at parent directory.
- Clone `espnet` into `nycu-iass-dl2024-taiwanese-asr`.
- Set up a conda environment and install espnet.
- Download and unzip the dataset.
- Under `espnet/egs2`, remove the unneeded receipes, and use `TEMPLATE` to generate `my-receipe`.
- Move the dataset into `my-reseipe/asr1/downloads`.
- Copy data preparation scripts, config yamls and run scripts for each task into `my-receipe`.
- Install additional dependencies, such as s3prl, whisper, loralib.


task 1: 0.65800
task 2: 0.57022
task 3: 0.26092 (0.38026 when lr=1.0e-4)


**Basic environments:**
You can obtain them by the following command
```
cd <espnet-root>/tools
. ./activate_python.sh

echo "- OS information: `uname -mrsv`"
python3 << EOF
import sys, espnet, torch
pyversion = sys.version.replace('\n', ' ')
print(f"""- python version: \`{pyversion}\`
- espnet version: \`espnet {espnet.__version__}\`
- pytorch version: \`pytorch {torch.__version__}\`""")
EOF
cat << EOF
- Git hash: \`$(git rev-parse HEAD)\`
  - Commit date: \`$(git log -1 --format='%cd')\`
EOF
```

**Environments from `torch.utils.collect_env`:**
e.g.,
```

```
You can obtain them by the following command

```
cd <espnet-root>/tools
. ./activate_python.sh
python3 -m torch.utils.collect_env
```


## Task 1


## Task 2


## Task 3