nextflow.enable.dsl=2

include { READ_COUNTER } from './modules/read_counter.nf'
include { RUN_ICHORCNA } from './modules/run_ichorCNA.nf'

workflow {

    // Read and parse the samplesheet
    samples_ch = Channel
        .fromPath(params.samplesheet)
        .splitCsv(header: true)
        .map { row ->
            def bamFile = file(row.tumorBam)
            def baiFile = file(row.tumorBai)
            def centromereFile = file(params.centromere)

            // Require global normalPanel from config
            if (!params.normalPanel) {
                error "Missing 'normalPanel' parameter in config or CLI"
            }
            def normalPanelFile = file(params.normalPanel)
            def genomeStyleChrs = (row.genomeStyle == "NCBI") ? params.ncbiChrs : params.ucscChrs
            def meta = [
                sampleName   : row.sampleName,
                sex          : row.sex,
                // genomeStyle  : row.genomeStyle,
                // genomeBuild  : row.genomeBuild,
                RDchrs       : genomeStyleChrs,
                normalPanel  : normalPanelFile,
                centromere   : centromereFile
            ]

            tuple(meta, bamFile, baiFile)
        }

    // Run read counter
    readcount_ch = READ_COUNTER(samples_ch)

    // Optional exons file from params
    def exonsVal = params.exons ? file(params.exons) : null

    // Prepare input for ichorCNA
    run_ichorCNA_input = readcount_ch.map { sampleMeta, tumorWig ->
        tuple(sampleMeta, tumorWig, sampleMeta.normalPanel, sampleMeta.centromere, exonsVal)
    }

    // Run ichorCNA
    RUN_ICHORCNA(run_ichorCNA_input)
}
