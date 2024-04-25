# taiwanese-speech-recognition-using-espnet-toolkit-A112092

This is the report of the first Kaggle inClass competition of NYCU-IAIS-DL2024, by Heng-Tse Chou (NTHU STAT). The goal is to make Taiwanese Speech Recognition using ESPnet Toolkit and Self-Supervised Pre-Trained Model.

Final wer scores:

- Task 1
  - Public: 0.658
  - Private: 0.62739
- Task 2
  - Public: 0.57022
  - Private: 0.56481
- Task 3
  - Public: 0.26092
  - Private: 0.26828

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

- Create a directory `nycu-iais-dl2024-taiwanese-asr/` at parent directory.
- Clone espnet into `nycu-iais-dl2024-taiwanese-asr/`.
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

In task 1, we choose a **Branchformer** as the encoder, and a **Transformer** as the decoder. A branchformer encoder can efficiently handles long audio sequences, which enables better feature extraction from audio signals. On the other hand, a transformer decoder leverages language modeling capability for accurate transcription, and offers flexibility in modeling language and context.

The training config is modified from `egs2/aishell/asr1/conf/tuning/train_asr_branchformer_e24_amp.yaml`. It is almost identical to the original one, except `batch_bins` are modified as **3000000**, to accomodate the memory limitation from graphic card. 

**Adam** is adopted for the optimizer, with **warmuplr** as the learning rate scheduler. The initial learning rate is set by **1.0e-3**.

In the run script, a data augmentation of **speed perturbation** is specified, and the token type is set as **char**. A character tokenizer operates at the character level and treats each character in the text as a seperate token, which is more suitable for Taiwanese language.

Finally, a maximum number of epochs is set by **60**, to prevent the training being too time-consuming.

### Training

The train and valid accuracy over the training process are shown below.

<p align="center">
  <img src="https://github.com/Deep-Learning-NYCU/taiwanese-speech-recognition-using-espnet-toolkit-A112092/blob/main/img/task1/acc.png?raw=true" alt="acc-task1"/>
</p>

We can see that even though being diverged for a while, the valid accuracy stays quite close with the train accuracy, and both values grow over the training process.

<p align="center">
  <img src="https://github.com/Deep-Learning-NYCU/taiwanese-speech-recognition-using-espnet-toolkit-A112092/blob/main/img/task1/loss.png?raw=true" alt="loss-task1"/>
</p>

The loss decreases with some fluctuations, and its trend is in correspondence with the accuracy as well.

<p align="center">
  <img src="https://github.com/Deep-Learning-NYCU/taiwanese-speech-recognition-using-espnet-toolkit-A112092/blob/main/img/task1/wer.png?raw=true" alt="wer-task1"/>
</p>

The trend in wer is similar. All three plots suggest that our training in task 1 is successful.

### Result

The final wer scoring over the testing data:
- Public: 0.658
- Private: 0.62739

## Task 2

### Configuration

In task 2, we are asked to combine a SSL (Self-Supervised Learning) pre-trained model to ASR, using S3PRL toolkit. 

The training config is modified from `egs2/librispeech/asr1/conf/tuning/train_asr_conformer7_wav2vec2_960hr_large.yaml`. The upstream model adopted here is **WavLM**, which is a type of language model designed to operate directly on raw audio waveforms rather than on text representations. Here we use `wavlm_base` and `batch_bins` is set by **2000000**.

Besides the pre-trained frontend, the encoder adopted in this task is **Conformer**, which leverages the strengths of both convolutional neural networks and transformers to achieve efficient feature extraction. 

The optimizer and the learning rate scheduler are still **adam** and **warmuplr**. The initial learning rate are set to **2.5e-3**.

The run script has the same config as task 1. The maximum number of epochs is set by **35**.

### Training

<p align="center">
  <img src="https://github.com/Deep-Learning-NYCU/taiwanese-speech-recognition-using-espnet-toolkit-A112092/blob/main/img/task2/acc.png?raw=true" alt="acc-task2"/>
</p>

The accuracy grows faster than task 1 over epochs. The increment is not significant after the 24th epoch, so maybe we can set a lower number of maximum epoch to save time.

<p align="center">
  <img src="https://github.com/Deep-Learning-NYCU/taiwanese-speech-recognition-using-espnet-toolkit-A112092/blob/main/img/task2/loss.png?raw=true" alt="loss-task2"/>
</p>

The improvement can also be noticed in the loss.

<p align="center">
  <img src="https://github.com/Deep-Learning-NYCU/taiwanese-speech-recognition-using-espnet-toolkit-A112092/blob/main/img/task2/wer.png?raw=true" alt="wer-task2"/>
</p>

The convergence of wer in task 2 is more faster and stable.

### Result

The final wer scoring over the testing data:
  - Public: 0.57022
  - Private: 0.56481
  
Both scoring are better than task 1. It shows that combining a pre-trained model can improve the performance of a ASR task.

## Task 3

### Configuration

In task 3, we are asked to complete the ASR task with OpenAI Whisper, which is a general-purpose speech recognition model. It is trained on a large dataset of diverse audio and is also a multitasking model that can perform multilingual speech recognition, speech translation, and language identification.

The training config is modified from `egs2/aishell/asr1/conf/tuning/train_asr_whisper_medium_lora_finetune.yaml`. The model size we adopted here for the encoder and the decoder are both the **small** model. The `batch_bins` are set by 3000000.

Moreover, to fintune the whisper model, the adapter `LoRA` is specified. An adapter is layer added to a pre-trained model to adapt it to specific tasks or domains without extensively retraining the entire model. Adapters are designed to introduce task-specific knowledge into a pre-trained model by learning only a small number of parameters, thus preserving the general knowledge learned during pre-training.

The optimizer is set as **adamw**, and the learning rate scheduler is still **warmuplr**. The initial learning rate is set as **1.25e-05**, which is recommended in [this README](https://github.com/vasistalodagala/whisper-finetune).

For the run script, we also specified the tokenizer as **whisper_multilingual**.

In this task, the training of each epoch is more time-consuming, and the valid accuracy did not improve much over epochs, therefore a smaller value of maximum number of epochs, **10**, is used.

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

The final wer scoring over the testing data:
  - Public: 0.26092
  - Private: 0.26828




## Comparison & Conclusion

After 
