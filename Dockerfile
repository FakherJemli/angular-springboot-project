# Generated Dockerfile — Spring Boot (Gradle / Java 11)
FROM gradle:jdk11-alpine AS build
WORKDIR /workspace
COPY build.gradle* settings.gradle* gradlew ./
COPY gradle ./gradle
COPY src ./src
RUN ./gradlew bootJar -x test
RUN test -n "$(ls /workspace/build/libs/*.jar 2>/dev/null)" || (echo "ERROR: no JAR found at /workspace/build/libs/*.jar" && exit 1)

FROM eclipse-temurin:11-jre-alpine
WORKDIR /app
COPY --from=build /workspace/build/libs/*.jar /app/app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
