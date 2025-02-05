# -*- coding: utf-8 -*-

# Copyright 2025 (c) Vladislav Punko <iam.vlad.punko@gmail.com>

import logging

import pytest

from python_template import api


@pytest.mark.parametrize(
    "sequence",
    [
        (1, 2, 3),
        (4, 5, 6),
        (7, 8, 9),
    ],
)
def test_reduce(caplog, sequence):
    with caplog.at_level(logging.DEBUG):
        assert api.reduce(sequence) == sum(sequence)

    assert f"{{'sequence': {sequence!s}}}" in caplog.text


def test_reduce_check_sequence_is_not_iterable():
    with pytest.raises(TypeError) as error:
        api.reduce(None)

    assert str(error.value) == "The input must be an iterable containing only integers."


def test_reduce_check_sequence_has_not_integer():
    with pytest.raises(ValueError) as error:
        api.reduce("test")

    assert str(error.value) == "All elements in the sequence must be integers."
