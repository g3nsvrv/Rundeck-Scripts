ARG IMAGE
FROM ${IMAGE}

ARG RD_PORT

COPY --chown=rundeck:root remco /etc/remco

RUN sed -i "s/SERVER_PORT/${RD_PORT}/g" /etc/remco/templates/rundeck-config-extras.properties

USER root

RUN printf 'Acquire::Retries "5";\nAcquire::http::Pipeline-Depth "0";\nAcquire::http::No-Cache "true";\n' > /etc/apt/apt.conf.d/99fix-hash-mismatch
RUN apt clean && apt update && apt install -y iputils-ping curl jq
RUN apt clean && apt update && apt install -y python3 python3-pip python3-dev libkrb5-dev
RUN python3 -m pip install --no-cache-dir wheel pywinrm pywinrm[credssp] pywinrm[kerberos] requests requests-kerberos pexpect

USER rundeck