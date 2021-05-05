
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

    """
    echo ${reference_names}
    """
}
