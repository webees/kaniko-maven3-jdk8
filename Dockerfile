# use musl busybox since it's staticly compiled on all platforms
FROM busybox:musl AS busybox

FROM alpine AS jdk8_maven3

WORKDIR /tmp
RUN wget -q -O jdk8.tar.gz https://builds.openlogic.com/downloadJDK/openlogic-openjdk/8u382-b05/openlogic-openjdk-8u382-b05-linux-x64.tar.gz
RUN mkdir jdk8
RUN tar -xzvf jdk8.tar.gz -C jdk8 --strip-components=1

RUN wget -q -O maven3.tar.gz https://dlcdn.apache.org/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.tar.gz
RUN mkdir maven3
RUN tar -xzvf maven3.tar.gz -C maven3 --strip-components=1

FROM gcr.io/kaniko-project/executor:debug

RUN --mount=from=busybox,dst=/usr/ ["busybox", "sh", "-c", "mkdir -p /jdk8 && chmod 777 /jdk8"]
RUN --mount=from=busybox,dst=/usr/ ["busybox", "sh", "-c", "mkdir -p /maven3 && chmod 777 /maven3"]

COPY --from=jdk8_maven3 /tmp/jdk8 /jdk8
COPY --from=jdk8_maven3 /tmp/maven3 /maven3

ENV PATH $PATH:/jdk8/bin:/maven3/bin

RUN java -version
RUN mvn -version
