.DEFAULT_GOAL := help

POETRY ?= poetry
export POETRY
CONTAINER_NAME ?= python_template_container
CONTAINER_VERSION ?= $(shell git rev-parse HEAD)
PROFILE_SCRIPT ?= main.py
TOX_ENV ?=

.PHONY: help lock bootstrap build upload container devcontainer hooks tests test-all docs lint stubs jupyter analysis clean

.PHONY: help
help:
	@echo 'help         - show help'
	@echo 'lock         - lock the project dependencies'
	@echo 'bootstrap    - install the project dependencies'
	@echo 'build        - build project packages'
	@echo 'upload       - upload built packages to package repository'
	@echo 'container    - build the docker image on the current machine'
	@echo 'devcontainer - run isolated environment inside the docker container'
	@echo 'hooks        - install all git hooks'
	@echo 'tests        - run project tests'
	@echo 'test-all     - run the tox Python matrix, optionally with TOX_ENV=py314'
	@echo 'docs         - generate the project documentation'
	@echo 'lint         - inspect project source code for problems and errors'
	@echo 'stubs        - create files that include only type hints for the public interface of modules'
	@echo 'jupyter      - run jupyter server'
	@echo 'analysis     - run the python script with performance analysis'
	@echo 'clean        - remove generated reports and build artifacts'

.PHONY: lock
lock:
	@$(POETRY) lock

bootstrap: poetry.lock poetry.toml pyproject.toml
	@$(POETRY) check --strict --lock
	@$(POETRY) install --only main,dev,tests --no-interaction

build:
	@$(POETRY) check --strict --lock
	@$(POETRY) build --clean

upload: build
	@$(POETRY) install --only main,dev --no-interaction
	@$(POETRY) run twine check --strict dist/*
	@$(POETRY) run twine upload --non-interactive --skip-existing dist/*

.PHONY: container
container:
	@docker build --tag $(CONTAINER_NAME):$(CONTAINER_VERSION) "$(CURDIR)"

devcontainer: container
	@docker run --interactive --rm --tty --gpus all --volume "$(CURDIR):/app" $(CONTAINER_NAME):$(CONTAINER_VERSION)

hooks:
	@$(POETRY) install --only main,dev --no-interaction
	@$(POETRY) run pre-commit install --config .githooks.yml

tests:
	@$(POETRY) install --only main,tests --no-interaction
	@$(POETRY) run pytest

test-all:
	@$(POETRY) install --only main,dev --no-interaction
	@$(POETRY) run tox $(if $(TOX_ENV),-e "$(TOX_ENV)")

docs:
	@$(POETRY) install --only main,docs --no-interaction
	@$(POETRY) run sphinx-build -E -W --builder=html docs docs/_build/html

lint:
	@$(POETRY) install --only main,dev --no-interaction
	@$(POETRY) run pre-commit run --all-files --show-diff-on-failure --config .githooks.yml

stubs:
	@$(POETRY) install --only main,dev --no-interaction
	@$(POETRY) run stubgen --output .stubs -- src

jupyter:
	@$(POETRY) install --only main,notebooks --extras cpu --no-interaction
	@$(POETRY) run jupyter notebook --log-level INFO --ServerApp.notebook_dir "$(CURDIR)"

analysis:
	@$(POETRY) install --only main,profiling --no-interaction
	@$(POETRY) run python -m cProfile -o analysis.prof "$(PROFILE_SCRIPT)"
	@$(POETRY) run snakeviz analysis.prof

.PHONY: clean
clean:
	rm -rf -- .coverage .coverage.* .mypy_cache .pytest_cache .pytest_report .ruff_cache .stubs .tox build dist docs/_build htmlcov analysis.prof
