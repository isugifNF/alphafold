# alphafold

Fast draft, run a quick test

```
module load nextflow
module load alphafold

nextflow run isugifNF/alphafold  -r main \
  --fasta "protein.faa" \
  -profile slurm -resume
```




