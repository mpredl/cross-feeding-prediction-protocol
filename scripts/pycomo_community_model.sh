#!/usr/bin/env bash

# Community metabolic model creaction script for the cross-feeding-prediction protocol. More information here:
# https://github.com/mpredl/cross-feeding-prediction-protocol
# Creates a compartmentalized community metabolic model of the metabolic models of all community members, using PyCoMo.

# VARIABLES
TARGETDIR="path/to/output_dir"  # Where to place the output files
COMMUNITYNAME="name_of_the_community_model"  # The name of the community metabolic model.
# Will be used in the filename, as well as the actual model.
ENVDIR="/path/to/conda_env"  # The path to the conda environment
MODELDIR="/path/to/input_model_dir"  # Path to the gap-filled models (created in the previous step)
# The model folder must ONLY contain the models of the members to be used for the community metabolic model
MEDIUM="/path/to/medium_file"  # Path to the medium csv file

if [ ! -d $TARGETDIR ]; then
        echo "Creating directory $TARGETDIR"
        mkdir $TARGETDIR
fi

pycomo doall model_folder=$MODELDIR \
  out_dir=$TARGETDIR \
  community_name=$COMMUNITYNAME \
  medium=$MEDIUM \
  sbml_output_file="${COMMUNITYNAME}.xml"
