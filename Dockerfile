# Stage 1: Build the application
FROM maven:3.8.4-openjdk-11 AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml and source code to the container
COPY pom.xml .
COPY src ./src

# Install Snyk CLI
RUN curl -sSL https://static.snyk.io/cli/latest/snyk-linux -o /usr/local/bin/snyk && \
    chmod +x /usr/local/bin/snyk

# Authenticate with Snyk and build the application
RUN snyk auth ${SNYK_TOKEN} && mvn clean package

# Stage 2: Create a lightweight image with the built JAR
FROM openjdk:11-jre-slim

# Set the working directory for the final image
WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/hello-world.jar ./hello-world.jar

# Specify the command to run the application
CMD ["java", "-jar", "hello-world.jar"]
