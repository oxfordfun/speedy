# Example of usage
# ===  without multiprocessing
# python3 readFile.py /path/to/file 10 
# === with multiprocessing
# python3 readFile.py /path/to/file 10 --parallel

import os
import time
import argparse
from multiprocessing import Pool

def read_chunk(args):
    """Function to read a chunk of the file."""
    filename, start, size = args
    with open(filename, 'rb') as f:
        f.seek(start)
        f.read(size)

def file_read_speed(filename, block_size_MB, use_parallel):
    """Function to measure file read speed."""
    file_size = os.path.getsize(filename)
    print(f"File size: {file_size / (1024 * 1024):.2f} MB")

    block_size = block_size_MB * 1024 * 1024
    num_blocks = -(-file_size // block_size)  # Ceiling division
    chunks = [(filename, i * block_size, min(block_size, file_size - i * block_size))
              for i in range(num_blocks)]

    start_time = time.time()

    if use_parallel:
        with Pool() as pool:
            print(f"Using a pool of {pool._processes} workers for parallel processing.")
            pool.map(read_chunk, chunks)
    else:
        for chunk in chunks:
            read_chunk(chunk)

    elapsed_time = time.time() - start_time
    print(f"Total time spent: {elapsed_time:.2f} seconds.")

    speed_MBps = (file_size / (1024 * 1024)) / elapsed_time
    return speed_MBps

def main():
    parser = argparse.ArgumentParser(description='Measure file read speed.')
    parser.add_argument('filename', type=str, help='Path to the file')
    parser.add_argument('block_size_MB', type=int, help='Block size in MB')
    parser.add_argument('--parallel', action='store_true', 
                        help='Use parallel processing (default: False)')

    args = parser.parse_args()

    speed = file_read_speed(args.filename, args.block_size_MB, args.parallel)
    print(f"Read speed: {speed:.2f} MB/s")

if __name__ == "__main__":
    main()
