ARG IMAGE
FROM ${IMAGE}

ARG RD_URL

USER root

RUN printf 'Acquire::Retries "5";\nAcquire::http::Pipeline-Depth "0";\nAcquire::http::No-Cache "true";\n' > /etc/apt/apt.conf.d/99fix-hash-mismatch
RUN apt clean && apt update && apt install -y iputils-ping curl jq
RUN apt clean && apt update && apt install -y python3 python3-pip python3-dev libkrb5-dev
RUN python3 -m pip install --no-cache-dir wheel pywinrm pywinrm[credssp] pywinrm[kerberos] requests requests-kerberos pexpect

COPY runner-check.sh /home/runner/runner-check.sh

RUN chmod +x /home/runner/runner-check.sh
RUN sed -i "s/RD_URL/$(echo ${RD_URL} | sed 's/\//\\\//g')/g" /home/runner/runner-check.sh

USER runner
CMD ["/bin/bash", "-c", "/home/runner/runner-check.sh"]