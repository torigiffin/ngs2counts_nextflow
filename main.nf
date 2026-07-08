process RUN_NGS2COUNTS {

    input:
    val input_folder
    val ngs2counts_executable
    val ngs2counts_extra_args

    output:
        path "ngs2counts/counts_*"
        path "ngs2counts/run_metadata.json"
        path "ngs2counts_version.txt"
        path "ngs2counts_log.txt"

    script:
    """
    run_ngs2counts.sh \
        $input_folder \
        $ngs2counts_executable \
        ${ ngs2counts_extra_args ? "\"${ngs2counts_extra_args}\"" : "" }
  
    # Copy outputs into the work directory so Nextflow can collect them
    cp -r ${input_folder}/ngs2counts ./ngs2counts
    cp ${input_folder}/ngs2counts_version.txt .
    cp ${input_folder}/ngs2counts_log.txt .
    """
}

workflow {
    Channel
    .value(params.ngs2counts_extra_args ?: "")
    .set { ch_ngs2counts_extra_args }

    RUN_NGS2COUNTS(
        file(params.input_folder),
        file(params.ngs2counts_executable),
        ch_ngs2counts_extra_args
    )
}
