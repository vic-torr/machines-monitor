#!/usr/bin/python3
# -*- coding: utf-8 -*-

import sys
import re

def validator_regex(password, requirements):
    """
    Find all the characters which matches the pattern
    corresponding to input requirements. 
    After filter characters, join all of them,
    and check if it matches with the specified length.


    Args:
        password (str): Password to be validated.
        requirements (List[tuple]): List of rules.

    Returns:
        [bool]: True if password satisfies requirements.
    """
    does_pass=True
    for n_req in requirements:
        print(n_req)
        (operation, comparation, length) = n_req
        size = {
            '<': r"{,"                     +rf"{length-1}" + r"}",
            '>': r"{"    + rf"{length+1}"                + r",}",
            '=': r"{"    + rf"{length},"     +f"{length}" + r"}"
        }
        req_dict = {
            "LEN": r".",
            "SPECIALS": r"[^a-zA-Z0-9]",
            "LETTERS": r"[a-zA-Z]",
            "NUMBERS": r"[0-9]",
        }
        rule_char = "("+req_dict[operation]+")"
        rule_size = "("+req_dict[operation]+size[comparation]+")"
        match = ''.join(re.findall(rule_char,password))
        match = re.fullmatch(rule_size,match)
        match = "" if match == None else match.string
        does_pass = does_pass and match != None and match != ""
        
    return does_pass



if __name__ == '__main__':
    validator_regex(sys.argv[1:])
