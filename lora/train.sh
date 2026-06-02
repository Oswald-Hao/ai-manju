#!/bin/bash
source /home/lejurobot/ai-manju/.venv/bin/activate
unset ALL_PROXY all_proxy
cd /home/lejurobot/ai-manju/kohya_ss
python flux_train_network.py \
  --config_file /home/lejurobot/ai-manju/lora/config/flux_lora_train.toml
