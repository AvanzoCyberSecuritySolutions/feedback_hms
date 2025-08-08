# -----------------------------
# Stage 1: Build the Flutter Web App
# -----------------------------
FROM debian:latest AS build-env

# Install required packages and dependencies
RUN apt-get update && \
    apt-get install -y curl git wget unzip libgconf-2-4 gdb libglu1-mesa fonts-droid-fallback python3 && \
    apt-get clean

# Clone Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Add Flutter and Dart to PATH
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Set backend URL from build arguments
ARG BACKEND_BASE_URL

# Run Flutter setup commands
RUN flutter doctor -v
RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

# Create and move into app directory
RUN mkdir /app/
COPY . /app/
WORKDIR /app/

# Build the Flutter web app with backend URL defined
RUN flutter build web --dart-define=BASE_URL=$BACKEND_BASE_URL

# -----------------------------
# Stage 2: Serve the App using Nginx
# -----------------------------
FROM nginx:1.21.1-alpine

# Copy built web assets from the build stage
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Optional: Custom Nginx config (uncomment if needed)
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port (optional if you run inside container orchestration like k8s)
EXPOSE 80
