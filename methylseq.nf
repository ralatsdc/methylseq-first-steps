process getReferenceFiles {

    publishDir params.reference_files_dir, mode: "move", overwrite: true

    input:
        val reference_name from "Bisulfite_Genome.tar.gz", "hg19_lambda.fa.tar.gz"

    output:
        file "*.tar.gz" optional true into reference_files_ch
        val reference_name into reference_names_ch

    """
    if [ ! -e ${params.reference_files_dir}/${reference_name} ] \
        | [ ${params.force_download} == "true" ]; then
            wget https://zenodo.org/record/4625710/files/${reference_name}
    fi
    """
}

process trimReads {

    echo true

    input:
        val reference_names from reference_names_ch.collect()
        set sample, file(read_file_pair) from \
            Channel.fromFilePairs(params.read_files_dir + "/*.R{1,2}.fastq.gz")

    """
    echo ${sample}
    echo ${read_file_pair[0]}
    echo ${read_file_pair[1]}
    
    # Remove links and copy in reads files
    # rm ${read_file_pair[0]}
    # rm ${read_file_pair[1]}
    # cp ${params.read_files_dir}/${read_file_pair[0]} .
    # cp ${params.read_files_dir}/${read_file_pair[1]} .

    # echo "${sample} ${read_file_pair[0]} ${read_file_pair[1]}"
    # docker run -v \${PWD}:/root --rm \
    #     quay.io/biocontainers/trim-galore:0.6.6--0 trim_galore \
    #         --paired -q 20 --clip_R1 10 --clip_R2 10 \
    #         --three_prime_clip_R1 10 --three_prime_clip_R2 10 \
    #         --retain_unpaired -r1 20 -r2 20 \
    #         ${read_file_pair}
    """
}
