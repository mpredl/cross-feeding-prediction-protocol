#!/usr/bin/env bash

# Installation script for the cross-feeding-prediction protocol. More information here:
# https://github.com/mpredl/cross-feeding-prediction-protocol
# Creates a conda environment at specified position and installs R, Python, as well as gapseq and PyCoMo with their
# respective dependencies.
# This installation script is only intended for Linux! Adaptations will be required for other OS.

# VARIABLES
MODULENAME="cf_prediction"  # Choose a name for the conda environment
VERSION="1.1"  # Version of the protocol
PYCOMOVERSION="0.2.7"  # Version of PyCoMo
GAPSEQVERSION="1.4"  # Version of Gapseq. Note that the version is not used in the installation script, as always the
# current version is cloned from GitHub.
MODULEDIR="/path/to/conda_envs/${MODULENAME}"  # Any place where you want to save your environment
TARGETDIR="${MODULEDIR}/${VERSION}"
ENVDIR=${TARGETDIR}
PYTHONVERSION="3.12"  # Later versions are expected to work, but only 3.9 has been tested
RVERSION="4.3.1"  # Later versions are expected to work, but only 4.1 has been tested
GAPSEQURL="https://github.com/jotech/gapseq"

# if directory already exists abort installation
if [ -d $TARGETDIR ]; then
	echo "$TARGETDIR already exists. Aborting installation."
	exit
fi

# Create the parent directory for the conda environment
if [ ! -d $MODULEDIR ]; then
	echo "Creating directory $MODULEDIR"
	mkdir $MODULEDIR
fi

cd $MODULEDIR

set -e

# Create the environment with designated python and R version
conda create -y -p $ENVDIR python=$PYTHONVERSION r=$RVERSION

# Activate the environment
conda activate $ENVDIR

# Print the environments name to console to check for correct activation
echo loaded environment $ENVNAME

# Install the dependencies via conda where possible
conda config --add channels defaults && conda config --add channels bioconda && conda config --add channels conda-forge

conda install -y -p $ENVDIR barrnap bedtools exonerate glpk hmmer blast bash perl parallel gawk sed grep bc git coreutils wget
conda install -y -p $ENVDIR r-data.table r-stringr r-stringi r-getopt r-doParallel r-foreach r-r.utils r-sybil r-biocmanager bioconductor-biostrings r-jsonlite r-cobrar
conda install -y -p $ENVDIR cobra biopython numpy scipy pandas matplotlib seaborn jupyter pycomo=0.2.6
# Update PyCoMo via pip until it is available on bioconda
python -m pip install --upgrade pycomo==$PYCOMOVERSION

# Install additional R packages
mkdir -p  ${TARGETDIR}/lib/R
R -e 'install.packages(c("glpkAPI", "CHNOSZ"), repos="http://cran.us.r-project.org")'
R -e 'install.packages(c("httr"), repos="http://cran.us.r-project.org")'


# Install libSBML
conda install -y -p $ENVDIR -c bioconda libsbml

cd $WDIR

pushd ${TARGETDIR}
  # Install gapseq
	git clone $GAPSEQURL
	pushd gapseq
	# Update sequence database
	./src/update_sequences.sh

	# Test if installation was successful
	./gapseq test
popd

conda deactivate


