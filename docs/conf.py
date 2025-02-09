import os
import sys

sys.path.insert(0, os.path.abspath("../src/"))

author = "Vladislav Punko"
copyright = "2025, Vladislav Punko"
project = "python_template"
release = "0.0.0"

extensions = [
    "numpydoc",
    "sphinx.ext.autodoc",
    "sphinx.ext.doctest",
    "sphinx.ext.intersphinx",
    "sphinx.ext.viewcode",
]

exclude_patterns = ["_build"]

# Add any paths that contain templates.
templates_path = []

html_static_path = []
# The theme to use for html and html help pages.
html_theme = "sphinx_rtd_theme"
