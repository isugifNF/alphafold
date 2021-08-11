# alphafold

Fast draft, run a quick test

```
module load nextflow
module load alphafold

nextflow run isugifNF/alphafold  -r main \
  --fasta "protein.faa" \
  -profile slurm -resume
```

## Background

* GitHub with instructions: https://github.com/deepmind/alphafold


> Jumper, J., Evans, R., Pritzel, A., Green, T., Figurnov, M., Ronneberger, O., Tunyasuvunakool, K., Bates, R., Žídek, A., Potapenko, A. and Bridgland, A., 2021. Highly accurate protein structure prediction with AlphaFold. Nature, pp.1-11.



