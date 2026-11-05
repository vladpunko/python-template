# Step -- 1.
FROM python:3.14-slim-bookworm AS builder

WORKDIR /build

RUN set -ex && python3 -m pip install --no-cache-dir \
        'poetry==2.5.1' \
        'poetry-plugin-export==1.10.1' \
    && poetry --version

ENV POETRY_CACHE_DIR=/tmp/poetry \
    # Do not ask any interactive question.
    POETRY_NO_INTERACTION=1 \
    # Disables virtual environments to reduce image size.
    POETRY_VIRTUALENVS_CREATE=0

COPY poetry.lock poetry.toml pyproject.toml /build/

RUN poetry export --only main --extras cuda --output requirements.txt \
    && rm --recursive --force -- "${POETRY_CACHE_DIR}"

# Step -- 2.
FROM nvidia/cuda:13.4.3-cudnn-devel-ubuntu26.04 AS runtime

WORKDIR /app

ENV PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    PYTHONUNBUFFERED=1 \
    # Disable pip version checks to minimize runtime and reduce log clutter.
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    # Disable caching to reduce image size.
    PIP_NO_CACHE_DIR=1 \
    PATH=/opt/venv/bin:$PATH

RUN set -ex && apt-get update --yes && apt-get install --yes --no-install-recommends \
        ca-certificates \
        make \
        python3 \
        python3-venv \
    && apt-get clean && rm --recursive --force /var/lib/apt/lists/*

RUN python3 -m venv /opt/venv

COPY --from=builder /build/requirements.txt /tmp/requirements.txt

RUN python3 -m pip install --no-deps --require-hashes -r /tmp/requirements.txt \
    && rm /tmp/requirements.txt

CMD ["bash"]
