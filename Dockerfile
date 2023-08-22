# use musl busybox since it's staticly compiled on all platforms
FROM busybox:musl AS busybox
WORKDIR /tmp
RUN wget -q -O jdk8.tar.gz https://builds.openlogic.com/downloadJDK/openlogic-openjdk/8u382-b05/openlogic-openjdk-8u382-b05-linux-x64.tar.gz
RUN mkdir jdk8 && tar -xzvf jdk8.tar.gz -C jdk8 --strip-components=1

RUN wget -q -O maven3.tar.gz https://dlcdn.apache.org/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.tar.gz
RUN mkdir maven3 && tar -xzvf maven3.tar.gz -C maven3 --strip-components=1

FROM gcr.io/kaniko-project/executor:debug
ENV USER root

COPY --from=busybox /tmp/jdk8 /jdk8
COPY --from=busybox /tmp/maven3 /maven3

RUN chmod -R +x /jdk8
RUN chmod -R +x /maven3

ENV PATH $PATH:/jdk8/bin:/maven3/bin

ENTRYPOINT ["sh", "-c", "while true; do sleep 3600; done"]
