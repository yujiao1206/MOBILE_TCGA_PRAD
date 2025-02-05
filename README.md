[![DOI](https://zenodo.org/badge/512962806.svg)](https://zenodo.org/badge/latestdoi/512962806)

# MOBILE
Multi-Omics Binary Integration via Lasso Ensembles (MOBILE)

The MOBILE pipeline produces ligand-specific association networks. It integrates multi-omics datasets in a data-driven, biologically-structured manner. The gene-level association networks are used to nominate differentially enriched pathways. This pipeline is also broadly applicable to find condition specific networks using multi-omics datasets. More info can be found [here](https://www.nature.com/articles/s41467-023-39729-2).

## Dependencies

- MATLAB
- [glmnet package](https://hastie.su.domains/glmnet_matlab/download.html)
- RStudio and R (for image quantification)

## Instructions

1. Clone this repository from the command-line using 

    `git clone --recursive https://github.com/cerdem12/MOBILE.git`

2. Make sure all the folders are added to the MATLAB path.

3. Run the scripts in order: 
    
    `MOBILE_runATACseqRNAseq.m + MOBILE_runRNAseqRPPA.m => MOBILE_summarize.m => MOBILE_select.m`

## Model testing and performance

The MOBILE simulation of RPPA-RNAseq inference takes around 2-3 second per run (10000 instances are run in total: ~8 hours) including the save function in a normal desktop/laptop. 

The RNAseq-ATACseq inference simulations were run on Clemson University [Palmetto HPC](https://docs.rcd.clemson.edu/) and took around 8 hours per 1000 iteration of the 10000 instances (sources used per batch job: number of nodes=1, number of CPUs=40, memory=360gb). Ten batch jobs were run in parallel and the results were concatanated offline afterwards. 

Tested environments include: 

- Ubuntu 18.04, Intel Core i7 3930 CPU @ 3.20 GHz, 32 GB DDR3, Nvidia GTX 690 GPU
- Windows 10 Education, Intel Core i5-3470 CPU @ 3.20 GHz, 8.00 GB RAM, Nvidia GTX 650 GPU, 64-bit operating system
- Windows 10 Pro, Intel Core i7-8550U CPU @ 2.00 GHz, 16.00 GB RAM, Intel UHD 620 GPU, 64-bit operating system

