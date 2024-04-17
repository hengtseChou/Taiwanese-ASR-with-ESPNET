#!/bin/bash
asr_root=./espnet/egs2/my-receipe/asr1
rm -rf $asr_root/data
rm -rf $asr_root/dump
rm -rf $asr_root/exp
echo "Removed /data, /dump, /exp."