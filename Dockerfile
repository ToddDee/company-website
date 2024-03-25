# syntax=docker/dockerfile:1

FROM node:18-alpine
WORKDIR /app
COPY . .
RUN npm install --global gulp-cli
RUN npm install
CMD npm run dev
EXPOSE 3001