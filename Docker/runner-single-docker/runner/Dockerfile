ARG IMAGE
FROM ${IMAGE}

ARG RD_URL
ARG RUNNER_ID
ARG RUNNER_TOKEN

USER root

RUN apt update
RUN apt install -y iputils-ping curl jq python3 python3-pip python3-dev libkrb5-dev
RUN python3 -m pip install wheel pywinrm pywinrm[credssp] pywinrm[kerberos] requests requests-kerberos pexpect

USER runner
CMD ["/usr/bin/env","bash","-c","java -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=$(hostname) -jar /app/pd-runner.jar"]