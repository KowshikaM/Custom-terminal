# Use a stable Ubuntu base image
FROM ubuntu:20.04

# Use an alternate mirror to prevent APT-related issues
RUN sed -i 's|http://archive.ubuntu.com/ubuntu|http://mirrors.edge.kernel.org/ubuntu|g' /etc/apt/sources.list

# Install required packages and clean up APT cache
RUN apt update && apt install -y \
    gcc \
    libc6-dev \
    curl \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt install -y nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install Node.js dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Compile the C program
RUN gcc -o fuzz_target fuzz_target.c

# Expose the application port
EXPOSE 3000

# Define the container's startup command
CMD ["sh", "-c", "./fuzz_target /usr/src/app/public/inputs/sam.bmp && node server.js"]
