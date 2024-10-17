# Project 0x2A Documentation

The home of the consolidated documentation for Project 0x2A sponsored by Mirantis.

[Project 0x2A Docs](https://mirantis.github.io/project-2a-docs/)

This project utilises Mkdocs with the Material theme and Mermaid for diagrams. Currently
the docs are published using github actions on github pages from the branch gh-pages.

Development is tracked under [Project 0x2A](https://github.com/orgs/Mirantis/projects/8) on github.

The related Project 0x2A repositories can be found as follows:
 * [HMC](https://github.com/Mirantis/hmc)


## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        stylesheets  # CSS stylesheets to control look and feel
        assets  # Images and other served material
        ...       # Other markdown pages, images and other files.


## Setting up MKdocs and dependancies

1. Setup python Virtual Environment

    `python3  -m venv ./mkdocs`
    `source ./mkdocs/bin/activate`

2. Install MkDocs

    `pip install mkdocs`

3. Install plugins

    `pip install mkdocs-mermaid2-plugin`

    `pip install mkdocs-material`

	`pip install markdown-callouts`

## Run MKdocs for dev

* `mkdocs serve` - Start the live-reloading docs server.

For full documentation visit [mkdocs.org](https://www.mkdocs.org).

## MKdocs Commands

* `mkdocs new [dir-name]` - Create a new project.
* `mkdocs serve` - Start the live-reloading docs server.
* `mkdocs build` - Build the documentation site.
* `mkdocs -h` - Print help message and exit.
