# The basic environment for LLM Agents
# ----
# build image:
#   podman build --force-rm -t bizobj-container.net/pods/bizobj-pod/llm:latest -t bizobj-container.net/pods/bizobj-pod/llm:20260816 .
# run test by podman:
#   podman run -it --rm bizobj-container.net/pods/bizobj-pod/llm:latest
# run test as Pod:
#   podman play kube ./test/test-pods.yaml ; podman attach devpods-91-test-llm ; podman pod rm -f devpods-91-test

FROM bizobj-container.net/pods/bizobj-pod/java:20260816.java-8-and-24-node-24-go-1.26-python3
LABEL maintainer="https://github.com/platbase"

VOLUME ["/data"]

###############################################################################

# Install base packages for office files、pdf
RUN apt-get update -y && \
    apt-get install -y pandoc libreoffice poppler-utils qpdf ffmpeg        && \
    apt-get clean && rm -rfv /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN apt-get update -y && \
    apt-get install -y python3-defusedxml python3-pypdf python3-reportlab  && \
    apt-get install -y python3-pandas python3-openpyxl python3-tabulate    && \
    apt-get install -y python3-docx python3-odf python3-magic libmagic1t64 && \
    apt-get clean && rm -rfv /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN export PATH="/opt/venv/bin:$PATH" && \
    pip install --no-cache-dir pdfplumber          && \
    pip install --no-cache-dir "markitdown[pptx]"  && \
    pip install --no-cache-dir pdf2image

RUN export PATH="$PATH:/opt/node-v${NODE_VERSION}-linux-x64/bin"  && \
    npm install -g --prefix=/opt/node-v${NODE_VERSION}-linux-x64     \
            docx pptxgenjs playwright react-icons react react-dom sharp

###############################################################################

# Install opencode
RUN export PATH="/opt/bun/bin:$PATH" && \
    BUN_INSTALL_GLOBAL_DIR=/opt/bun/install/global \
    BUN_INSTALL_BIN=/opt/bun/bin \
    bun add -g opencode-ai

###############################################################################

# Hooks
ADD files /

# Init scripts
RUN /container-init/set-PS1 "\\h|LLM"
