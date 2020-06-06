ARG NGINX_TAG="1.17.7-alpine"

###########################################################################
# Build Container:
###########################################################################

FROM nginx:${NGINX_TAG} as backend-nginx-build

ARG FRONTEND_NGINX_PORT=80 
ARG BACKEND_NGINX_PORT=8081

ARG DOMAIN=${DOMAIN}
ARG APP_GROUP_NAME="app"
ARG PHP_SOCKET_DIR="/socket"
ARG PHP_SOCKET_FILE="app.sock"
ARG NGINX_CODE_DIR=/var/www/app

WORKDIR /build
# Copy the templates to the /build dir

COPY docker/nginx/ ./

# Get gomplate (https://docs.gomplate.ca/)
COPY --from=hairyhenderson/gomplate:v2.5.0-slim /gomplate /bin/gomplate

RUN /bin/gomplate --input-dir=./ --output-dir=/etc/nginx/

###########################################################################
# Base Image:s
###########################################################################

FROM nginx:${NGINX_TAG} as backend-nginx

ARG APP_GROUP_ID=2001
ARG APP_GROUP_NAME="app"

WORKDIR /etc/nginx

COPY --from=backend-nginx-build /etc/nginx/ .

RUN addgroup --system --gid ${APP_GROUP_ID} "${APP_GROUP_NAME}"
RUN addgroup nginx ${APP_GROUP_NAME}


###########################################################################
# INSTALL APPLICATIONS
###########################################################################

RUN apk update && apk upgrade \
    && apk add logrotate \
    && apk add openssl \
    && apk add bash \
    && apk add nano \
	&& apk add curl

###########################################################################
# Configuration
###########################################################################

# Logrotate settings
RUN touch /var/log/messages
COPY docker/nginx/logrotate/nginx /etc/logrotate.d/

# Ssl 
#RUN openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=Batunet, Inc./CN=TR" -addext "subjectAltName=DNS:${DOMAIN}" -newkey rsa:4096 -keyout /etc/nginx/ssl/${DOMAIN}.key -out /etc/nginx/ssl/${DOMAIN}.crt;


# EXPOSE 80 81 443