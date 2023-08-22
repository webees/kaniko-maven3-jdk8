FROM alpine AS jdk8_maven3

WORKDIR /tmp/jdk8
RUN wget -q -O jdk8.tar.gz https://builds.openlogic.com/downloadJDK/openlogic-openjdk/8u382-b05/openlogic-openjdk-8u382-b05-linux-x64.tar.gz && tar -xzvf jdk8.tar.gz
RUN ls

WORKDIR /tmp/maven3
RUN wget -q -O maven3.tar.gz https://dlcdn.apache.org/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.tar.gz && tar -xzvf maven3.tar.gz
RUN ls

FROM gcr.io/kaniko-project/executor:debug

COPY --from=jdk8_maven3 /tmp/jdk8 /jdk8
COPY --from=jdk8_maven3 /tmp/maven3 /maven3

ENV PATH $PATH:/jdk8/bin:/maven3/bin

RUN java -version
RUN mvn -version
