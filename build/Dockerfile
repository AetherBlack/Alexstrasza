
FROM ubuntu:21.04

# Non interactive APT
ENV DEBIAN_FRONTEND noninteractive

COPY ./entrypoints.sh /entrypoints.sh

RUN chmod u+x /entrypoints.sh && /entrypoints.sh

ENTRYPOINT ["/bin/zsh"]
