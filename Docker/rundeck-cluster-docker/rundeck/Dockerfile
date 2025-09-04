ARG IMAGE
FROM ${IMAGE}

ARG RD_PORT

COPY --chown=rundeck:root remco /etc/remco

RUN sed -i "s/SERVER_PORT/${RD_PORT}/g" /etc/remco/templates/rundeck-config-extras.properties

USER root

RUN apt update
RUN apt install -y iputils-ping curl jq python3 python3-pip python3-dev libkrb5-dev
RUN python3 -m pip install wheel pywinrm pywinrm[credssp] pywinrm[kerberos] requests requests-kerberos pexpect

USER rundeck