# 模型下载说明

以下模型因文件过大无法托管在 GitHub，需要手动下载。
运行 `bash setup/install.sh` 会自动引导下载。

---

## 必须下载

### FLUX.1 Dev（生图主模型）
- **大小**: 23GB
- **来源**: https://huggingface.co/black-forest-labs/FLUX.1-dev
- **需要**: 接受许可协议 + HuggingFace Token
- **放到**: `ComfyUI/models/diffusion_models/flux1-dev.safetensors`

### FLUX.1 VAE
- **大小**: 320MB
- **来源**: 同上仓库 `ae.safetensors`
- **放到**: `ComfyUI/models/vae/ae.safetensors`

### 文本编码器
- **大小**: ~15GB（三个文件）
- **来源**: https://huggingface.co/comfyanonymous/flux_text_encoders
- **放到**: `ComfyUI/models/text_encoders/`
  - `clip_l.safetensors`
  - `t5xxl_fp8_e4m3fn.safetensors`
  - `t5xxl_fp16.safetensors`

### Wan2.1-T2V-1.3B（图转视频）
- **大小**: 12GB
- **来源**: https://huggingface.co/Wan-AI/Wan2.1-T2V-1.3B
- **放到**: `ComfyUI/models/wan2.1/Wan2.1-T2V-1.3B/`

---

## LoRA 角色模型

训练完成的 LoRA 文件托管在 HuggingFace：
- **孙悟空 v1**: https://huggingface.co/Oswald-Hao/ai-manju-lora（训练完后上传）
- **放到**: `ComfyUI/models/loras/`

---

## 第三方工具（install.sh 自动克隆）

| 工具 | 仓库 | 锁定版本 |
|------|------|---------|
| ComfyUI | github.com/comfyanonymous/ComfyUI | `33799c4` |
| ComfyUI-Manager | github.com/ltdrdata/ComfyUI-Manager | `2d37344` |
| ComfyUI-WanVideoWrapper | github.com/kijai/ComfyUI-WanVideoWrapper | `088128b` |
| kohya_ss | github.com/bmaltais/kohya_ss | `4161d1d` |
