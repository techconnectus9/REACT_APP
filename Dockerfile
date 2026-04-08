FROM node:18

WORKDIR /app

COPY . .

RUN npm init -y

EXPOSE 3000

USER 1001

CMD ["node", "src/index.js"]
