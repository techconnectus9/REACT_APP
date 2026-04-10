# Build stage
FROM node:18 AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine

# Copy React build
COPY --from=build /app/build /usr/share/nginx/html

# FIX PERMISSIONS FOR OPENSHIFT
RUN mkdir -p /var/cache/nginx \
    && mkdir -p /var/run \
    && chmod -R 777 /var/cache/nginx \
    && chmod -R 777 /var/run \
    && chmod -R 777 /usr/share/nginx/html

# Remove default nginx config (optional safer)
RUN rm /etc/nginx/conf.d/default.conf

# Create custom config
RUN echo 'server { \
    listen 8080; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html; \
        try_files $uri /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 8080

USER 1001

CMD ["nginx", "-g", "daemon off;"]
