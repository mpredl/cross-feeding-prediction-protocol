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
You can find an example script for installing both in a conda environment on a linux machine: 
`cf_prediction_conda_install.sh`

Both R and Python are installed in this conda environment, with specific versions. 
The installation and protocol are expected to work with newer versions as well, but have not been tested.
In case of other operating systems or should issues come up during installation, 
please check the respective installation instructions of the two tools:

Gapseq: https://github.com/jotech/gapseq/blob/master/docs/install.md

PyCoMo: https://github.com/univieCUBE/PyCoMo?tab=readme-ov-file#installation

## 1. Input Data ##
The only required input data is the genomes of the community members, as fasta files. 
They should be placed in a folder containing ONLY the input fasta files.

Note that this protocol has so far only been tested with prokaryotes, but should work also for unicellular eukaryotes - 
some adaptation will be needed for multicellular organisms.

Optional, but highly recommended, input data is a growth medium, where the organisms are known to be able to grow.
This growth medium is supplied as a csv file, containing three columns:

1. column called `compounds`: the (ModelSEED/gapseq) identifier of the metabolite
2. column called `name`: the name of the metabolite
3. column called `maxFlux`: the maximum uptake rate for the metabolite in `mmol/gDW/hr`

More detailled information on the structure of the medium file can be found in the gapseq tutorial: 
https://gapseq.readthedocs.io/en/latest/usage/medium.html

Further instructions for the translation of media recipes into a format suitable for metabolic modelling, 
have a look at the further reading section.

## 2. Generation of Member Metabolic Models (gapseq) ##
With the input data ready, it is time to reconstruct the metabolic networks for all community members. 
This is done by using `gapseq doall`.
It searches for chemical reactions and transporters encoded in the genome and reconstructs a draft metabolic model 
from them. 
Then, gapseq predicts a likely growth medium for the organism and fills gaps until growth is possible.

An example script calling `gapseq doall` for all fasta files in a specified directory is included in this repository: 
`scripts/gapseq_reconstruct.sh`

For further explanation on methods, output data, or customization options, have a look at the gapseq documentation: 
https://gapseq.readthedocs.io/en/latest/usage/basics.html

## 3. Gap-filling with Medium ##

## 4. Generation of Community Metabolic Model (PyCoMo) ##

## 5. Prediction of Cross-feeding Interactions ##

## Output Data ##

## Further Steps ##

### Visualisation with ScyNet ###

### Validation of Predicted Interactions ###

### Curation of the Metabolic Models ###

## Further Reading ##
### Creating Media for Metabolic Modelling ###
Media are used in metabolic modelling to define which metabolites can be taken up or be excreted by the model, 
as well as in which quantity. 
This requires exact specification of all metabolites in the medium. 
Such a specification is only possible for defined media.
Complex media, on the other hand, contain ingredients where the constituents are not known, e.g. in yeast extract.
In such cases, or when the media is a natural environment, rather than the result of a recipe, 
the media constituents need to be estimated.

Information on translating media into a format usable for metabolic modelling, 
as well as estimating its constituents can be found in the following (non-exhaustive) list of resources:

- The gapseq documentation: https://gapseq.readthedocs.io/en/latest/usage/medium.html
- A protocol on the creation of genome-scale metabolic models by Thiele & Palsson (2010): 
https://doi.org/10.1038/nprot.2009.203
- A procedure for estimating media constituents for metabolic modelling by Marinos et al. (2020): 
https://doi.org/10.1371/journal.pone.0236890

## Troubleshooting ##
### My Community Metabolic Model does not grow / the Model is infeasible. ###




