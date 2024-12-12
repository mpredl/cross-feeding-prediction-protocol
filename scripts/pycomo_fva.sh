#!/usr/bin/env bash

# Cross-feeding predction script for the cross-feeding-prediction protocol. More information here:
# https://github.com/mpredl/cross-feeding-prediction-protocol
# Uses PyCoMo to run FVA and predict cross-feeding interactions for a given abundance

# VARIABLES
TARGETDIR="path/to/output_dir"  # Where to place the output files
COMMUNITYNAME="name_of_the_community_model"  # The name used as prefix for the output file(s).
ENVDIR="/path/to/conda_env"  # The path to the conda environment
MODELFILE="/path/to/input_model"  # Path to the community metabolic model file (created in the previous step)
MEDIUM="/path/to/medium_file"  # Path to the medium csv file
ABUNDANCE="/path/to/abundance_file"  # Path to the abundance csv file

if [ ! -d $TARGETDIR ]; then
        echo "Creating directory $TARGETDIR"
        mkdir $TARGETDIR
fi

conda activate $ENVDIR

# Customization advice
# --fva-interaction calculates the cross-feeding interactions from the FVA results. Omit this flag if not needed
# --fva-flux saves the FVA results to file. Omit this flag if only needing the cross-feeding interactions
# --fraction-of-optimum controls the fraction of the objective (growth-rate) to be reached. 
#     Values between 0. and 1. (0% to 100%) are allowed
# --abd-file Set the model to a fixed abundance profile for FVA.
# --equal-abd (Replace --abd-file) set the model to a fixed abundance profile, where all members have equal abundances
# --growth-rate (Replace --abd-file) set the model to a fixed growth-rate for FVA: e.g. --growth-rate=1

pycomo -i=$MODELFILE \
  -c \
  -o=$TARGETDIR \
  -n=$COMMUNITYNAME \
  --medium=$MEDIUM \
  --abd-file=$ABUNDANCE \
  --fva-interaction \
  --fva-flux \
  --fraction-of-optimum=0.9 \
  --loopless=True \
  --num-cores=8
