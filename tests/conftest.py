# -*- coding: utf-8 -*-

# Copyright 2025 (c) Vladislav Punko <iam.vlad.punko@gmail.com>

import pytest
from loguru import logger


@pytest.fixture
def caplog(caplog):
    """Fixture to capture log messages during test execution.

    Notes
    -----
        See information: https://loguru.readthedocs.io/en/stable/resources.html
    """
    handler_id = logger.add(
        caplog.handler,
        # ---
        filter=lambda record: record["level"].no >= caplog.handler.level,
        format="{message}",
        level=0,
    )

    yield caplog

    logger.remove(handler_id)
