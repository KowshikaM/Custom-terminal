# Use a stable Ubuntu base image
FROM ubuntu:22.04

# Install dependencies
RUN apt update && apt install -y \
    gcc \
    libc6-dev \
    curl \
    wget \
    nodejs \
    npm \
    libstdc++6 \
    git \
    build-essential

# Download and prepare glibc-runner
RUN curl -Lo /glibc-runner https://github.com/jumanjiman/glibc-runner/releases/download/v2.34-1/glibc-runner \
    && chmod +x /glibc-runner

# Set the working directory
WORKDIR /usr/src/app

# Copy application files
COPY package*.json ./

# Install Node.js dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Compile the C program
RUN gcc -o fuzz_target fuzz_target.c

# Expose the application port
EXPOSE 3000

# Use glibc-runner to patch glibc dynamically
CMD ["/glibc-runner", "sh", "-c", "./fuzz_target /usr/src/app/public/inputs/sam.bmp && node server.js"]
