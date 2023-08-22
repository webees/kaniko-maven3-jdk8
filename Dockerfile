FROM gcr.io/kaniko-project/executor:debug as kaniko

FROM maven:3-openjdk-8
COPY --from=busybox --chown=0:0 /kaniko /kaniko

ENV PATH $PATH:/kaniko

RUN executor version
RUN java -version
RUN mvn -version

ENTRYPOINT ["sh", "-c", "while true; do sleep 3600; done"]
