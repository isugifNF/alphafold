#! /usr/bin/env nextflow

nextflow.enable.dsl=2

process jackhammer_uniref {

  input: tuple path(database_ref), path(protein_faa)
  output:
  script:
  template 'jackhammer.sh'
}

process jackhammer_mgnify {

  input: tuple path(database_ref), path(protein_faa)
  output:
  script:
  template 'jackhammer.sh'
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

  /* Reference Genetic Databases: https://github.com/deepmind/alphafold#genetic-databases */
  uniref_ch = channel.fromPath(params.uniref90_db, checkIfExists:true)
  mgnify_ch = channel.fromPath(params.mgnify_db, checkIfExists:true)
//  bfd_db
//  uniclust30_db
  pdb70_ch = channel.fromPath(params.pdb70, checkIfExists:true)
// pdb_ch = channel.fromPath(params.pdb_db, checkIfExists:true)
  /* vague outline of pipeline */
  /* protein_ch | jackhammer_uniref | jackhammer_mgnify | hhsearch | hhblist | alphafold */

  /* maybe closer to... */
  uniref_ch | combine(protein_ch) | jackhammer_uniref 
  mgnify_ch | combine(protein_ch) | jackhammer_mgnify
  pdb70_ch | combine(/*something?*/) | hhblist

  jackhammer_mgnify.out | hhsearch | hhblist | alphafold
}

/* Scripts */
/* templates.py, tpu_client.py, xla_bridge ...*/