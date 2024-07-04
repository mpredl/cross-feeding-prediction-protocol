#!/usr/bin/env bash

# Cross-feeding predction script for the cross-feeding-prediction protocol. More information here:
# https://github.com/mpredl/cross-feeding-prediction-protocol
# Uses PyCoMo to predict all potential cross-feeding interactions in a given community metabolic model.

# VARIABLES
TARGETDIR="path/to/output_dir"  # Where to place the output files
OUTPUTFILE="name_of_cf_prediction_file"  # File name for the cross-feeding predictions
ENVDIR="/path/to/conda_env"  # The path to the conda environment
MODELFILE="/path/to/input_model"  # Path to the community metabolic model (created in the previous step)
# The model folder must ONLY contain the models of the members to be used for the community metabolic model
MEDIUM="/path/to/medium_file"  # Path to the medium csv file
NUMCORES=1  # The number of cores to use for the calculation of cross-feeding interactions.

if [ ! -d $TARGETDIR ]; then
        echo "Creating directory $TARGETDIR"
        mkdir $TARGETDIR
fi

pycomo doall com_model=$MODELDIR \
  out_dir=$TARGETDIR \
  medium=$MEDIUM \
  fva_interaction_path="${OUTPUTFILE}.csv" \
  num_cores=$NUMCORES
