# %%
import pytest
from pass_validator import validator_regex
validator=validator_regex

def test_len_gt_fail():
    req = [('LEN', '=', 8), ('SPECIALS', '>', 1)]
    assert validator("12345678!@", req) == False

def test_validator_len_eq_ok():
    req = [('LEN', '=', 8), ('SPECIALS', '>', 1)]
    assert validator("@23a567!", req) == True

def test_spectial_count():
    req = [('LEN', '>', 8), ('SPECIALS', '>', 1), ('LEN', '<', 10)]
    assert validator("123@4567!", req) == True

def test_validator_gtr():
    req = [('LEN', '>', 8), ('SPECIALS', '>', 1), ('LEN', '<', 10)]
    assert validator("1234567981!", req) == False

# %%
def test_validator_eq():
    req = [('LEN', '>', 8), ('SPECIALS', '>', 1), ('LEN', '<', 10)]
    assert validator("123@567!81", req) == False

# %%
def test_validator_letters():
    req = [('LETTERS', '>', 2), ('SPECIALS', '>', 1), ('LEN', '<', 10)]
    assert validator("1abc@567!", req) == True
