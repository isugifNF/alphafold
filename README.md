# alphafold

Fast draft, run a quick test 

```
module load nextflow
module load alphafold

nextflow run isugifNF/alphafold  -r main \
  --fasta "protein.faa" \
  -profile slurm -resume
```

singularity image built from docker

```

```

## Background

GitHub with instructions: https://github.com/deepmind/alphafold

* Jumper, J., Evans, R., Pritzel, A., Green, T., Figurnov, M., Ronneberger, O., Tunyasuvunakool, K., Bates, R., Žídek, A., Potapenko, A. and Bridgland, A., 2021. Highly accurate protein structure prediction with AlphaFold. Nature, pp.1-11.

Other references for the dependencies

* (HHBlits) Remmert, M., Biegert, A., Hauser, A. and Söding, J., 2012. HHblits: lightning-fast iterative protein sequence searching by HMM-HMM alignment. Nature methods, 9(2), pp.173-175.
* Steinegger, M., Meier, M. and Mirdita, M., Vö hringer, H., Haunsberger, SJ, and Söding, J.(2019). HH-suite3 for fast remote homology detection and deep protein annotation. BMC Bioinformatics, 20, p.473.
* (jackHAMMER) Eddy, S.R., 1998. Profile hidden Markov models. Bioinformatics (Oxford, England), 14(9), pp.755-763.

Todos:

* [ ] automagically link database
* [ ] deconstruct python script
* [ ] separate into cpu and gpu components

