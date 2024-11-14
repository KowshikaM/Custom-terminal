# Use the Ubuntu base image
FROM ubuntu:latest

# Install Node.js and npm
RUN apt update && apt install -y \
    curl \
    && curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
    && apt install -y nodejs

# Install glibc to run the C binary
RUN apt install -y libc6

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install Node.js dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Copy your C program binary and inputs
COPY fuzz_target /usr/src/app/fuzz_target
COPY public/inputs /usr/src/app/inputs

# Expose the port for the Node.js application
EXPOSE 3000

# Run the C program and the Node.js application when the container starts
CMD ["sh", "-c", "./fuzz_target /usr/src/app/inputs/sam.bmp && node server.js"]
