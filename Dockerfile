# Stage 1
FROM debian:latest AS build-env

RUN apt-get update && apt-get install -y \
    curl git wget unzip gdb libglu1-mesa fonts-droid-fallback python3 \
    && apt-get clean

RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Keep build arg so your BASE_URL continues to work
ARG BACKEND_BASE_URL=""

RUN flutter doctor -v

RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

RUN mkdir /app/
COPY . /app/
WORKDIR /app/
RUN flutter build web --dart-define=BASE_URL=${BACKEND_BASE_URL}

# Stage 2
FROM nginx:1.21.1-alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html
