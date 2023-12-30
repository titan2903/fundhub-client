# Use the official Node.js 16 Alpine image as the base image
FROM node:16-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy only the necessary files needed for npm install to leverage Docker layer caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build and generate static files
RUN npm run build && \
    npm run generate

# Use a new base image for the final stage
FROM node:16-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy only the necessary files from the build stage to the final image
COPY --from=build /app ./

# Set environment variable Host
ENV HOST 0.0.0.0

# Expose port 3010 to the outside world
EXPOSE 3010

CMD [ "npm", "start" ]