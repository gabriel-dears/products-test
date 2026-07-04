# Build stage
FROM gradle:9.5.1-jdk AS builder

WORKDIR /app

# Copy gradle files first for better layer caching
COPY build.gradle settings.gradle ./
COPY gradle/wrapper/gradle-wrapper.properties ./gradle/wrapper/
COPY gradle/wrapper/gradle-wrapper.jar ./gradle/wrapper/

# Download dependencies
RUN gradle dependencies --no-daemon

# Copy source code
COPY src ./src

# Build the application
RUN gradle bootJar --no-daemon

# Runtime stage - using eclipse-temurin for security and stability
FROM eclipse-temurin:25-jre-alpine

# Install curl for health check
RUN apk add --no-cache curl

# Create non-root user for security
RUN addgroup -S -g 1001 appgroup && \
    adduser -S -u 1001 -G appgroup appuser

WORKDIR /app

# Copy the jar from builder stage with proper ownership
COPY --from=builder --chown=appuser:appgroup /app/build/libs/*.jar app.jar

# Expose port
EXPOSE 8080

# Add security labels
LABEL org.opencontainers.image.authors="products-api"
LABEL org.opencontainers.image.description="Products API application"

# Health check - using the products endpoint
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/api/products || exit 1

# Switch to non-root user
USER appuser

# Run the application with security options
ENTRYPOINT ["java", "-XX:+UseContainerSupport", "-XX:MaxRAMPercentage=75.0", "-jar", "app.jar"]