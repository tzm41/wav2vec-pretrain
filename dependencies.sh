#!/usr/bin/env bash

# fairseq
git clone https://github.com/pytorch/fairseq
cd fairseq
pip install --editable ./

cd ..

#apex
git clone https://github.com/NVIDIA/apex
cd apex
pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext"  --global-option="--deprecated_fused_adam" --global-option="--xentropy"  --global-option="--fast_multihead_attn" ./

cd ..

# soundfile
pip install soundfile
sudo apt-get install libsndfile1

# editdistance
pip install editdistance
