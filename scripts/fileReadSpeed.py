import numpy as np
import os
import time
import random
import sys

def file_read_speed(filename, read_share, chunk_size):
    # Check if the file exists
    if not os.path.isfile(filename):
        raise FileNotFoundError('File not found')

    # Get file size in bytes
    fileSizeBytes = os.path.getsize(filename)
    # Assuming the file contains single precision floats (4 bytes each)
    fileSize = fileSizeBytes // 4  
    if fileSizeBytes % 4 != 0:
        print("Warning: File size is not a multiple of 4 bytes. Truncating to nearest float32 boundary.")
    size_to_read = int(fileSize * read_share)
    print(f"Processing {read_share*100}% of {fileSizeBytes/(1024*1024*1024):.2f} GB file")

    # Initialize variables
    totalBytesRead = 0
    n_chunks = int(size_to_read / chunk_size) + 1

    # Create a memory map to the file, ensuring it fits the data size
    file = np.memmap(filename, dtype='float32', mode='r', shape=(fileSize,))

    pos = [int(random.random() * (fileSize - 2 * chunk_size)) for _ in range(n_chunks)]
    pos = sorted(pos)
    if max(pos) + chunk_size > fileSize:
        raise ValueError('Requested position is outside of the file ranges')

    # Start the timer
    start_time = time.time()

    # Read the file in blocks
    for i, p in enumerate(pos):
        data = file[p:p+chunk_size]
        totalBytesRead += data.size * data.itemsize
        if (i + 1) % 100 == 0:
            print(f'step {i + 1}#{n_chunks}')

    # Stop the timer
    elapsedTime = time.time() - start_time

    # Calculate reading speed
    read_speed = totalBytesRead / elapsedTime  # bytes per second

    # Convert to human-readable format (MB/s)
    read_speed_MBps = read_speed / (1024 * 1024)

    # Display the result
    print(f'Read {totalBytesRead/(1024*1024):.2f} MB in {elapsedTime:.2f} seconds: {read_speed_MBps:.2f} MB/s')

    return read_speed, elapsedTime

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 fileReadSpeed.py <filename>")
        sys.exit(1)

    filename = sys.argv[1]  # Get the filename from the command line arguments
    read_share = 0.002  # Example: Read 10% of the file
    chunk_size = 10240  # Example: Read in chunks of 1024 floats
    file_read_speed(filename, read_share, chunk_size)
