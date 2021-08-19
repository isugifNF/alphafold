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
  # uniprot_ref ; mgnify
  # Check if uniprot_ref also needs adjacent index files, will need to pass in the whole folder as a path
  # Should be able to auto specify tmp directory?
  # Both jackhammer processes should be moved to template, it's the same command, different database
