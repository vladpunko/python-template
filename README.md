# {{PROJECT_NAME}}

{{BADGES}}

{{DESCRIPTION}}

{{IMAGE_PREVIEW}}

## Installation

It is recommended to use this package together with [virtualenv](https://github.com/pypa/virtualenv) and [virtualenvwrapper](https://bitbucket.org/virtualenvwrapper/virtualenvwrapper) to work with python virtual environments more suitable. Make sure the installed [python](https://wiki.archlinux.org/title/python) interpreters work without errors on the current operating system. To install this package you are to use the [pip](https://pip.pypa.io/en/stable) package manager by running the following command:

```bash
python3 -m pip install {{PROJECT_NAME}}
```

You can also install this python package on your working machine from source code:

```bash
# Step -- 1.
git clone --depth=1 --branch=master {{GIT_REPOSITORY_URL}}

# Step -- 2.
cd ./{{PROJECT_NAME}}/

# Step -- 3.
echo 'All the required steps.'
```

## Basic Usage

{{USAGE_DESCRIPTION}}

```bash
echo 'Usage examples.'
```

## Contributing

Pull requests are welcome.
Please open an issue first to discuss what should be changed.

Please make sure to update tests as appropriate.

```bash
# Step -- 1.
python3 -m venv .venv && source ./.venv/bin/activate && pip install pre-commit tox

# Step -- 2.
make hooks

# Step -- 3.
make tests && make lint
```

## License

[MIT](https://choosealicense.com/licenses/mit)
