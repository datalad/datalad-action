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

You can use this with a cache action to easily cache the result to your liking.

```bash
...

```

Generally, the download action supports all the same parameters as install, meaning it will
install datalad for you (and you don't need to use install). However, if for some reason
you want to install datalad in a different way (not using the action) as long as it is found on your
path, it won't be installed again. Keep in mind that you don't just need datalad, but you also need git-annex,
and the datalad action installs both. You can learn more about installation [here](https://handbook.datalad.org/en/inm7/intro/installation.html).
Here is a table of parameters that can be used (in addition to the paramaters above, which are included to be explicitly clear).

An entire table of options is shown here, and you can look at the [install/action.yaml](install/action.yaml)
for more details.

| Name | Description | Default | Required |
|------|-------------|---------|----------|
| source      | The dataset source (e.g., a https address) | unset | yes |
| recursive   | Get sub-datasets recursively | true | no |
| jobs        | Number of jobs (workers) for downloading with datalad | auto | no |
| paths       | A list of paths (newline separated) in the dataset to download | unset | no |
| all         | Get all data | unset | no |
| repository  | Repository to install datalad | datalad/datalad | no |
| branch      | The branch of datalad to use | master | no |
| install_root| If installed from a branch and full_clone, install to this root | /opt/datalad | no |
| release     | A datalad release to use (if defined, over-rides branch) | unset | no |
| full_clone  | Instead of cloning with `--depth 1`, clone the entire git history (branch only) | false | no |
| user        | User to provide to GitHub | github-actions | no |
| email       | Email to provide to GitHub | github-actions@users.noreply.github.com | no |

Have any questions? Don't hesitate to open an issue! 
