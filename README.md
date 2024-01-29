# speedy
Try reading files with bash, matlab, python etc.

## Background
The goal is to find out the reading speed using different language, serial or parallel, with cache or without cache etc.

## Run shell script

```
# Filename: run_dd.sh
# run without cache (clear cache)
#./run_dd.sh ../sqw/X.sqw 10M 50 50 n
# run without cache (do not clear cache)
#./run_dd.sh ../sqw/Y.sqw 10M 50 50 n
```

## Run python script
```
# Example of usage
# ===  without multiprocessing
# python3 readFile.py /path/to/file 10 
# === with multiprocessing
# python3 readFile.py /path/to/file 10 --parallel

```

## Run Matlab script

Example of run in serial reading, see file main_call.m

Example of run in parallel reading, see file main_call_p.m
