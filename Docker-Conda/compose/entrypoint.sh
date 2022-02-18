#!/bin/bash --login
set -e
conda info --envs
conda activate $ENV_PREFIX
jupyter lab build
exec "$@"
