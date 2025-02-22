# Stage 1: Build the application
FROM maven:3.8.4-openjdk-11 AS build

# Set the working directory
WORKDIR /app

# Install necessary packages and download Snyk CLI
RUN apt-get update && \
    apt-get install -y curl && \
    curl -L -o snyk-linux https://downloads.snyk.io/cli/stable/snyk-linux?_gl=1*qke36d*_gcl_au*MzY4Mzc2MjU2LjE3Mzk4OTE3Mzk.*_ga*MTY1OTM3OTc1NC4xNzM5ODkxNzM5*_ga_X9SH3KP7B4*MTc0MDIzMzExNy41LjEuMTc0MDIzNTc2NS42MC4wLjA. && \
    chmod +x snyk-linux && \
    mv snyk-linux /usr/local/bin/snyk

# Copy the pom.xml and source code to the container
COPY pom.xml .
COPY src ./src

# Inject the Snyk token as an environment variable
ARG SNYK_TOKEN
ENV SNYK_TOKEN=${SNYK_TOKEN}

# Authenticate with Snyk and build the application
RUN snyk auth ${SNYK_TOKEN} && mvn clean package

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
