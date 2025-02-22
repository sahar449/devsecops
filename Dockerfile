# Stage 1: Build the application
FROM maven:3.8.4-openjdk-11 AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml and source code to the container
COPY pom.xml .
COPY src ./src

# Build the application
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

# Copy the entire application from the build stage to the final image
COPY --from=build /app ./

# Specify the command to run the application and sleep for 3600 seconds
CMD ["sh", "-c", "java -jar hello-world-1.0-SNAPSHOT.jar & sleep 3600"]
