Description of Project:

1. Overview
This folder contains the source code and datasets used in SMFCCFX project (SMFFX: A Signal Processing-Inspired Feature Extraction Framework for Viral Genomic Sequences Classification).
The files include data files, main scripts, and supporting functions required to perform the computations and generate the results.

2. Software and Version
The codes were developed using MATLAB R2018. 

3. File Descriptions

3.1 Dataset Files
No datasets were generated and the datasets were obtained from the NCBI repository virus section (https://www.ncbi.nlm.nih.gov/labs/virus). The accession number of samples can be download from: https://github.com/aminkhodaei/DNA_sequence_database/Data_Viruses.
Due to the large size of the dataset, the complete data accession numbers are provided in an Excel file. In addition, 3 text files (.fasta) are included to provide representative examples of the data. These text files contain selected samples from 3 classes and are intended to illustrate the data structure and format. They are provided for reference and demonstration purposes and do not represent the complete dataset.

    Flu.fasta: Contains representative samples from the Influenza classes. 
    Corona.fasta: Contains representative samples from the Coronavirus classes. 
    Rhino.fasta: Contains representative samples from the Rhino-virus classes. 

3.2 Main Script Files

    Phase_PreProcess.m: The script responsible for loads the datasets, preprocess steps, and signal mapping.
    Phase_FeatureExtr.m: The main script responsible for executing the MFCC analysis, and statistical feature extraction.
    Phase_Classification.m: The main script responsible for executing the classification by decision tree algorithm and related analysis. 
    
3.3 Supporting Function Files

    compute_macro_f1.m: A supporting function for classifiers to calculate F1-score.
    compute_macro_f1_per_class.m: A supporting function for classifiers to calculate F1-score of each class.

4. Notes
    Download or clone this repository.
    Open MATLAB and set the project folder as the current working directory.
    Ensure that the datasets and all required function files are accessible from the MATLAB path.
    Run the main script to execute the analysis.

   
