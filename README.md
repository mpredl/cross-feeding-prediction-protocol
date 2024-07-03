# Cross-feeding Prediction Protocol #
This protocol describes the prediction of cross-feeding interactions in small microbial communities using metabolic modelling. Starting from genome sequence, gapseq and PyCoMo are used to infer potential cross-fed metabolites.

## About this Protocol ##

### Who is this protocol for? ###

### Expected Outcome ###

### Runtime ###

### Limitations ###

# Protocol #
In case of problems, take a look at the troubleshooting section below.

## 0. Installation ##
This protocol uses gapseq and PyCoMo for the analysis, as such, both should be installed. 
You can find an example script for installing both in a conda environment on a linux machine: `cf_prediction_conda_install.sh`

Both R and Python are installed in this conda environment, with specific versions. 
The installation and protocol are expected to work with newer versions as well, but have not been tested.
In case of other operating systems or should issues come up during installation, 
please check the respective installation instructions of the two tools:

Gapseq: https://github.com/jotech/gapseq/blob/master/docs/install.md

PyCoMo: https://github.com/univieCUBE/PyCoMo?tab=readme-ov-file#installation

## 1. Input Data ##

## 2. Generation of Member Metabolic Models (gapseq) ##

## 3. Gap-filling with Medium ##

## 4. Generation of Community Metabolic Model (PyCoMo) ##

## 5. Prediction of Cross-feeding Interactions ##

## Output Data ##

## Further Steps ##

### Visualisation with ScyNet ###

### Validation of Predicted Interactions ###

### Curation of the Metabolic Models ###

### Further Reading ###

## Troubleshooting ##
### My Community Metabolic Model does not grow / the model is infeasible. ###




