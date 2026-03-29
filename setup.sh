#!/bin/bash
# Setup script for autoresearch on Linux with NVIDIA GPU

set -e

echo "=== Autoresearch Setup Script ==="
echo ""

# Check for NVIDIA GPU
if command -v nvidia-smi &> /dev/null; then
    echo "✓ NVIDIA GPU detected"
    nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv
    USE_CUDA=true
else
    echo "✗ No NVIDIA GPU detected (or nvidia-smi not found)"
    echo "  Will install CPU-only PyTorch"
    USE_CUDA=false
fi

echo ""

# Install uv if not present
if ! command -v uv &> /dev/null; then
    echo "Installing uv package manager..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source $HOME/.local/bin/env || true
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "✓ uv already installed"
fi

echo ""

# Modify pyproject.toml based on GPU availability
if [ "$USE_CUDA" = true ]; then
    echo "Configuring for CUDA (GPU)..."
    # Keep the default CUDA configuration
else
    echo "Configuring for CPU-only..."
    # Create a CPU-only version of pyproject.toml
    cat > pyproject.toml << 'PYPROJECT'
[project]
name = "autoresearch"
version = "0.1.0"
description = "Autonomous pretraining research swarm"
readme = "README.md"
requires-python = ">=3.10"
dependencies = [
    "kernels>=0.11.7",
    "matplotlib>=3.10.8",
    "numpy>=2.2.6",
    "pandas>=2.3.3",
    "pyarrow>=21.0.0",
    "requests>=2.32.0",
    "rustbpe>=0.1.0",
    "tiktoken>=0.11.0",
    "torch==2.9.1",
]

[tool.uv.sources]
torch = [
    { index = "pytorch-cpu" },
]

[[tool.uv.index]]
name = "pytorch-cpu"
url = "https://download.pytorch.org/whl/cpu"
explicit = true
PYPROJECT
fi

echo ""
echo "Installing dependencies (this may take a while)..."
source $HOME/.local/bin/env || true
export PATH="$HOME/.local/bin:$PATH"
uv sync

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "1. Download data and train tokenizer: uv run prepare.py"
echo "2. Run a training experiment: uv run train.py"
echo ""
echo "To start the autonomous agent, open program.md and follow instructions."
