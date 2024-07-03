#!/usr/bin/env bash

# Installation script for the cross-feeding-prediction protocol. More information here:
# https://github.com/mpredl/cross-feeding-prediction-protocol
# Creates a conda environment at specified position and installs R, Python, as well as gapseq and PyCoMo with their
# respective dependencies.
# This installation script is only intended for Linux! Adaptations will be required for other OS.

# VARIABLES
MODULENAME="cf_prediction"  # Choose a name for the conda environment
VERSION="1.0"  # Write your version here
MODULEDIR="/path/to/conda_envs/${MODULENAME}"  # Any place where you want to save your environment
TARGETDIR="${MODULEDIR}/${VERSION}"
ENVDIR=${TARGETDIR}
PYTHONVERSION="3.9"  # Later versions are expected to work, but only 3.9 has been tested
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
conda install -y -p $ENVDIR r-data.table r-stringr r-stringi r-getopt r-doParallel r-foreach r-r.utils r-sybil r-biocmanager bioconductor-biostrings r-jsonlite
conda install -y -p $ENVDIR cobra biopython numpy scipy pandas matplotlib seaborn jupyter pycomo

# Install additional R packages
mkdir -p  ${TARGETDIR}/lib/R
R -e 'install.packages(c("glpkAPI", "CHNOSZ"), repos="http://cran.us.r-project.org")'
R -e 'install.packages(c("httr"), repos="http://cran.us.r-project.org")'


# Install libSBML and sybilSBML
conda install -y -p $ENVDIR -c bioconda libsbml
wget https://cran.r-project.org/src/contrib/Archive/sybilSBML/sybilSBML_3.1.2.tar.gz
R CMD INSTALL --configure-args="--with-sbml-include=$CONDA_PREFIX/include --with-sbml-lib=$CONDA_PREFIX/lib" sybilSBML_3.1.2.tar.gz
rm sybilSBML_3.1.2.tar.gz

cd $WDIR

pushd ${TARGETDIR}
  # Install gapseq
	git clone $GAPSEQURL
	pushd gapseq
	# Update sequence database
	./src/update_sequences.sh

	# Test if installation was successful
	./gapseq test
	pycomo -h
popd

conda deactivate


