.DEFAULT: help

CONTAINER_NAME = python_template_container
.ONESHELL:
CONTAINER_VERSION ?= $(shell git rev-parse HEAD)

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
	@echo 'docs         - generate the project documentation'
	@echo 'lint         - inspect project source code for problems and errors'
	@echo 'stubs        - create files that include only type hints for the public interface of modules'
	@echo 'jupyter      - run jupyter server'
	@echo 'clean        - clean up project environment and all the build artifacts'

.PHONY: lock
lock:
	@poetry lock --no-cache

bootstrap: poetry.lock poetry.toml pyproject.toml
	@poetry check
	@poetry install -vv --compile --no-cache --with dev --with docs --with tests

build: bootstrap
	@poetry build --clean

upload: build
	@poetry run twine upload --non-interactive dist/*

.PHONY: container
container:
	@env DOCKER_BUILDKIT=1 docker build --network host --tag $(CONTAINER_NAME):$(CONTAINER_VERSION) $(PWD)

devcontainer: container
	@docker run --interactive --network host --rm --tty --volume $(PWD):/src:Z $(CONTAINER_NAME):$(CONTAINER_VERSION)

hooks: bootstrap
	@poetry run pre-commit install --config .githooks.yml

tests: bootstrap
	@poetry run tox

docs: bootstrap
	@poetry run tox -e docs

lint: bootstrap
	@poetry run tox -e lint

stubs: bootstrap
	@poetry run stubgen --output .stubs -- src

jupyter: bootstrap
	@poetry run jupyter notebook --log-level INFO --ServerApp.notebook_dir $(PWD)

.PHONY: clean
clean:
	git clean -X -d --force
