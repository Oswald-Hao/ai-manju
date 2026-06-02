#!/bin/bash
set -e
ROOT="/home/$(whoami)/ai-manju"
echo "=== AI 漫剧环境安装 ==="

# 1. Python 虚拟环境
python3 -m venv $ROOT/.venv
source $ROOT/.venv/bin/activate

# 2. ComfyUI
if [ ! -d "$ROOT/ComfyUI" ]; then
  git clone https://github.com/comfyanonymous/ComfyUI $ROOT/ComfyUI
fi
pip install -r $ROOT/ComfyUI/requirements.txt

# 3. ComfyUI-Manager
if [ ! -d "$ROOT/ComfyUI/custom_nodes/ComfyUI-Manager" ]; then
  git clone https://github.com/ltdrdata/ComfyUI-Manager \
    $ROOT/ComfyUI/custom_nodes/ComfyUI-Manager
fi

# 4. Wan2.1 ComfyUI节点
if [ ! -d "$ROOT/ComfyUI/custom_nodes/ComfyUI-WanVideoWrapper" ]; then
  git clone https://github.com/kijai/ComfyUI-WanVideoWrapper \
    $ROOT/ComfyUI/custom_nodes/ComfyUI-WanVideoWrapper
  pip install -r $ROOT/ComfyUI/custom_nodes/ComfyUI-WanVideoWrapper/requirements.txt
fi

# 5. kohya_ss (LoRA训练)
if [ ! -d "$ROOT/kohya_ss" ]; then
  git clone https://github.com/bmaltais/kohya_ss $ROOT/kohya_ss
  cd $ROOT/kohya_ss && git submodule update --init --recursive
  pip install -r requirements.txt
fi
pip install bitsandbytes

# 6. 下载模型（需要HuggingFace Token）
read -p "输入HuggingFace Token (留空跳过): " HF_TOKEN
if [ -n "$HF_TOKEN" ]; then
  echo "--- 下载 FLUX.1 Dev 主模型 (~24GB) ---"
  HF_TOKEN=$HF_TOKEN hf download black-forest-labs/FLUX.1-dev \
    --include "flux1-dev.safetensors" \
    --local-dir $ROOT/ComfyUI/models/diffusion_models/

  echo "--- 下载 VAE + 文本编码器 (~15GB) ---"
  HF_TOKEN=$HF_TOKEN hf download black-forest-labs/FLUX.1-dev \
    --include "ae.safetensors" --local-dir $ROOT/ComfyUI/models/vae/
  HF_TOKEN=$HF_TOKEN hf download comfyanonymous/flux_text_encoders \
    --local-dir $ROOT/ComfyUI/models/text_encoders/

  echo "--- 下载 Wan2.1-1.3B (~12GB) ---"
  HF_TOKEN=$HF_TOKEN hf download Wan-AI/Wan2.1-T2V-1.3B \
    --local-dir $ROOT/ComfyUI/models/wan2.1/Wan2.1-T2V-1.3B
fi

echo ""
echo "=== 安装完成 ==="
echo "启动 ComfyUI: source .venv/bin/activate && python ComfyUI/main.py --listen"
