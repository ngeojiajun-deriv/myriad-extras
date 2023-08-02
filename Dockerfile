FROM deriv/myriad:stable
COPY ./bin /opt/dir/bin
COPY ./share /opt/dir/share
ENV TOOLCHAIN="docker-standalone"
ENV PATH="${PATH}:/opt/dir/bin"
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt-mark hold usrmerge usr-is-merged && apt upgrade -y && \
     apt install -y build-essential nnn groff less && \
     apt autoremove -y --purge && rm -rf /var/lib/apt/lists/*
#Install this slow building lib
RUN cpanm CryptX Database::Async Database::Async::Engine::PostgreSQL
ENTRYPOINT []
CMD ["bash", "-c", "01_syntax.sh"]