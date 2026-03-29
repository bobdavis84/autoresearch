#!/bin/bash
# Setup script for autoresearch on Lenovo Legion 7 (RTX 2070 Super Max-Q)

set -e

# Always run from the directory where this script lives
cd "$(dirname "$0")"

echo "=== Autoresearch Setup Script ==="
echo ""

# Verify NVIDIA GPU is available (required)
if command -v nvidia-smi &> /dev/null; then
    echo "✓ NVIDIA GPU detected"
    nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv
else
    echo "✗ ERROR: No NVIDIA GPU detected (or nvidia-smi not found)"
    echo ""
    echo "  This repo requires an NVIDIA GPU with CUDA support."
    echo "  Make sure your NVIDIA drivers are installed and loaded:"
    echo "    sudo modprobe nvidia"
    echo "    nvidia-smi"
    exit 1
fi

echo ""

# Install uv if not present
if ! command -v uv &> /dev/null; then
    echo "Installing uv package manager..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "✓ uv already installed"
fi

echo ""
echo "Installing dependencies (this may take a while)..."
uv sync

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "1. Download data and train tokenizer: uv run prepare.py"
echo "2. Run a training experiment: uv run train.py"
echo ""
echo "To start the autonomous agent, open program.md and follow instructions."
