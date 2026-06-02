#!/bin/bash
set -e

echo "=== AI 漫剧环境安装 ==="

# 1. Python 虚拟环境
python3 -m venv /home/lejurobot/ai-manju/.venv
source /home/lejurobot/ai-manju/.venv/bin/activate

# 2. ComfyUI
if [ ! -d "/home/lejurobot/ai-manju/ComfyUI" ]; then
  git clone https://github.com/comfyanonymous/ComfyUI /home/lejurobot/ai-manju/ComfyUI
fi
pip install -r /home/lejurobot/ai-manju/ComfyUI/requirements.txt

# 3. ComfyUI Manager
if [ ! -d "/home/lejurobot/ai-manju/ComfyUI/custom_nodes/ComfyUI-Manager" ]; then
  git clone https://github.com/ltdrdata/ComfyUI-Manager \
    /home/lejurobot/ai-manju/ComfyUI/custom_nodes/ComfyUI-Manager
fi

# 4. kohya_ss (LoRA 训练)
if [ ! -d "/home/lejurobot/ai-manju/kohya_ss" ]; then
  git clone https://github.com/bmaltais/kohya_ss /home/lejurobot/ai-manju/kohya_ss
  cd /home/lejurobot/ai-manju/kohya_ss && pip install -r requirements.txt
fi

echo ""
echo "=== 安装完成 ==="
echo "启动 ComfyUI: source .venv/bin/activate && python ComfyUI/main.py --listen"
echo ""
echo "还需手动下载模型:"
echo "  FLUX.1 Dev: https://huggingface.co/black-forest-labs/FLUX.1-dev"
echo "  放到: ComfyUI/models/diffusion_models/"
