
# FROM tomcat:9.0.100

# COPY target/maven-web-application.war /usr/local/tomcat/webapps/maven-web-application.war

# RUN echo "hello kk funda"



# -------------------------
# Stage 1: Build WAR
# -------------------------
FROM maven:3.9.6-eclipse-temurin-11 AS builder

WORKDIR /app

# Copy pom.xml and download dependencies (cache layer)
COPY pom.xml .

RUN mvn dependency:go-offline -B

# Copy source code and build WAR
COPY src .

RUN mvn clean package -DskipTests 

# -------------------------
# Stage 2: Tomcat Runtime
# -------------------------
FROM tomcat:9.0.100

# Remove default applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR from build stage
COPY --from=builder /app/target/maven-web-application.war \
     /usr/local/tomcat/webapps/maven-web-application.war

# Optional build info
RUN echo "hello kk funda"

EXPOSE 8080



