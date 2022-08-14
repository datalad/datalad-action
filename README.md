# Datalad Action

     ____            _             _                   _ 
    |  _ \    __ _  | |_    __ _  | |       __ _    __| |
    | | | |  / _` | | __|  / _` | | |      / _` |  / _` |
    | |_| | | (_| | | |_  | (_| | | |___  | (_| | | (_| |
    |____/   \__,_|  \__|  \__,_| |_____|  \__,_|  \__,_|
                                                  Actions

This repository will serve a set of actions to interact with Datalad.

## Install

Minimally, you can install datalad to interact with in your workflow. The
most basic usage looks like:

```yaml
name: Test Datalad Action
on:
  pull_request: []
  push:
    branches:
      - main 
 
jobs:
  install-spack:
    runs-on: ubuntu-latest
    name: Install Datalad
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Install Datalad
        uses: datalad/datalad-action/install@main
```

However, there are ample ways to customize the install! Here is an example
of installing from a different branch:

```yaml
...
      - name: Install Datalad
        uses: datalad/datalad-action/install@main
        with:
          branch: debian
```

An entire table of options is shown here, and you can look at the [install/action.yaml](install/action.yaml)
for more details.

| Name | Description | Default | Required |
|------|-------------|---------|----------|
| repository  | Repository to install datalad | datalad/datalad | no |
| branch      | The branch of datalad to use | master | no |
| install_root| If installed from a branch and full_clone, install to this root | /opt/datalad | no |
| release     | A datalad release to use (if defined, over-rides branch) | unset | no |
| full_clone  | Instead of cloning with `--depth 1`, clone the entire git history (branch only) | false | no |
| user        | User to provide to GitHub | github-actions | no |
| email       | Email to provide to GitHub | github-actions@users.noreply.github.com | no |


## Download

This will download (get) a datalad dataset. Here is a simple example:

```yaml
name: Download Dataset
on:
  pull_request: []
  push:
    branches:
      - main 
 
jobs:
  get-dataset:
    runs-on: ubuntu-latest
    name: Datalad Install and Get
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Download Dataset
        uses: datalad/datalad-action/get@main
        with:
          source: https://github.com/psychoinformatics-de/studyforrest-data-phase2
```


