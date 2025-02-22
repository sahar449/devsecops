# Stage 1: Build the application
FROM maven:3.8.4-openjdk-11 AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml and source code to the container
COPY pom.xml .
COPY src ./src

# Build the application and run tests
RUN mvn clean package

# Stage 2: Create a lightweight image with the built JAR
FROM openjdk:11-jre-slim

# Ensure that the package list is up-to-date and install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    zlib1g=1:1.2.11.dfsg-2+deb11u2 \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory for the final image
WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/hello-world.jar ./hello-world.jar

# Specify the command to run the application
CMD ["java", "-jar", "hello-world.jar"]
