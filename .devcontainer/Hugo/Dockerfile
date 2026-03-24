FROM debian:13

# Configure bash completion
RUN apt-get update && apt-get install -y \
    bash-completion \
    locales \
    && rm -rf /var/lib/apt/lists/*
RUN sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
RUN echo 'source /etc/bash_completion' >> ~/.bashrc