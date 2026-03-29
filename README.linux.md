# Linux Setup Guide for Autoresearch

## System Requirements

Your Lenovo Legion 7 with RTX 2070 Super Mobile is **fully compatible** with this repository.

### Hardware Specs (Detected)
- **GPU**: NVIDIA GeForce RTX 2070 Super with Max-Q Design (8GB VRAM)
- **CPU**: Intel Core i7-10750H (6 cores, 12 threads)
- **RAM**: 32 GB
- **Storage**: Samsung NVMe SSD (sufficient space available)
- **OS**: CachyOS (Arch Linux-based)

## Quick Setup

### Option 1: Use the Setup Script (Recommended)

```bash
cd /workspace
./setup.sh
```

This script will:
1. Detect your NVIDIA GPU
2. Install `uv` package manager if needed
3. Configure PyTorch with CUDA support
4. Install all dependencies

### Option 2: Manual Installation

#### Step 1: Install uv (if not already installed)

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env
export PATH="$HOME/.local/bin:$PATH"
```

#### Step 2: Verify NVIDIA Drivers

Your system has driver version 595.58.03 which is excellent. Verify with:

```bash
nvidia-smi
```

Expected output should show your RTX 2070 Super.

#### Step 3: Install Dependencies

```bash
cd /workspace
uv sync
```

This installs PyTorch 2.9.1 with CUDA 12.8 support, optimized for your Turing architecture GPU.

## Running Experiments

### 1. Prepare Data and Tokenizer (~2 minutes)

```bash
uv run prepare.py
```

### 2. Run a Training Experiment (~5 minutes)

```bash
uv run train.py
```

The experiment will:
- Train for exactly 5 minutes (wall clock time)
- Report validation bits-per-byte (val_bpb) metric
- Log results to `results.tsv`

### 3. Start the Autonomous Agent

Open `program.md` for agent instructions, then launch your preferred coding agent:

> "Hi, have a look at program.md and let's kick off a new experiment!"

## Performance Expectations

With your RTX 2070 Super Mobile (8GB):
- **~10-12 experiments per hour**
- **~100 experiments overnight**
- Flash Attention 3 will auto-detect and optimize for your Turing GPU

## Troubleshooting

### Issue: "No space left on device" during installation

The environment has limited disk space. Clear cache and retry:

```bash
rm -rf /root/.cache/uv
uv sync --no-cache
```

### Issue: CUDA out of memory

Reduce batch size or model dimensions in `train.py`. Your 8GB VRAM should handle the default config.

### Issue: nvidia-smi not found

Ensure NVIDIA drivers are properly loaded:

```bash
sudo modprobe nvidia
sudo systemctl restart sddm  # if using Wayland/X11
```

## Architecture-Specific Optimizations

Your Turing GPU (TU104) supports:
- ✅ FP16 mixed precision training
- ✅ Tensor Cores (accelerates matrix operations)
- ✅ Flash Attention (auto-enabled)
- ✅ CUDA 12.8 (full compatibility)

The default configuration is already optimized for your hardware.

## Next Steps

After setup:
1. Run `uv run prepare.py` to download data
2. Test with `uv run train.py`
3. Review `program.md` for autonomous agent instructions
4. Launch your AI coding assistant to begin automated research!

---

**Note**: This repo is designed for single-GPU systems. Your laptop is an ideal setup.
