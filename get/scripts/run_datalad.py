#!/usr/bin/env python3

import datalad.api as dl

true = [True, "true", "True"]


def get_listing(key="paths"):
    """
    Derive datasets from the environment.
    """
    items = os.environ.get(key)
    if items and isinstance(items, str):
        items = [x.strip() for x in items.split("\n")]
    return items or []


def main():
    source = os.environ.get("source")
    paths = get_listing("paths")
    recursive = os.environ.get("recursive") in true
    all_data = os.environ.get("all") in true
    jobs = int(os.environ.get("jobs", 1) or 1)

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
