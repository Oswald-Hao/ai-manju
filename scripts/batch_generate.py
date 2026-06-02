#!/usr/bin/env python3
"""
批量生成分镜图脚本
用法: python batch_generate.py --lora wukong_v1.safetensors
"""
import json, requests, time, argparse, os

COMFYUI_URL = "http://127.0.0.1:8188"
OUTPUT_DIR   = "/home/lejurobot/ai-manju/output/ep01"
PROMPTS_FILE = "/home/lejurobot/ai-manju/scripts/ep01_prompts.json"
LORA_DIR     = "/home/lejurobot/ai-manju/lora/output"

os.makedirs(OUTPUT_DIR, exist_ok=True)

def build_workflow(shot, lora_name):
    w, h = shot["size"].split("x")
    return {
        "1": {"class_type": "UNETLoader",        "inputs": {"unet_name": "flux1-dev.safetensors", "weight_dtype": "fp8_e4m3fn"}},
        "2": {"class_type": "DualCLIPLoader",    "inputs": {"clip_name1": "clip_l.safetensors", "clip_name2": "t5xxl_fp8_e4m3fn.safetensors", "type": "flux"}},
        "3": {"class_type": "VAELoader",         "inputs": {"vae_name": "ae.safetensors"}},
        "4": {"class_type": "LoraLoader",        "inputs": {"model": ["1", 0], "clip": ["2", 0], "lora_name": lora_name, "strength_model": 0.85, "strength_clip": 0.85}},
        "5": {"class_type": "CLIPTextEncode",    "inputs": {"clip": ["4", 1], "text": shot["prompt"]}},
        "6": {"class_type": "CLIPTextEncode",    "inputs": {"clip": ["4", 1], "text": shot["negative"]}},
        "7": {"class_type": "EmptyLatentImage",  "inputs": {"width": int(w), "height": int(h), "batch_size": 1}},
        "8": {"class_type": "ModelSamplingFlux", "inputs": {"model": ["4", 0], "max_shift": 1.15, "base_shift": 0.5}},
        "9": {"class_type": "FluxGuidance",      "inputs": {"conditioning": ["5", 0], "guidance": 3.5}},
        "10": {"class_type": "KSampler",         "inputs": {"model": ["8", 0], "positive": ["9", 0], "negative": ["6", 0], "latent_image": ["7", 0], "seed": shot["seed"], "steps": 25, "cfg": 1.0, "sampler_name": "euler", "scheduler": "simple", "denoise": 1.0}},
        "11": {"class_type": "VAEDecode",        "inputs": {"samples": ["10", 0], "vae": ["3", 0]}},
        "12": {"class_type": "SaveImage",        "inputs": {"images": ["11", 0], "filename_prefix": f"ep01/shot_{shot['shot']:02d}_"}},
    }

def queue_prompt(workflow):
    r = requests.post(f"{COMFYUI_URL}/prompt", json={"prompt": workflow})
    return r.json().get("prompt_id")

def wait_done(prompt_id):
    while True:
        r = requests.get(f"{COMFYUI_URL}/history/{prompt_id}").json()
        if prompt_id in r:
            return r[prompt_id]
        time.sleep(2)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--lora", default="wukong_v1.safetensors")
    args = parser.parse_args()

    shots = json.load(open(PROMPTS_FILE))
    print(f"共 {len(shots)} 幕，使用LoRA: {args.lora}\n")

    for shot in shots:
        print(f"生成第 {shot['shot']:02d} 幕: {shot['desc']} ...", end=" ", flush=True)
        wf = build_workflow(shot, args.lora)
        pid = queue_prompt(wf)
        wait_done(pid)
        print("✅")

    print(f"\n全部完成！图片保存在: {OUTPUT_DIR}")

if __name__ == "__main__":
    main()
