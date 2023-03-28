FROM alpine:3.17.2

SHELL ["/bin/sh", "-o", "pipefail", "-c"]

ENV AWS_CLI_VERSION=1.27.86 \
    DEFAULT_TERRAFORM_VERSION=1.4.2 \
    PRECOMMIT_VERSION=3.1.1 \
    CHECKOV_VERSION=2.1.244 \
    SETUP_TOOLS_VERSION=67.6.0 \
    TFLINT_VERSION=v0.45.0 \
    TFDOCS_VERSION=v0.16.0

# bash, curl, git, openssh, pip, awscli
RUN apk -v --no-cache add \
    bash=5.2.15-r0 \
    curl=7.88.1-r1 \
    git=2.38.4-r1 \
    jq=1.6-r2 \
    unzip=6.0-r13 \
    python3=3.10.10-r0 \
    perl=5.36.0-r0 \
    go=1.19.7-r0 \
    gcc=12.2.1_git20220924-r4 \
    py3-pip=22.3.1-r1 && \
    pip3 install --no-cache-dir --upgrade awscli==$AWS_CLI_VERSION && \
    pip3 install --no-cache-dir --upgrade setuptools==$SETUP_TOOLS_VERSION && \
    pip3 install --no-cache-dir --upgrade checkov==$CHECKOV_VERSION  && \
    apk -v --purge del py-pip

# terraform
RUN curl -Lo ~/terraform.zip https://releases.hashicorp.com/terraform/$DEFAULT_TERRAFORM_VERSION/terraform_${DEFAULT_TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip ~/terraform.zip -d ~/ && \
    mv ~/terraform /usr/local/bin/ && rm -r ~/terraform.zip

# pre-commit hooks
RUN pip3 install --no-cache-dir --upgrade pre-commit==$PRECOMMIT_VERSION && \
    # tflint
    curl -Lo ~/tflint.zip https://github.com/terraform-linters/tflint/releases/download/$TFLINT_VERSION/tflint_linux_amd64.zip && \
    unzip ~/tflint.zip -d ~/ && \
    mv ~/tflint /usr/local/bin/ && rm -r ~/tflint.zip && \
    # terraform-docs
    curl -Lo ~/terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/$TFDOCS_VERSION/terraform-docs-$TFDOCS_VERSION-linux-amd64.tar.gz && \
    tar -xzf ~/terraform-docs.tar.gz -C ~/ && \
    mv ~/terraform-docs /usr/local/bin/ && rm -r ~/terraform-docs.tar.gz && \
    chmod -R +x /usr/local/bin

ENTRYPOINT ["/bin/sh"]
