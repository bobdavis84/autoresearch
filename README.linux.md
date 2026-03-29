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
cd ~/autoresearch  # or wherever you cloned the repo
./setup.sh
```

This script will:
1. Verify your NVIDIA GPU is available
2. Install `uv` package manager if needed
3. Install all dependencies (PyTorch with CUDA support)

### Option 2: Manual Installation

#### Step 1: Install uv (if not already installed)

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
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
cd ~/autoresearch  # or wherever you cloned the repo
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
- **~10-12 experiments per hour** (each experiment is a fixed 5-minute training run)
- **~100 experiments overnight**
- The code uses `kernels-community/flash-attn3` for non-Hopper GPUs (see `train.py:22-24`)
- **MFU % in logs will appear very low** — it's calibrated against H100 peak FLOPS, not your GPU. Ignore it; val_bpb is the metric that matters.

## Troubleshooting

### Issue: "No space left on device" during installation

The environment has limited disk space. Clear cache and retry:

```bash
rm -rf $HOME/.cache/uv
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

## Architecture-Specific Notes

Your Turing GPU (TU104, SM 7.5) supports:
- ✅ BF16/FP16 mixed precision training
- ✅ Tensor Cores (accelerates matrix operations)
- ✅ CUDA 12.8 (full compatibility)
- ⚠️ Flash Attention 3 via community fallback kernel (`kernels-community/flash-attn3`) — if this fails at runtime, the agent can experiment with alternatives

The default configuration should work on your hardware. If you hit OOM, reduce `DEVICE_BATCH_SIZE` or `DEPTH` in `train.py`.

## Next Steps

After setup:
1. Run `uv run prepare.py` to download data
2. Test with `uv run train.py`
3. Review `program.md` for autonomous agent instructions
4. Launch your AI coding assistant to begin automated research!

---

**Note**: This repo is designed for single-GPU systems. Your laptop is an ideal setup.
