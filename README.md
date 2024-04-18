# taiwanese-speech-recognition-using-espnet-toolkit-A112092

This is the report of the first Kaggle inClass competition of NYCU-IASS-DL2024. The goal is to make Taiwanese Speech Recognition using ESPnet Toolkit and Self-Supervised Pre-Trained Model.

**Table of Contents**

<!-- toc -->

- [taiwanese-speech-recognition-using-espnet-toolkit-A112092](#taiwanese-speech-recognition-using-espnet-toolkit-a112092)
  - [Environment](#environment)
  - [Setup](#setup)
  - [Data preparation](#data-preparation)
    - [`data_prep.py`](#data_preppy)
    - [`data.sh`](#datash)
  - [Task 1](#task-1)
    - [Configuration](#configuration)
    - [Training](#training)
    - [Result](#result)
  - [Task 2](#task-2)
    - [Configuration](#configuration-1)
    - [Training](#training-1)
    - [Result](#result-1)
  - [Task 3](#task-3)
    - [Configuration](#configuration-2)
    - [Training](#training-2)
    - [Result](#result-2)
  - [Comparison \& Conclusion](#comparison--conclusion)

<!-- tocstop -->

## Environment

**Basic environments:**

- OS information: Linux 6.5.0-27-generic #28~22.04.1-Ubuntu SMP PREEMPT_DYNAMIC Fri Mar 15 10:51:06 UTC 2 x86_64
- python version: `3.9.19 (main, Mar 21 2024, 17:11:28)  [GCC 11.2.0]`
- espnet version: `espnet 202402`
- pytorch version: `pytorch 2.1.0`
- Git hash: `f6f011d328fb877b098321975280cadf8c64247a`
  - Commit date: `Tue Apr 9 01:44:27 2024 +0000`

**Environments from `torch.utils.collect_env`:**

```
PyTorch version: 2.1.0
Is debug build: False
CUDA used to build PyTorch: 12.1

OS: Ubuntu 22.04.4 LTS (x86_64)
GCC version: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0
Clang version: Could not collect
CMake version: version 3.29.2
Libc version: glibc-2.35

Python version: 3.9.19 (main, Mar 21 2024, 17:11:28)  [GCC 11.2.0] (64-bit runtime)
Python platform: Linux-6.5.0-27-generic-x86_64-with-glibc2.35
Is CUDA available: True
CUDA runtime version: 12.3.107
CUDA_MODULE_LOADING set to: LAZY
GPU models and configuration: GPU 0: NVIDIA GeForce RTX 4080
Nvidia driver version: 535.161.07

Versions of relevant libraries:
[pip3] numpy==1.23.5
[pip3] pytorch-ranger==0.1.1
[pip3] torch==2.1.0
[pip3] torch-complex==0.4.3
[pip3] torch-optimizer==0.3.0
[pip3] torchaudio==2.1.0
[pip3] triton==2.0.0
[conda] blas                      1.0                         mkl
[conda] mkl                       2023.1.0         h213fc3f_46344
[conda] mkl-service               2.4.0            py39h5eee18b_1
[conda] mkl_fft                   1.3.8            py39h5eee18b_0
[conda] mkl_random                1.2.4            py39hdb19cb5_0
[conda] numpy                     1.23.5           py39hf6e8229_1
[conda] numpy-base                1.23.5           py39h060ed82_1
[conda] pytorch                   2.1.0           py3.9_cuda12.1_cudnn8.9.2_0    pytorch
[conda] pytorch-cuda              12.1                 ha16c6d3_5    pytorch
[conda] pytorch-mutex             1.0                        cuda    pytorch
[conda] pytorch-ranger            0.1.1                    pypi_0    pypi
[conda] torch-complex             0.4.3                    pypi_0    pypi
[conda] torch-optimizer           0.3.0                    pypi_0    pypi
[conda] torchaudio                2.1.0                py39_cu121    pytorch
[conda] triton                    2.0.0                    pypi_0    pypi
```

## Setup

Run `setup.sh` under this directory, it will do the following things sequentially:

- Create a directory `nycu-iass-dl2024-taiwanese-asr/` at parent directory.
- Clone espnet into `nycu-iass-dl2024-taiwanese-asr/`.
- Set up a conda environment and install espnet.
- Download and unzip the dataset.
- Remove the unneeded receipes under `espnet/egs2`, and use `TEMPLATE` to generate `my-receipe`.
- Move the dataset into `my-reseipe/asr1/downloads`.
- Copy data preparation scripts, config yamls and run scripts for each task into `my-receipe`.
- Install additional dependencies, such as s3prl, whisper, loralib.

## Data preparation

Two files are copied into `myreceipe/asr1/local`.

### `data_prep.py`

This script has two purposes:

1. Split the original train dataset into train set and valid set randomly.
2. Create `text`, `wav.scp` and `utt2spk` files for train, val and test in Kalid format into `my-receipe/asr1/data`.

### `data.sh`

This script is used in `asr.sh` to:

1. Invoke `data_prep.py`.
2. Sort line order for generated files.
3. Create `spk2utt` files for each set.

## Task 1

### Configuration

### Training

The train and valid accuracy over the training process is as follow:

<p align="center">
  <img src="https://github.com/Deep-Learning-NYCU/taiwanese-speech-recognition-using-espnet-toolkit-A112092/blob/main/img/task1/acc.png?raw=true" alt="acc-task1"/>
</p>

We can see that even though being diverged for a while, the valid accuracy stays quite close with the train accuracy, and both values grow over the training process.

<p align="center">
  <img src="https://github.com/Deep-Learning-NYCU/taiwanese-speech-recognition-using-espnet-toolkit-A112092/blob/main/img/task1/loss.png?raw=true" alt="loss-task1"/>
</p>

The loss decreases steadily, and the trend is in correspondence with the training accuracy as well.

<p align="center">
  <img src="https://github.com/Deep-Learning-NYCU/taiwanese-speech-recognition-using-espnet-toolkit-A112092/blob/main/img/task1/wer.png?raw=true" alt="wer-task1"/>
</p>

The trend in wer is similar. All three plots suggest that our training in task 1 is successful.

### Result

The final public wer scoring over the testing data is **0.658**.

## Task 2

### Configuration

### Training

<p align="center">
  <img src="https://github.com/Deep-Learning-NYCU/taiwanese-speech-recognition-using-espnet-toolkit-A112092/blob/main/img/task2/acc.png?raw=true" alt="acc-task2"/>
</p>

<p align="center">
  <img src="https://github.com/Deep-Learning-NYCU/taiwanese-speech-recognition-using-espnet-toolkit-A112092/blob/main/img/task2/loss.png?raw=true" alt="loss-task2"/>
</p>

<p align="center">
  <img src="https://github.com/Deep-Learning-NYCU/taiwanese-speech-recognition-using-espnet-toolkit-A112092/blob/main/img/task2/wer.png?raw=true" alt="wer-task2"/>
</p>

### Result

The final public wer scoring over the testing data is **0.57022**, which has out-performed the model we trained in task 1.

## Task 3

### Configuration

### Training

<p align="center">
  <img src="https://github.com/Deep-Learning-NYCU/taiwanese-speech-recognition-using-espnet-toolkit-A112092/blob/main/img/task3/acc.png?raw=true" alt="acc-task3"/>
</p>

<p align="center">
  <img src="https://github.com/Deep-Learning-NYCU/taiwanese-speech-recognition-using-espnet-toolkit-A112092/blob/main/img/task3/loss.png?raw=true" alt="loss-task3"/>
</p>

<p align="center">
  <img src="https://github.com/Deep-Learning-NYCU/taiwanese-speech-recognition-using-espnet-toolkit-A112092/blob/main/img/task3/wer.png?raw=true" alt="wer-task3"/>
</p>

### Result

The final public wer scoring over the testing data is **0.26092**, which has out-performed the previous two models, and the improvement is greater than the one with task 1 and task 2.

0.26092 (0.38026 when lr=1.0e-4)

## Comparison & Conclusion
