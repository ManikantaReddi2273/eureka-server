# =========================
# Multi-stage build for Eureka Server
# =========================

FROM openjdk:17-jdk-slim as builder

WORKDIR /app
COPY pom.xml .
COPY src ./src

RUN apt-get update && \
    apt-get install -y maven && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mvn clean package -DskipTests

FROM openjdk:17-jre-slim

WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8761

ENV SPRING_PROFILES_ACTIVE=docker
ENV SERVICE_PORT=8761
ENV SERVICE_NAME=eureka-server

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8761/actuator/health || exit 1

CMD ["java", "-jar", "app.jar"]
