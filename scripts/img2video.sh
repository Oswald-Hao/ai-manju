#!/bin/bash
# 把分镜图转成视频片段
# 用法: bash img2video.sh <图片路径>
# 例如: bash img2video.sh output/ep01/shot_01.png

IMAGE=$1
BASENAME=$(basename "$IMAGE" | sed 's/\.[^.]*$//')
OUTPUT="/home/lejurobot/ai-manju/output/ep01/video_${BASENAME}.mp4"
WAN_DIR="/home/lejurobot/ai-manju/ComfyUI/models/wan2.1/Wan2.1-T2V-1.3B"

source /home/lejurobot/ai-manju/.venv/bin/activate
unset ALL_PROXY all_proxy

echo "图转视频: $IMAGE → $OUTPUT"

python /home/lejurobot/ai-manju/ComfyUI/custom_nodes/ComfyUI-WanVideoWrapper/tools/inference.py \
  --model_dir "$WAN_DIR" \
  --image "$IMAGE" \
  --prompt "dynamic scene, cinematic camera movement, anime style" \
  --output "$OUTPUT" \
  --num_frames 49 \
  --fps 16 \
  --resolution 480

echo "完成: $OUTPUT"
