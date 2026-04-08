# Build stage
FROM node:18 AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Production stage (Nginx)
FROM nginx:alpine

COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

USER 1001

CMD ["nginx", "-g", "daemon off;"]
