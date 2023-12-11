# Use the official Node.js 16 Alpine image as the base image
FROM node:16-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy all files from the build context to the working directory in the container
COPY . .

# Install dependencies, clean the npm cache, build, and generate static files
RUN npm install && \
    npm cache clean --force && \
    npm run build && \
    npm run generate

# Use a new base image for the final stage
FROM node:16-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy all files from the build stage to the working directory in the final image
COPY --from=build /app .

# Set environment variable Host
ENV HOST 0.0.0.0

# Expose port 3010 to the outside world
EXPOSE 3010

CMD [ "npm", "start" ]