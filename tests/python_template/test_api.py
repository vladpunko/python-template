# -*- coding: utf-8 -*-

# Created by: Vladislav Punko <iam.vlad.punko@gmail.com>
# Created date: 2025-02-05

import logging

import pytest

from python_template import api


@pytest.mark.parametrize(
    "sequence",
    [
        (),
        (1, 2, 3),
        (4, 5, 6),
        (7, 8, 9),
        (-3, -2, -1),
        (2**31 - 1, 1),
        (-(2**31), -1),
        (2**32,),
        (2**63, 1),
        (2**100, 1, -(2**100)),
    ],
)
def test_reduce(caplog, sequence):
    with caplog.at_level(logging.DEBUG):
        assert api.reduce(sequence) == sum(sequence)

    assert f"{{'sequence': {sequence!s}}}" in caplog.text


def test_reduce_accepts_single_pass_iterables():
    assert api.reduce(value for value in range(5)) == 10


def test_reduce_check_sequence_is_not_iterable():
    with pytest.raises(TypeError) as error:
        api.reduce(None)

    assert str(error.value) == "The input must be an iterable containing only integers."


@pytest.mark.parametrize("sequence", ["test", [1, 2.5], [1, None]])
def test_reduce_check_sequence_has_not_integer(sequence):
    with pytest.raises(ValueError) as error:
        api.reduce(sequence)

    assert str(error.value) == "All elements in the sequence must be integers."
