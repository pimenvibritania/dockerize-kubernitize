FROM node:14.20.0-alpine
WORKDIR /app
COPY package.json ./
RUN npm i
COPY app.js /app/
EXPOSE 3000
CMD ["node", "app.js"]