#! /usr/bin/env nextflow

nextflow.enable.dsl=2

process jackhammer_uniref {

  input: tuple path(uniprot_ref), path(protein_faa)
  output:
  script:
  """
  #! /usr/bin/env bash
  PROC=\$((`nproc`))
  ${jackhammer_app} \
    -o /dev/null \
    -A /tmp/tmp70tks774/output.sto \
    --noali \
    --F1 0.0005 \
    --F2 5e-05 \
    --F3 5e-07 \
    --incE 0.0001 \
    -E 0.0001 \
    --cpu \$PROC \
    -N 1 \
    ${protein_faa} \
    ${uniprot_ref}
    # Check if uniprot_ref also needs adjacent index files, will need to pass in the whole folder as a path
    # Should be able to auto specify tmp directory?
  """
}

process jackhammer_mgnify {

  input: tuple path(myg_cluster_faa), path(protein_faa)
  output:
  script:
  """
  #! /usr/bin/env bash
  PROC=\$((`nproc`))
  ${jackhammer_app} \
    -o /dev/null \
    -A /tmp/tmp1yy85jw5/output.sto \
    --noali \
    --F1 0.0005 \
    --F2 5e-05 \
    --F3 5e-07 \
    --incE 0.0001 \
    -E 0.0001 \
    --cpu \$PROC \
    -N 1 \
    ${protein_faa} \
    ${myg_cluster_faa}
  """
}

process hhsearch {

  input: tuple path(pdb), path(query_a3m)
  output:
  script:
  """
  #! /usr/bin/env bash
  ${hhsearch_app} \
    -i ${query_a3m} \
    -o /tmp/tmpp35dgcm5/output.hhr \
    -maxseq 1000000 \
    -d ${pdb}
  """

}

process hhblist {
  label "bigmem"

  input: tuple path(ref_files), path(protein_faa)
  output:
  script:
  """
  #! /usr/bin/env bash
  ${hhblits_app} \
    -i ${protein_faa} \
    -cpu 4 \
    -oa3m /tmp/tmpfdm201oq/output.a3m \
    -o /dev/null \
    -n 3 \
    -e 0.001 \
    -maxseq 1000000 \
    -realign_max 100000 \
    -maxfilt 100000 \
    -min_prefilter_hits 1000 \
    -d /reference/data/alphafold/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt \
    -d /reference/data/alphafold/uniclust30_2018_08/uniclust30_2018_08
  """
}

process alphafold {
  label "gpu"

  input:
  output:
  script:
  """
  #! /usr/bin/env bash
  """
}

workflow {

  /* Step 1: split protein files into one each */
  protein_ch = channel.fromPath(params.fasta, checkIfExists:true) | splitFasta(by:1)

  /* Link reference files here? */
  uniprot_ch = channel.fromPath(params.uniprot, checkIfExists:true)
  myg_cluster_ch = channel.fromPath(params.mgy_cluster, checkIfExists:true)
  pdb_ch = channel.fromPath(params.pdb, checkIfExists:true)

  /* vague outline of pipeline */
  /* protein_ch | jackhammer_uniref | jackhammer_mgnify | hhsearch | hhblist | alphafold */

  /* maybe closer to... */
  uniprot_ch | combine(protein_ch) | jackhammer_uniref 
  myg_cluster_ch | combine(protein_ch) | jackhammer_mgnify
  pdb_ch | combine(/*something?*/) | hhblist

  | jackhammer_mgnify | hhsearch | hhblist | alphafold
}

/* Scripts */
/* templates.py, tpu_client.py, xla_bridge ...*/