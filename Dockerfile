# Step -- 1.
FROM python:3.10-slim-bookworm AS builder

WORKDIR /build

RUN set -ex && python3 -m pip install --no-cache-dir \
        'poetry>=2.0,<3.0' \
        'poetry-plugin-export>=1.8,<2.0' \
    && poetry --version

ENV POETRY_CACHE_DIR=/tmp/poetry \
    # Do not ask any interactive question.
    POETRY_NO_INTERACTION=1 \
    # Disables virtual environments to reduce image size.
    POETRY_VIRTUALENVS_CREATE=0

COPY poetry.lock pyproject.toml /build/

RUN poetry export --without-hashes --extras cuda > requirements.txt && rm --recursive --force -- "${POETRY_CACHE_DIR}"

# Step -- 2.
FROM nvidia/cuda:12.6.3-cudnn-devel-ubuntu22.04 AS runtime

WORKDIR /app

ENV PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    PYTHONUNBUFFERED=1 \
    # Disable pip version checks to minimize runtime and reduce log clutter.
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    # Disable caching to reduce image size.
    PIP_NO_CACHE_DIR=1

COPY  --from=builder /build/requirements.txt /app/

RUN set -ex && apt-get update --yes && apt-get install --yes --no-install-recommends \
        build-essential \
        make \
        python3 \
        python3-pip \
    && apt-get clean && rm --recursive --force /var/lib/apt/lists/*

RUN python3 -m pip install --no-cache-dir -r /app/requirements.txt && rm /app/requirements.txt

CMD ["bash"]
