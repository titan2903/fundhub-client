# Use the official Node.js 16 Alpine image as the base image
FROM node:16-alpine AS build

WORKDIR /app

COPY . .

RUN npm install && \
    npm cache clean --force && \
    npm run build && \
    npm run generate

FROM node:16-alpine

WORKDIR /app

COPY --from=build /app .

ENV HOST 0.0.0.0
EXPOSE 3010

CMD [ "npm", "start" ]