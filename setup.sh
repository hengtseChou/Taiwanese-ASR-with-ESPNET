#!/bin/bash
# make sure to execute at report1 directory

set -e
set -u
set -o pipefail

log() {
    local fname=${BASH_SOURCE[1]##*/}
    echo -e "$(date '+%Y-%m-%dT%H:%M:%S') (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $*"
}

# create project folder in parent folder
cd ..
mkdir -p nycu-iass-dl2024-taiwanese-asr/
log "created nycu-iass-dl2024-taiwanese-asr/ at parent directory."
log "start cloning espnet."
cd nycu-iass-dl2024-taiwanese-asr
git clone https://github.com/espnet/espnet.git
cd espnet/tools
./setup_anaconda.sh miniconda espnet 3.9
make
log "espnet setup completed."

# download and unzip data
# assume user have api working
cd ../../..
kaggle competitions download -c nycu-iass-dl2024-taiwanese-asr
log "data unzip started."
unzip nycu-iass-dl2024-taiwanese-asr.zip -d nycu-iass-dl2024-taiwanese-asr-data/ > /dev/null
log "data unzip completed."

# create my receipe folder
cd nycu-iass-dl2024-taiwanese-asr
find espnet/egs2/ -mindepth 1 -maxdepth 1 ! -name 'TEMPLATE' -exec rm -rf {} \;
cd espnet
./egs2/TEMPLATE/asr1/setup.sh egs2/my-receipe/asr1
log "my-receipe created in espnet/egs2."

# move data into receipe folder
cd ../..# current dir: espnet/tools

mkdir -p nycu-iass-dl2024-taiwanese-asr/espnet/egs2/my-receipe/asr1/downloads/
mv nycu-iass-dl2024-taiwanese-asr-data/* nycu-iass-dl2024-taiwanese-asr/espnet/egs2/my-receipe/asr1/downloads/
rm -rf nycu-iass-dl2024-taiwanese-asr-data
log "moved data into my-receipe."

# copy scripts and configs into receipe folder
mkdir -p nycu-iass-dl2024-taiwanese-asr/espnet/egs2/my-receipe/asr1/local
cp report1/scripts/data.sh nycu-iass-dl2024-taiwanese-asr/espnet/egs2/my-receipe/asr1/local/data.sh
cp report1/scripts/data_prep.py nycu-iass-dl2024-taiwanese-asr/espnet/egs2/my-receipe/asr1/local/data_prep.py
mkdir -p nycu-iass-dl2024-taiwanese-asr/espnet/egs2/my-receipe/asr1/conf
cp report1/conf/* nycu-iass-dl2024-taiwanese-asr/espnet/egs2/my-receipe/asr1/conf
cp report1/scripts/run_task1.sh nycu-iass-dl2024-taiwanese-asr/espnet/egs2/my-receipe/asr1/run_task1.sh
cp report1/scripts/run_task2.sh nycu-iass-dl2024-taiwanese-asr/espnet/egs2/my-receipe/asr1/run_task2.sh
cp report1/scripts/run_task3.sh nycu-iass-dl2024-taiwanese-asr/espnet/egs2/my-receipe/asr1/run_task3.sh
log "scripts and config files copied into my-receipe."

# install additional dependencies
cd nycu-iass-dl2024-taiwanese-asr/espnet/tools
log "installation of additional dependencies started."
bash -c ". activate_python.sh; ./installers/install_s3prl.sh"
bash -c ". activate_python.sh; ./installers/install_whisper.sh"
bash -c ". activate_python.sh; pip install loralib"
log "installed s3prl, whisper, loralib."
log "project folder nycu-iass-dl2024-taiwanese-asr is ready."

