// read_counter.nf
// 06/16/2025
// Pooja Chandra
// Ha Lab
nextflow.enable.dsl=2

process READ_COUNTER {

    tag { sampleMeta.sampleName }

    input:
    tuple val(sampleMeta), path(bam), path(bai)

    output:
    tuple val(sampleMeta), path("${sampleMeta.sampleName}.wig")

    /*
     * Runs readCounter on tumor BAM using parameters from sampleMeta and params
     */

    script:
    def chrs = sampleMeta.RDchrs.join(',')
    def binSize = params.binSizeNumeric
    def qual = params.qual
    def wig = "${sampleMeta.sampleName}.wig"

    """
    echo "Processing sample: ${sampleMeta.sampleName}"
    echo "Using BAM: ${bam}"
    echo "Using BAI: ${bai}"

    readCounter ${bam} \\
        -c ${chrs} \\
        -w ${binSize} \\
        -q ${qual} \\
        > ${wig}
    """
}
