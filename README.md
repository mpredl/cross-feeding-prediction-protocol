# Cross-feeding Prediction Protocol #
This protocol describes the prediction of cross-feeding interactions in small microbial communities 
using metabolic modelling. 
Starting from genome sequence, gapseq and PyCoMo are used to infer potential cross-fed metabolites.

## About this Protocol ##
### Who is this Protocol for? ###
This protocol is intended for any researcher or biotechnologist interested in predicting cross-feeding interactions 
in a particular community of prokaryotic organisms. 

While no particular experience in programming or metabolic modelling is required,
some time should be dedicated to familiarize oneself with the concepts of metabolic modelling,
to better understand and estimate the reasoning and limitations behind the generated results.

The scripts provided in this protocol are also to be seen as a foundation, 
with many options for shaping it to ones experiments and computational environment.

### Aim and Procedure ###
The aim of this protocol is the prediction of potential cross-feeding interactions in microbial communities.
The basis of this analysis are the genomes of the community members. 
The prediction itself is done with metabolic modelling.
It includes the reconstruction of metabolic models for each community member, a gap-filling step to ensure 
biomass production in each model on a known medium, the creation of a community metabolic model, and lastly
the prediction of all potential cross-feeding interactions. 
The predicted interactions are intended as candidates for validation experiments.

### Expected Outcome ###
The results of this protocol are:
- Genome-scale metabolic reconstructions for all community members
- Pathway predictions for all community members
- A genome-scale, compartmentalized community metabolic model
- All potential cross-feeding interactions feasible within the model 
(including interaction partners, metabolites and maximum flux)

### Runtime ###
The total runtime for this protocol largely depends on the number of species in the community of interest, and the 
amount of manual curation for models and media. For more details on expected time requirements:

1. Installation: <1h
2. Input data: Depends on the availability of genomes and information on media constituents (several minutes to days)
3. Reconstruction of metabolic models: 4 - 10h per community member
4. Gap-filling: 0.5 - 2h per model
5. Construction of community metabolic model: <1h
6. Prediction of cross-feeding interactions: Depends on the size and complexity of the community metabolic model, 
as well as the capacity for parallel computing (several minutes to multiple hours)

### Limitations ###
- This protocol only allows for the reconstruction of metabolic models from prokaryotic genomes. 
The community metabolic modelling steps (step 4+) should work also for models of unicellular eukaryotes - 
some adaptation will likely be needed for multicellular organisms.
- Since the metabolic models are automatically reconstructed and only curated by automated gap-filling, 
the models will contain errors (missing / wrongly included reactions, inaccurate biomass reaction, etc.).
The validation and curation of the models is not covered by this protocol, 
but some directions can be found in the further reading section.
- Accurate growth-rate predictions cannot be expected from the models generated by this protocol (see above).
For this, curation and experimental data are required to refine the metabolic network and constrain the model.
- Predicted cross-feeding interactions are also affected by errors in the model. 
However, the reasoning of this procedure is, that the genome-based reconstructed metabolic network, 
together with gap-filling on a known growth medium, provides enough evidence for reasonably robust
qualitative predictions of cross-fed metabolites.
- All predicted cross-feeding interactions should be treated as candidates for further validation experiments.

# Protocol #
This section describes all steps of the cross-feeding prediction protocol.

A test case is included in this protocol: The prediction of cross-feeding interactions in a co-culture of 
the archaeon _Methanobrevibacter smithii_ and the bacterium _Bacteroides thetaiotamicron_.
More information on this co-culture can be found here:
- Catlett et al. (2022): https://doi.org/10.1128%2Fspectrum.01067-22
- Duller et al. (2024): https://doi.org/10.1101/2024.04.10.588852 

In case of problems, take a look at the troubleshooting section below.

## 1. Installation ##
This protocol uses gapseq and PyCoMo for the analysis, as such, both should be installed. 
You can find an example script for installing both in a conda environment on a linux machine: 
`cf_prediction_conda_install.sh`

Both R and Python are installed in this conda environment, with specific versions. 
The installation and protocol are expected to work with newer versions as well, but have not been tested.
In case of other operating systems or should issues come up during installation, 
please check the respective installation instructions of the two tools:

Gapseq: https://github.com/jotech/gapseq/blob/master/docs/install.md

PyCoMo: https://github.com/univieCUBE/PyCoMo?tab=readme-ov-file#installation

## 2. Input Data ##
The only required input data is the genomes of the community members, as fasta files. 
They should be placed in a folder containing ONLY the input fasta files.

Note that this protocol only works with prokaryotes, 
as only they are supported by the metabolic model reconstruction method gapseq.
The community metabolic modelling steps (step 4+) should work also for models of unicellular eukaryotes - 
some adaptation will likely be needed for multicellular organisms.

Optional, but highly recommended, input data is a growth medium, where the organisms are known to be able to grow.
This growth medium is supplied as a csv file, containing three columns:

1. column called `compounds`: the (ModelSEED/gapseq) identifier of the metabolite
2. column called `name`: the name of the metabolite
3. column called `maxFlux`: the maximum uptake rate for the metabolite in `mmol/gDW/hr`

More detailed information on the structure of the medium file can be found in the gapseq tutorial: 
https://gapseq.readthedocs.io/en/latest/usage/medium.html

Further instructions for the translation of media recipes into a format suitable for metabolic modelling, 
have a look at the further reading section.

The input data for the test case can be found in the `data` directory.
The genomes are retrieved from NCBI genbank and the MpT1 media have been reconstructed in Duller et al. (2024) 
(https://doi.org/10.1101/2024.04.10.588852 )

## 3. Generation of Member Metabolic Models (gapseq) ##
With the input data ready, it is time to reconstruct the metabolic networks for all community members. 
This is done by using `gapseq doall`.
It searches for chemical reactions and transporters encoded in the genome and reconstructs a draft metabolic model 
from them. 
Then, gapseq predicts a likely growth medium for the organism and fills gaps until growth is possible.

An example script calling `gapseq doall` for all fasta files in a specified directory is included in this repository: 
`scripts/gapseq_reconstruct.sh`

For further explanation on methods, output data, or customization options, have a look at the gapseq documentation: 
https://gapseq.readthedocs.io/en/latest/usage/basics.html

## 4. Gap-filling with Medium ##
The next step is gap-filling. 
Automatically reconstructed metabolic models are likely to contain gaps due to missing 
genes, or missing/wrong functional annotations.
This can be tackled with a variety of model curation techniques, one of which is gap-filling.
Here, a known growth medium for the organism of interest is used to check whether the model is capable 
of producing biomass.
If not, reactions are added to the model, filling the gaps in the metabolic network, until biomass production 
is achieved.

In this protocol, gapseq is used for gap-filling. It uses the genome information from the model reconstruction step, 
to assess which reactions are more likely to be correct for filling gaps.

An example script is included in this repository: `scripts/gapseq_gapfill.sh`

The script requires the reconstructed metabolic models from the previous step, the growth media for the organisms 
(see step 1: Input Data), as well as a csv file stating which model should be filled based on which medium. 
The format of this file is `MODELFILE,MEDIUMFILE`, an example can be seen in `data/media/model_media_pairings.csv`

In the test case of the archaea-bacteria co-culture, the growth media for both organisms is MpT1.
However, _B. thetaiotamicron_ has additives in its medium, 
resulting in two different media being used in the gap-filling step.

## 5. Generation of Community Metabolic Model (PyCoMo) ##

## 6. Prediction of Cross-feeding Interactions ##

## Output Data ##
The results of this protocol are:
- Genome-scale metabolic reconstructions for all community members
- Pathway predictions for all community members
- A genome-scale, compartmentalized community metabolic model
- All potential cross-feeding interactions feasible within the model 
(including interaction partners, metabolites and maximum flux)

## Further Steps ##

### Visualisation with ScyNet ###
The cross-feeding interactions predicted in this protocol are present in tabular format. 
ScyNet can be used to visualize the community metabolic model and its cross-feeding results.

You can find more information on ScyNet at: tutorial on GitHub, or the Cytoscape App Store page:
- Github (code & tutorial): [github.com/univieCUBE/ScyNet/wiki](https://github.com/univieCUBE/ScyNet/wiki)
- Cytoscape App Store: [apps.cytoscape.org/apps/scynet](https://apps.cytoscape.org/apps/scynet)

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

### Reconstruction of Genome-Scale Metabolic Models ###


## Troubleshooting ##
### My Community Metabolic Model does not grow / the Model is infeasible. ###




