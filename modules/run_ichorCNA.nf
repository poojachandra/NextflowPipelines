process RUN_ICHORCNA {

    tag { meta.sampleName }

    input:
    tuple val(meta), 
          path(tumorWig), 
          path(normalPanel), 
          path(centromere), 
          val(exons)

    output:
    tuple val(meta), path("${meta.sampleName}_ichorCNA_results"), emit: ichor_output

    script:
    def exonsArg = exons ? "--exons ${exons}" : ""

    """
    mkdir -p ${meta.sampleName}_ichorCNA_results
    mkdir -p ${params.outDir}/${meta.sampleName}

    Rscript ${params.ichorScript} \\
        --id ${meta.sampleName} \\
        --WIG ${tumorWig} \\
        --gcWig ${params.gcWig} \\
        --mapWig ${params.mapWig} \\
        --repTimeWig ${params.repTimeWig} \\
        --sex ${meta.sex} \\
        --normalPanel ${normalPanel} \\
        --ploidy "${params.ploidy?.join(',') ?: '2'}" \\
        --normal "${params.normal ?: '0.5,0.6,0.7,0.8,0.9,0.95'}" \\
        --maxCN ${params.maxCN ?: 5} \\
        --includeHOMD ${params.includeHOMD ?: true} \\
        --chrs "${params.chrs}" \\
        --chrTrain "${params.chrTrain}" \\
        --genomeStyle ${params.genomeStyle} \\
        --genomeBuild ${params.genomeBuild} \\
        --estimateNormal ${params.estimateNormal ?: true} \\
        --estimatePloidy ${params.estimatePloidy ?: true} \\
        --estimateScPrevalence ${params.estimateClonality ?: true} \\
        --scStates "${params.scStates ?: '1,2,3'}" \\
        --likModel ${params.likModel ?: 'gaussian'} \\
        --centromere ${centromere} \\
        ${exonsArg} \\
        --txnE ${params.txnE ?: 0.9999} \\
        --txnStrength ${params.txnStrength ?: 10000} \\
        --minMapScore ${params.minMapScore ?: 25} \\
        --fracReadsInChrYForMale ${params.fracReadsInChrYForMale ?: 0.002} \\
        --normalizeMaleX ${params.normalizeMaleX} \\
        --maxFracGenomeSubclone ${params.maxFracGenomeSubclone} \\
        --maxFracCNASubclone ${params.maxFracCNASubclone ?: 0.7} \\
        --normal2IgnoreSC ${params.normal2IgnoreSC ?: 'none'} \\
        --scPenalty ${params.scPenalty ?: 1} \\
        --plotFileType ${params.plotFileType ?: 'png'} \\
        --outDir "${params.outDir}/${meta.sampleName}"
    """
}
