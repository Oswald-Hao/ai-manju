# AI 漫剧制作工作流

基于 FLUX.1 Dev + ComfyUI + LoRA + Wan2.1 的本地全开源漫剧生产线。

## 项目结构

```
ai-manju/
├── setup/
│   ├── install.sh          # 一键安装所有环境
│   ├── comfyui_commit.txt  # ComfyUI 锁定版本
│   └── kohya_commit.txt    # kohya_ss 锁定版本
├── comfyui/
│   └── flux_manju_workflow.json  # FLUX.1 生图工作流
├── lora/
│   ├── config/
│   │   └── flux_lora_train.toml  # LoRA 训练配置
│   ├── dataset/                  # 训练素材（角色参考图+标注）
│   │   └── character_01/
│   │       └── 10_character01/   # 孙悟空训练图 x40
│   └── train.sh                  # 启动训练
├── scripts/
│   ├── ep01_prompts.json         # 第一集14幕分镜提示词
│   ├── batch_generate.py         # 批量生成分镜图
│   └── img2video.sh              # 分镜图转视频片段
├── docs/
│   └── MODELS.md                 # 模型下载说明
└── workflows/                    # 预留：更多工作流
```

## 快速开始

```bash
git clone https://github.com/Oswald-Hao/ai-manju
cd ai-manju
bash setup/install.sh
```

安装完成后启动 ComfyUI：
```bash
source .venv/bin/activate
python ComfyUI/main.py --listen
# 浏览器打开 http://127.0.0.1:8188
```

## 制作流程

```
1. LoRA训练（固定角色外形）
   bash lora/train.sh

2. 批量生成分镜图
   source .venv/bin/activate
   python scripts/batch_generate.py --lora wukong_v1.safetensors

3. 分镜图转视频
   bash scripts/img2video.sh output/ep01/shot_01.png

4. 剪辑合成（DaVinci / 剪映）
```

## 不在此仓库的内容

| 内容 | 原因 | 获取方式 |
|------|------|---------|
| AI 模型文件（*.safetensors） | 单文件 >100MB，超出 GitHub 限制 | 见 [docs/MODELS.md](docs/MODELS.md) |
| LoRA 训练输出 | 二进制大文件 | HuggingFace: Oswald-Hao/ai-manju-lora |
| ComfyUI / kohya_ss 源码 | 第三方仓库，install.sh 自动克隆 | 见 setup/comfyui_commit.txt |
| .venv 虚拟环境 | 本地生成，无需同步 | install.sh 自动创建 |
| output/ 生成图片视频 | 体积大，属于制作产物 | 本地保留 |

## 硬件建议

| 配置 | 最低 | 推荐 |
|------|------|------|
| GPU 显存 | 16GB（RTX 4060 Ti） | 24GB（RTX 4090） |
| 内存 | 32GB | 64GB |
| 硬盘 | NVMe 1TB | NVMe 2TB + HDD 4TB |

## 当前项目

**《悟空·山海志》第一集：混沌之门**

孙悟空误入山海经世界，遭遇上古凶兽饕餮，展开史诗级对决。
- 角色 LoRA：孙悟空（基于 Safebooru 40张参考图训练）
- 分镜：14幕，完整剧本见 `scripts/ep01_prompts.json`
