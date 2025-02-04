# -*- coding: utf-8 -*-

# Copyright 2025 (c) Vladislav Punko <iam.vlad.punko@gmail.com>

from __future__ import annotations

import collections
import collections.abc
import typing

import torch
from loguru import logger

__all__ = ["reduce"]


def reduce(sequence: typing.Iterable[int]) -> int:
    """This function returns the sum of all elements in the input sequence.

    Parameters
    ----------
    sequence : Iterable[int]
        An iterable containing integers to be added together.

    Returns
    -------
    int
        The sum of all elements in the sequence.

    Raises
    ------
    TypeError
        If the input is not an iterable.
    ValueError
        If any element in the sequence is not an integer.
    """
    logger.debug(repr(locals()))

    if not isinstance(sequence, collections.abc.Iterable):
        raise TypeError("The input must be an iterable containing only integers.")

    sequence = list(sequence)
    if not all(isinstance(x, int) for x in sequence):
        raise ValueError("All elements in the sequence must be integers.")

    return torch.sum(torch.as_tensor(sequence), dtype=torch.int32).item()
