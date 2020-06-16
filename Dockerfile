FROM openjdk:8-jdk-alpine

# this isn't going to work if im running this on a container..
# i've got a container, should I build the app on the container?
# OR copy it onto the container somehow?


ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
