ARG IMAGE
FROM ${IMAGE}

ARG RD_URL

USER root

RUN apt update
RUN apt install -y iputils-ping curl jq python3 python3-pip python3-dev libkrb5-dev
RUN python3 -m pip install wheel pywinrm pywinrm[credssp] pywinrm[kerberos] requests requests-kerberos pexpect

COPY runner-check.sh /home/runner/runner-check.sh

RUN chmod +x /home/runner/runner-check.sh
RUN sed -i "s/RD_URL/$(echo ${RD_URL} | sed 's/\//\\\//g')/g" /home/runner/runner-check.sh

USER runner
CMD ["/bin/bash", "-c", "/home/runner/runner-check.sh"]