# Use a stable Ubuntu base image
FROM ubuntu:22.04

# Install dependencies
RUN apt update && apt install -y \
    gcc \
    libc6-dev \
    curl \
    wget \
    software-properties-common \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt install -y nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade glibc to 2.34
RUN wget http://ftp.gnu.org/gnu/libc/glibc-2.34.tar.gz && \
    tar -xvf glibc-2.34.tar.gz && \
    cd glibc-2.34 && \
    mkdir build && cd build && \
    ../configure --prefix=/opt/glibc-2.34 && \
    make -j$(nproc) && make install && \
    rm -rf /glibc-2.34*

# Update the dynamic linker to use the new glibc
ENV LD_LIBRARY_PATH=/opt/glibc-2.34/lib:$LD_LIBRARY_PATH

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
