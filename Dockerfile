# Use development platform library
FROM ngeojiajun/myriad:dev
COPY ./bin /opt/dir/bin
COPY ./share /opt/dir/share
ENV TOOLCHAIN="docker-standalone"
ENV PATH="${PATH}:/opt/dir/bin"
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
     apt install -y nnn groff less && \
     rm -rf /var/lib/apt/lists/*
ENTRYPOINT []
CMD ["bash", "-c", "01_syntax.sh"]
