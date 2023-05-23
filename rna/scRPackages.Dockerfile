FROM --platform=linux/x86_64 ghcr.io/wanglab-computationalbiology/scrbasic:main

LABEL maintainer="Andre Fonseca" \
    description="scRPackages - Container with single-cell R dependencies, including cell annotation and batch effect"

# Install ps, for Nextflow. https://www.nextflow.io/docs/latest/tracing.html
RUN apt-get update && \
    apt-get install -y jags

# Install required R packages
ARG R_DEPS="c(\
    'harmony', \
    'scater' \
    )"

ARG R_BIOC_DEPS="c(\
    'DropletUtils', \ 
    'MAST', \
    'DESeq2', \
    'batchelor' \
    )"

ARG DEV_DEPS="c(\
    'PaulingLiu/ROGUE', \
    'immunogenomics/lisi', \
    'theislab/kBET', \
    'miccec/yaGST', \
    'AntonioDeFalco/SCEVAN', \
    'broadinstitute/infercnv', \
    'navinlabcode/copykat', \
    'cole-trapnell-lab/monocle3' \
    )"

# Caching R-lib on the building process
RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "install.packages(${R_DEPS}, Ncpus = 8, clean = TRUE)"
RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "BiocManager::install(${R_BIOC_DEPS})"
RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "devtools::install_github(${DEV_DEPS})"

CMD ["R"]