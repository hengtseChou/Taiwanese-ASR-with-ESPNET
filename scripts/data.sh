#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

log() {
    local fname=${BASH_SOURCE[1]##*/}
    echo -e "$(date '+%Y-%m-%dT%H:%M:%S') (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $*"
}

SECONDS=0
raw_data_root=./downloads
train_val_ratio=0.8

log "$0 $*"
. utils/parse_options.sh

if [ $# -ne 0 ]; then
    log "Error: No positional arguments are required."
    exit 2
fi

. ./path.sh
. ./cmd.sh

# prepare things in Kaldi format
log "data preparation"

mkdir -p data/{train,val,test}
python3 local/data_prep.py $raw_data_root

for x in train val; do
    for f in text wav.scp utt2spk; do
        sort data/${x}/${f} -o data/${x}/${f}
    done
    utils/utt2spk_to_spk2utt.pl data/${x}/utt2spk > data/${x}/spk2utt
done

for f in wav.scp utt2spk; do
    sort data/test/${f} -o data/test/${f}
done
utils/utt2spk_to_spk2utt.pl data/test/utt2spk > data/test/spk2utt

log "Successfully finished. [elapsed=${SECONDS}s]"
