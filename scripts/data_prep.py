#!/usr/bin/env python3
from argparse import ArgumentParser
import csv
import os
import random

TONELESS = True
SEED = 112092
random.seed(SEED)

parser = ArgumentParser()
parser.add_argument("data_dir", type=str)
parser.add_argument("--split-ratio", dest="split_ratio", type=float, default=0.8)
args = parser.parse_args()
data_dir = args.data_dir
split_ratio = args.split_ratio

### train

transcription_path = os.path.join(data_dir, "train", "train.csv")
if TONELESS is True:
    transcription_path = os.path.join(data_dir, "train", "train-toneless.csv")

with open(transcription_path) as f:
    csv_reader = csv.reader(f)
    transcription = list(csv_reader)

all_idx = list(range(1, len(transcription)))
train_idx = random.sample(all_idx, k=round(len(all_idx) * 0.8))
val_idx = [idx for idx in all_idx if idx not in train_idx]
subset_vs_idx = {"train": train_idx, "val": val_idx}

for subset, idxs in subset_vs_idx.items():

    idxs = sorted(idxs)

    with open(os.path.join("data", subset, "text"), "w") as text_f, open(
        os.path.join("data", subset, "wav.scp"), "w"
    ) as wav_scp_f, open(os.path.join("data", subset, "utt2spk"), "w") as utt2spk_f:

        text_f.truncate()
        wav_scp_f.truncate()
        utt2spk_f.truncate()

        for idx in idxs:

            train_id = transcription[idx][0]
            train_text = transcription[idx][1]
            text_f.write(f"{train_id} {train_text}\n")
            wav_scp_f.write(
                f"{train_id} {os.path.join(data_dir, 'train', 'train', train_id + '.wav')}\n"
            )
            utt2spk_f.write(f"{train_id} Speaker1\n")

### test

test_files = os.listdir(os.path.join(data_dir, "test", "test"))
test_ids = [t.split(".")[0] for t in test_files]

with open(os.path.join("data", "test", "wav.scp"), "w") as wav_scp_f, open(
    os.path.join("data", "test", "utt2spk"), "w"
) as utt2spk_f:

    for test_id in test_ids:

        wav_scp_f.write(
            f"{test_id} {os.path.join(data_dir, 'test', 'test', test_id + '.wav')}\n"
        )
        utt2spk_f.write(f"{test_id} Speaker1\n")
