# soft link - TaRGET server: /var/www/html/processed/fromHTCF -> /lts/twlab/targetdcc03/data-processed/fromHTCF/
WWW_DIR="/var/www/html/files"
# Step 1: HTCF - inside folder where data processing has just finished - 
# say, /scratch/twlab/targetdcc/batch-run3

# declare variables carefully
ASSAY="RNA-seq" # or RNA-seq
READ_EXT=".PE.R1"   # .SE for single
LIST_FILE="pelst"
SUBMISSION_ID="7f61c50e-b651-4f76-9e46-d10e769e39b0"

TARGET_COPY_DESTINATION_ROOT="/lts/twlab/targetdcc03/data-processed/fromHTCF"
BIGWIG_PREFIX="step3.2_Normalized_per_10M_"
BAM_PREFIX="step2.2_Trimed_rm_mapq0_chrm_"
JSON_PREFIX="" 
RESULTS_DIR="data_collection_" # only for RNA-seq, this can be a subfolder, say "data_collection_5b20195e3dd9a073e3b67209.SE"
FASTQ_PREFIX=""

# copy this file to target server and run it to create folders to copy processed files to
cat $LIST_FILE | awk '{ print $1}' | sed 's/'$READ_EXT'.fastq.gz//g' \
| awk '{ print "sudo rm -rf '$TARGET_COPY_DESTINATION_ROOT'/'$SUBMISSION_ID'/"$1"\n \
sudo mkdir -p '$TARGET_COPY_DESTINATION_ROOT'/'$SUBMISSION_ID'/"$1"\n \
sudo chown 1115:5114 -R '$TARGET_COPY_DESTINATION_ROOT'/'$SUBMISSION_ID'/"$1"\n \
sudo chmod -R g+rwx '$TARGET_COPY_DESTINATION_ROOT'/'$SUBMISSION_ID'/"$1"\n" }' \
> ~/$SUBMISSION_ID.target.mkdir.sh


# on HTCF
cat pelst | awk '{ print $1}' | sed 's/'$READ_EXT'.fastq.gz//g' \
| awk '{ print "rsync -r Processed_"$1"'$READ_EXT' '$TARGET_COPY_DESTINATION_ROOT'/'$SUBMISSION_ID'/"$1""}' \
> ~/$SUBMISSION_ID.rsync.cmd.sh

#==============================SOFT LINKS==============================================#

# copy this file to target server and run it to create folders to copy processed files to

case "$ASSAY" in
    ATAC-seq)
    cat pelst | awk '{ print $1}' | sed 's/'$READ_EXT'.fastq.gz//g' \
    | awk '{ \
            print "mkdir -p '$WWW_DIR'/"$1"\n \
            ln -s '$TARGET_COPY_DESTINATION_ROOT'/'$SUBMISSION_ID'/"$1"/Processed_"$1"'$READ_EXT'/'$JSON_PREFIX"$1"$READ_EXT'.json '$WWW_DIR'/"$1"/"$1".json \n \
            ln -s '$TARGET_COPY_DESTINATION_ROOT'/'$SUBMISSION_ID'/"$1"/Processed_"$1"'$READ_EXT'/'$BIGWIG_PREFIX'"$1"'$READ_EXT'.bigWig '$WWW_DIR'/"$1"/"$1".bigWig \n \
            ln -s '$TARGET_COPY_DESTINATION_ROOT'/'$SUBMISSION_ID'/"$1"/Processed_"$1"'$READ_EXT'/'$FASTQ_PREFIX'"$1"'$READ_EXT'.fastq.gz '$WWW_DIR'/"$1"/"$1".PE.R1.fastq.gz \n \
            ln -s '$TARGET_COPY_DESTINATION_ROOT'/'$SUBMISSION_ID'/"$1"/Processed_"$1"'$READ_EXT'/'$FASTQ_PREFIX'"$1"'$READ_EXT'.fastq.gz '$WWW_DIR'/"$1"/"$1".PE.R2.fastq.gz \n \
            ln -s '$TARGET_COPY_DESTINATION_ROOT'/'$SUBMISSION_ID'/"$1"/Processed_"$1"'$READ_EXT'/'$BAM_PREFIX'"$1"'$READ_EXT'.bam '$WWW_DIR'/"$1"/"$1".bam \n \
            echo '$TARGET_COPY_DESTINATION_ROOT'/'$SUBMISSION_ID'/"$1" > '$WWW_DIR'/"$1"/processed_results_path.txt \n" \
            }' \
    > ~/$SUBMISSION_ID.softlink_files.sh
    ;;
    RNA-seq)
    cat pelst | awk '{ print $1}' | sed 's/'$READ_EXT'.fastq.gz//g' \
    | awk '{ \
            print "mkdir -p '$WWW_DIR'/"$1"\n \
            ln -s '$TARGET_COPY_DESTINATION_ROOT'/'$SUBMISSION_ID'/"$1"/Processed_"$1"'$READ_EXT'/'$RESULTS_DIR'"$1"'$READ_EXT'/'$JSON_PREFIX'"$1"'$READ_EXT'.json '$WWW_DIR'/"$1"/"$1".json \n \
            ln -s '$TARGET_COPY_DESTINATION_ROOT'/'$SUBMISSION_ID'/"$1"/Processed_"$1"'$READ_EXT'/'$BIGWIG_PREFIX'"$1"'$READ_EXT'.bigWig '$WWW_DIR'/"$1"/"$1".bigWig \n \
            ln -s '$TARGET_COPY_DESTINATION_ROOT'/'$SUBMISSION_ID'/"$1"/Processed_"$1"'$READ_EXT'/'$FASTQ_PREFIX'"$1"'$READ_EXT'.fastq.gz '$WWW_DIR'/"$1"/"$1".PE.R1.fastq.gz \n \
            ln -s '$TARGET_COPY_DESTINATION_ROOT'/'$SUBMISSION_ID'/"$1"/Processed_"$1"'$READ_EXT'/'$FASTQ_PREFIX'"$1"'$READ_EXT'.fastq.gz '$WWW_DIR'/"$1"/"$1".PE.R2.fastq.gz \n \
            ln -s '$TARGET_COPY_DESTINATION_ROOT'/'$SUBMISSION_ID'/"$1"/Processed_"$1"'$READ_EXT'/'$BAM_PREFIX'"$1"'$READ_EXT'.bam '$WWW_DIR'/"$1"/"$1".bam \n \
            ln -s '$TARGET_COPY_DESTINATION_ROOT'/'$SUBMISSION_ID'/"$1"/Processed_"$1"'$READ_EXT'/multiqc_data '$WWW_DIR'/"$1"/multiqc_data \n \
            ln -s '$TARGET_COPY_DESTINATION_ROOT'/'$SUBMISSION_ID'/"$1"/Processed_"$1"'$READ_EXT'/multiqc_report.html '$WWW_DIR'/"$1"/multiqc_report.html \n \
            echo '$TARGET_COPY_DESTINATION_ROOT'/'$SUBMISSION_ID'/"$1" > '$WWW_DIR'/"$1"/processed_results_path.txt \n" \
            }' \
    > ~/$SUBMISSION_ID.softlink_files.sh
    ;;
    *) echo "Please enter ASSAY"
    ;;
esac