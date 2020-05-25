FROM debian:stretch

# Install packages
RUN apt-get update && apt install -y postgresql postgresql-client dos2unix curl openssh-server vim netcat sudo

# If someone edits on windows let's fix the files and make them executable
COPY docker-entrypoint.sh /var/lib/postgresql/docker-entrypoint.sh

COPY config/signalfx-ingest-url.txt /var/lib/postgresql/
COPY config/signalfx-api-url.txt /var/lib/postgresql/
COPY config/signalfx-access-token.txt /var/lib/postgresql/

COPY setup.sql /var/lib/postgresql/setup.sql
COPY tcp-port-wait.sh /var/lib/postgresql/tcp-port-wait.sh
COPY agent.yml /var/lib/postgresql/agent.yml

RUN curl -L https://github.com/signalfx/signalfx-agent/releases/download/v5.2.1/signalfx-agent-5.2.1.tar.gz --output /var/lib/postgresql/signalfx-agent-5.2.1.tar.gz
RUN cd /var/lib/postgresql && tar -xzvf /var/lib/postgresql/signalfx-agent-5.2.1.tar.gz

# Prep the docker entrypoint, if on windows fix up the file
RUN ["chmod", "+x", "/var/lib/postgresql/docker-entrypoint.sh"]
RUN ["dos2unix", "/var/lib/postgresql/docker-entrypoint.sh"]

RUN ["chmod", "+x", "/var/lib/postgresql/tcp-port-wait.sh"]
RUN ["dos2unix", "/var/lib/postgresql/tcp-port-wait.sh"]

RUN echo "postgres ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/postgres
RUN usermod -a -G sudo postgres

# Expose postgres 
EXPOSE  5432

USER postgres
RUN cd ~

# Args & environment
ARG signalfx_realm
ENV SIGNALFX_REALM=${signalfx_realm}

ARG signalfx_access_token
ENV SIGNALFX_ACCESS_TOKEN=${signalfx_access_token}

ENTRYPOINT ["/var/lib/postgresql/docker-entrypoint.sh"]