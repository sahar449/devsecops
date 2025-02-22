FROM openjdk:11-jdk-slim
WORKDIR /app
COPY target/hello-world-1.0-SNAPSHOT.jar app.jar
CMD ["java", "-jar", "app.jar"]