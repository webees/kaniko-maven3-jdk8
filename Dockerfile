# use musl busybox since it's staticly compiled on all platforms
FROM busybox:musl AS busybox

FROM gcr.io/kaniko-project/executor:debug

WORKDIR /tmp
RUN --mount=from=busybox,dst=/usr/
RUN busybox sh -c "wget -q -O jdk8.tar.gz https://builds.openlogic.com/downloadJDK/openlogic-openjdk/8u382-b05/openlogic-openjdk-8u382-b05-linux-x64.tar.gz"
RUN busybox sh -c "mkdir -p jdk8 && tar -xzvf jdk8.tar.gz -C jdk8 --strip-components=1"

RUN busybox sh -c "wget -q -O maven3.tar.gz https://dlcdn.apache.org/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.tar.gz"
RUN busybox sh -c "mkdir -p maven3 && tar -xzvf maven3.tar.gz -C maven3 --strip-components=1"



WORKDIR /
RUN busybox sh -c "mkdir -p /jdk8 && chmod 777 /jdk8"
RUN busybox sh -c "mkdir -p /maven3 && chmod 777 /maven3"

RUN ls /tmp
RUN ls

COPY /tmp/jdk8 /jdk8
COPY /tmp/maven3 /maven3

ENV PATH $PATH:/jdk8/bin:/maven3/bin

RUN /jdk8/bin/java -version
RUN /maven3/bin/mvn -version
