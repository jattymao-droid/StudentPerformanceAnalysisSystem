# Multi-stage Dockerfile for RuoYi-GameScreen Backend
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /build

# Copy Maven POMs first for dependency caching
COPY pom.xml .
COPY ruoyi-common/pom.xml ruoyi-common/
COPY ruoyi-system/pom.xml ruoyi-system/
COPY ruoyi-framework/pom.xml ruoyi-framework/
COPY ruoyi-quartz/pom.xml ruoyi-quartz/
COPY ruoyi-generator/pom.xml ruoyi-generator/
COPY ruoyi-gamescreen/pom.xml ruoyi-gamescreen/
COPY ruoyi-admin/pom.xml ruoyi-admin/

# Copy all source code
COPY . .

# Package the application
RUN mvn clean package -pl ruoyi-admin -am -DskipTests

# Runtime stage
FROM eclipse-temurin:17-jre-alpine
WORKDIR /home/ruoyi

ENV TZ=Asia/Shanghai
ENV JAVA_OPTS="-Xms512m -Xmx1024m -XX:+UseG1GC"

RUN apk add --no-cache tzdata \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && mkdir -p /home/ruoyi/uploadPath /home/ruoyi/logs

COPY --from=builder /build/ruoyi-admin/target/ruoyi-admin.jar app.jar

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
