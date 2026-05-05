ARG IMAGE
FROM ${IMAGE}

COPY --chown=rundeck:root remco /etc/remco

USER root
RUN apt -y update
RUN apt -y install iputils-ping

USER rundeck