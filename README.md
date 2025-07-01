This Nextflow workflow runs ichorCNA on all the samples listed in the input sample sheet located under the data/ folder.

Each row in the sample sheet should correspond to a unique sample, with the following fields specified:
- Path to the input tumor BAM file.
- A unique SAMPLEID for each sample.

Configuration
Please update the following parameters in your nextflow.config file:

Output Directory
Set the outdir parameter to define where output files will be saved.
A new subfolder per sample will be created within this directory.

Reference Genome Parameters
Adjust based on the reference genome you're using:

**chrs**
**genomeStyle**
**genomeBuild**
Defaults are set for GIAB hg38.

WIG and Centromere Files
Update the paths to the following:

**gcWig**
**mapWig**
**repTimeWig** (optional)
**centromere**
Defaults are also based on GIAB hg38.

Outputs
The pipeline produces the following:
All copy number output files from the optimal solution.
A combined figure: **genomeWide_all_solutions.pdf** showing results across all solutions.
Subdirectories for each solution (normal, ploidy combinations) under the sample output folder.


To Run:
bash run_pipeline.sh