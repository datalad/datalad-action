#!/usr/bin/env python3

import os
import sys

import datalad.api as dl

true = [True, "true", "True"]


def get_paths():
    """
    Derive paths (newline separated) from the environment.
    """
    items = os.environ.get("paths")
    if items and isinstance(items, str):
        items = [x.strip() for x in items.split("\n")]
    return items or []

def get_jobs():
    """
    Get number of jobs (workers) to download
    """
    jobs = os.environ.get("jobs", 1) 

    # The default is a string "auto"
    try:
        jobs = int(jobs)
    except ValueError:
        pass
    return jobs

def main():
    paths = get_paths()
    jobs = get_jobs()
    source = os.environ.get("source")
    recursive = os.environ.get("recursive") in true
    all_data = os.environ.get("all") in true

    print("  Dataset: %s" % source)
    print("    Paths: %s" % paths)
    print("Recursive: %s" % recursive)
    print(" All data: %s" % all_data)
    print("     Jobs: %s" % jobs)

    if not source:
        sys.exit("A dataset (source) is required to download!")

    # Prepare common kwargs
    # I can't find where dl.install is, can't determine kwargs.
    print("Installing dataset {source}")
    ds = dl.install(source=source)
    if paths:
        ds.get(paths)


if __name__ == "__main__":
    main()
