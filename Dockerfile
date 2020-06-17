#FROM openjdk:8-jdk-alpine
#RUN pwd && ls /home/
#ARG JAR_FILE=target/*.jar
#COPY ${JAR_FILE} app.jar
#ENTRYPOINT ["java","-jar","/app.jar"]

#docker image with maven..

FROM openjdk:8-jdk-alpine

RUN apk add --no-cache curl tar bash procps

# Downloading and installing Maven
ARG MAVEN_VERSION=3.6.3
ARG USER_HOME_DIR="/root"
ARG SHA=b4880fb7a3d81edd190a029440cdf17f308621af68475a4fe976296e71ff4a4b546dd6d8a58aaafba334d309cc11e638c52808a4b0e818fc0fd544226d952544
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && echo "Downlaoding maven" \
  && echo ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
#  \
#  && echo "Checking download hash" \
#  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  \
  && echo "Unziping maven" \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  \
  && echo "Cleaning and setting links" \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

#ARG JAR_FILE=target/*.jar
#COPY ${JAR_FILE} app.jar

#ARG PROJECT=/home/jenkins/agent/workspace/dummy-service_master
#COPY ${PROJECT} app/

ADD . /app
WORKDIR /app
RUN mvn clean package
RUN ls
RUN cd target/ && java -jar dummy-service-0.0.1-SNAPSHOT.jar

RUN pwd && ls
#ENTRYPOINT ["java","-jar","/app.jar"]
