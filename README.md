# Uncertainty quantification for outcome modelling in radiation oncology: an illustrative example

## Introduction
Outcome modelling is an important tool in radiation oncology to guide treatment decisions. 
Applying these models into clinical practice requires reliable model outputs. 
In this context, uncertainty quantification can be used to assess reliability, interpretability and explainability for various modelling strategies. 
However, the quantification of uncertainties of outcome models in radiation oncology is still rarely done.

Aiming to inspire researchers to build upon current knowledge about uncertainty quantification, we summarised basic concepts in a topical review:  ```We will provide further information soon.```

In this notebook, we provide an example for the application of the presented methods for uncertainty quantification. 

## Aim
This notebook aims to demonstrate basic concepts of how different methods for uncertainty quantification can be used for or integrated in outcome modelling in radiation oncology.
It uses an artificial example of predicting radiation induced pneumonitis after irradiation.
We hope this notebook will help researchers in the radiation oncology community to use uncertainty quantification techniques in their outcome modelling.

## Outline
The notebook is structured as follows:
<ol>
    <li>Data preparation</li>
    <li>Model development</li> 
    <li>Methods for uncertainty quantification</li> 
        <ol>
            <li>Ensemble methods</li>
            <li>Bayesian methods</li>
            <li>Test-time augmentation (TTA) methods</li>
        </ol>
    <li>Application of uncertainty quantification</li>
        <ol>
            <li>In-distribution dataset</li>
            <li>Shifted dataset</li>
            <li>Out-of-distribution dataset</li>
        </ol>
    <li>Evaluation of uncertainty quantification</li>
    <ol>
        <li>Sparsification plots</li>
        <li>Conformal prediction</li>
    </ol>
    <li>Summary</li>
</ol>

## Dataset
For our demonstration example, we used an R-script to artificially create a dataset based on the cohort used by ```Yakar M et al. 2021;20. doi:10.1177/15330338211016373```.

Our dataset consists of 200 patients and comprises three features:
- Dose in Gy that is applied to 5% of the lunge volume ($D5\%$): dose_to_5_percent_of_lung_volume
- Gross tumour volume (GTV) in $cm^3$: gross_tumour_volume
- Number of cycles of chemotherapy as integer: n_chemotherapy_cycles

The studied outcome variable is the presence of a radiation induced pneumonitis:
- outcome $= {0, 1}$: 0 - no radiopneumonitis; 1 - radiopneumonitis

In general, the following correlations apply:
- The risk of radiopneumonitis increases with the dose to 5% of the lung volume.
- The risk of radiopneumonitis increases with the gross tumour volume.
- The risk of radiopneumonitis increases with the number of applied chemotherapy cycles. 

A more detailed description can be found in the R-file used for creation.

## Dependencies
The demonstration example was developed using Python (Version 3.11.6) and requires working versions of NumPy, SciPy, pandas, matplotlib, seaborn, scikit-learn, statsmodels, PyMC and ArviZ.

## Citation info
If you use this repository, please cite the following paper:

```We will provide further information soon.```

