#!/usr/bin/env bash

# Cross-feeding predction script for the cross-feeding-prediction protocol. More information here:
# https://github.com/mpredl/cross-feeding-prediction-protocol
# Uses PyCoMo to calculate the maximum growth-rate of the community, and the composition that can reach it.

# VARIABLES
TARGETDIR="path/to/output_dir"  # Where to place the output files
COMMUNITYNAME="name_of_the_community_model"  # The name used as prefix for the output file(s).
ENVDIR="/path/to/conda_env"  # The path to the conda environment
MODELFILE="/path/to/input_model"  # Path to the community metabolic model file (created in the previous step)
MEDIUM="/path/to/medium_file"  # Path to the medium csv file

if [ ! -d $TARGETDIR ]; then
        echo "Creating directory $TARGETDIR"
        mkdir $TARGETDIR
fi

conda activate $ENVDIR

pycomo -i=$MODELFILE \
  -c \
  -o=$TARGETDIR \
  -n=$COMMUNITYNAME \
  --medium=$MEDIUM \
  --max-growth-rate \
  --num-cores=8
