# Stage 1: Build the application
FROM maven:3.8.4-jdk-11-slim AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml and source code to the container
COPY pom.xml .
COPY src ./src

# Run Maven to build the project and create the JAR file
RUN mvn clean package

# Stage 2: Create the final image
FROM openjdk:11-jre-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=build /app/target/my-java-app-1.0-SNAPSHOT.jar /app/my-java-app.jar

# Expose the port the app will run on
EXPOSE 8080

# Add a sleep command for 3660 seconds (1 hour)
CMD ["sh", "-c", "java -jar my-java-app.jar && sleep 3660"]
