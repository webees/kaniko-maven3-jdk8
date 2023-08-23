FROM gcr.io/kaniko-project/executor:v1.14.0 as kaniko

FROM maven:3-openjdk-8-slim
USER root
COPY --from=kaniko /kaniko /kaniko
ENV PATH $PATH:/kaniko

ENV SSL_CERT_DIR=/kaniko/ssl/certs
ENV DOCKER_CONFIG=/kaniko/.docker
ENV DOCKER_CREDENTIAL_GCR_CONFIG=/kaniko/.config/gcloud/docker_credential_gcr_config.json

RUN executor version
RUN java -version
RUN mvn -version

RUN echo "https://github.com/webees/kaniko-maven3-jdk8" > /webees

ENTRYPOINT ["sh", "-c", "while true; do sleep 3600; done"]
