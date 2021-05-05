
process getReferenceFiles {

    publishDir params.reference_files_dir, mode: "move", overwrite: true

    input:
        val file_name from "Bisulfite_Genome.tar.gz", "hg19_lambda.fa.tar.gz"

    when:
        ! file(params.reference_files_dir + File.separator + file_name).exists() \
        | params.force_download

    output:
        file "*.tar.gz" into reference_files_ch
        val file_name optional true into reference_names_ch

    """
    wget https://zenodo.org/record/4625710/files/${file_name}
    """
}

process trimReads {

    echo true
    
    input:
        val file_name from reference_names_ch

    """
    echo ${file_name}
    """
}
