# target_utils

#### Step 1: Declare Variables
- ASSAY="RNA-seq" # or RNA-seq
- READ_EXT=".PE.R1"   # .SE for single
- LIST_FILE="pelst"
- SUBMISSION_ID="7f61c50e-b651-4f76-9e46-d10e769e39b0"

- TARGET_COPY_DESTINATION_ROOT="/lts/twlab/targetdcc03/data-processed/fromHTCF"
- BIGWIG_PREFIX="step3.2_Normalized_per_10M_"
- BAM_PREFIX="step2.2_Trimed_rm_mapq0_chrm_"
- JSON_PREFIX="" 
- RESULTS_DIR="data_collection_" # only for RNA-seq, this can be a subfolder, say "data_collection_5b20195e3dd9a073e3b67209.SE"
- FASTQ_PREFIX=""

### Step 2: HTCF - inside folder where data processing has just finished - 
  - say,   `/scratch/twlab/targetdcc/batch-run3`
  ```
  bash setup.sh
  ```
  This creates 3 files in home folder : 
    - 7f61c50e-b651-4f76-9e46-d10e769e39b0.target.mkdir.sh
    - 7f61c50e-b651-4f76-9e46-d10e769e39b0.rsync.cmd.sh
    - 7f61c50e-b651-4f76-9e46-d10e769e39b0.softlink_files.sh

### Step 3: copy this files to target server and run it to create folders to copy processed files to

1. 7f61c50e-b651-4f76-9e46-d10e769e39b0.target.mkdir.sh (target server)
2. 7f61c50e-b651-4f76-9e46-d10e769e39b0.rsync.cmd.sh (htcf - copies files)
3. 7f61c50e-b651-4f76-9e46-d10e769e39b0.softlink_files.sh (creates softlinks in finalized format)

