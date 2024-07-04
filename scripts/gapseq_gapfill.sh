#!/bin/bash

# Metabolic model gap-filling script for the cross-feeding-prediction protocol. More information here:
# https://github.com/mpredl/cross-feeding-prediction-protocol
# Fills gaps in the input metabolic models to allow growth on the specified media.
# Gap-filling is performed using gapseq.

# Variables
TARGETDIR="path/to/output_dir"  # Where to place the output files
ENVDIR="/path/to/conda_env"  # The path to the conda environment
MODELDIR="/path/to/input_model_dir"  # Path to the draft models (created in the previous step)
MEDIADIR="/path/to/input_media_dir"  # Path to the media csv files
MODELMEDIACSV="/path/to/model_media_pairings_file"  # Path to the csv file specifying model - media pairings in csv format: MODELFILE,MEDIAFILE

if [ ! -d $TARGETDIR ]; then
        echo "Creating directory $TARGETDIR"
        mkdir $TARGETDIR
fi

conda activate $ENVDIR

cd $TARGETDIR

while IFS="," read -r SAMPLENAME MEDIANAME
do
  # Set the media and sample abbreviations
  MEDIA=$MEDIADIR/$MEDIANAME
  MEDIAABBREV=$(basename ${MEDIANAME})
  SAMPLEABBREV=$(basename ${SAMPLENAME})

  # Gapfilling procedure
  # In case gapseq is not in your PATH, either call it with full path, or add gapseq to PATH beforehand
  $GAPSEQDIR/gapseq fill -m $MODELDIR/${SAMPLEABBREV}.RDS -c $MODELDIR/${SAMPLEABBREV}-rxnWeights.RDS -g $MODELDIR/${SAMPLEABBREV}-rxnXgenes.RDS -n $MEDIA

  # Rename the output files according to the medium
  mv $TARGETDIR/${SAMPLEABBREV}.RDS $TARGETDIR/${SAMPLEABBREV}_${MEDIAABBREV}.RDS
  mv $TARGETDIR/${SAMPLEABBREV}.xml $TARGETDIR/${SAMPLEABBREV}_${MEDIAABBREV}.xml

done < $MODELMEDIACSV  # Model - media pairings file for input control

