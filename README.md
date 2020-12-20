# wav2vec-pretrain
Evaluating wav2vec pre-training efficiency.

This experiment explores the relationship between pre-training data set size and the finetuned model performance when using wav2vec 2.0 model.

The following instructions assume there is a `wav2vec` directory under user directory to contain all the related files.

## Prerequisites

Run `dependencies.sh` to install dependencies.

## Data

Run `data.sh` to download LibriSpeech sound data.

### Create manifest

In `fairseq` directory, run

```
python examples/wav2vec/wav2vec_manifest.py ~/wav2vec/LibriSpeech/train-clean-100 --dest ~/wav2vec/LibriSpeech/train-clean-100 --ext flac --valid-percent 0.01
```

### Generate labels for fine-tuning

Generate labels for fine-tuning by gathering 3 hours of recording from `test-clean` set (324 minutes in total, 55% is about 3 hours).

```
python examples/wav2vec/wav2vec_manifest.py ~/wav2vec/LibriSpeech/test-clean --dest ~/wav2vec/LibriSpeech/test-clean --ext flac --valid-percent 0.45
python ~/wav2vec/fairseq/examples/wav2vec/libri_labels.py /home/user/wav2vec/LibriSpeech/test-clean/train.tsv --output-dir /home/user/wav2vec/LibriSpeech/test-clean/ --output-name train
python ~/wav2vec/fairseq/examples/wav2vec/libri_labels.py /home/user/wav2vec/LibriSpeech/test-clean/valid.tsv --output-dir /home/user/wav2vec/LibriSpeech/test-clean/ --output-name valid
```

## Pre-training

Our config file `wav2vec2_base_librispeech.yaml` was modified from the example file. After that, run training with:

```
fairseq-hydra-train task.data=/home/user/wav2vec/LibriSpeech/train-clean-100 --config-dir ~/wav2vec/fairseq/examples/wav2vec/config/pretraining --config-name wav2vec2_base_librispeech
```

## Fine-tuning

Our config file `base_1h.yaml` was modified from the example file. After that, fine-tune pre-trained model with CTC:

```
fairseq-hydra-train task.data=/home/user/wav2vec/LibriSpeech/test-clean/ model.w2v_path=[path-to-pretrained-model] --config-dir ~/wav2vec/fairseq/examples/wav2vec/config/finetuning --config-name base_1h
```

## Evaluation

```
python examples/speech_recognition/infer.py ~/wav2vec/LibriSpeech/test-clean --task audio_pretraining --nbest 1 --path [path-to-fintuned-model] --gen-subset train --results-path ~/wav2vec/models --w2l-decoder viterbi --criterion ctc --labels ltr --max-tokens 4000000 --post-process letter
```
