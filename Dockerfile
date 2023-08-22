FROM gcr.io/kaniko-project/executor:debug as kaniko

FROM node:12-alpine
USER root
COPY --from=kaniko /kaniko /kaniko
ENV PATH $PATH:/kaniko

ENV SSL_CERT_DIR=/kaniko/ssl/certs
ENV DOCKER_CONFIG=/kaniko/.docker
ENV DOCKER_CREDENTIAL_GCR_CONFIG=/kaniko/.config/gcloud/docker_credential_gcr_config.json

RUN executor version
RUN node -v
RUN npm -v

ENTRYPOINT ["sh", "-c", "while true; do sleep 3600; done"]
