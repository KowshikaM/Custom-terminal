#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>


void LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    // Intentional buffer overflow
    uint8_t *buffer = (uint8_t *)malloc(size);
    if (buffer) {
        // Writing outside the allocated memory
        buffer[size] = 0;  // This will trigger heap-buffer-overflow
        free(buffer);
    }
}

int main(int argc, char **argv) {
    // Fuzzing entry point for testing
    FILE *file = fopen(argv[1], "rb");
    if (file) {
        fseek(file, 0, SEEK_END);
        long file_size = ftell(file);
        fseek(file, 0, SEEK_SET);

        uint8_t *buffer = (uint8_t *)malloc(file_size);
        if (buffer) {
            fread(buffer, 1, file_size, file);
            fclose(file);

            LLVMFuzzerTestOneInput(buffer, file_size);
            free(buffer);
        }
    }
    return 0;
}