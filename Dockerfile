# =========================
# Stage 1: Build (with Maven)
# =========================
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy pom.xml and download dependencies first (better caching)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy project sources
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# =========================
# Stage 2: Runtime (with JDK)
# =========================
FROM openjdk:17-jdk-slim

WORKDIR /app

# Copy only the jar from builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose Eureka port
EXPOSE 8761

# Environment variables
ENV SPRING_PROFILES_ACTIVE=docker
ENV SERVICE_PORT=8761
ENV SERVICE_NAME=eureka-server

# Healthcheck (optional, requires curl)
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=5 \
  CMD curl -f http://localhost:${PORT}/actuator/health || exit 1

# Run Spring Boot app
ENTRYPOINT ["java", "-jar", "app.jar"]
