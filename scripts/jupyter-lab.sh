#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export PYTHONPATH=$SCRIPT_DIR/../python
export NOTEBOOK_DIR=$SCRIPT_DIR/../notebooks

jupyter lab --port=8888 --ip=127.0.0.1 --no-browser --notebook-dir=$NOTEBOOK_DIR
