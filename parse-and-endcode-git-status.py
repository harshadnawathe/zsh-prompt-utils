#!/usr/bin/python
# -*- coding: UTF-8 -*-

import re
from functools import reduce
from operator import add
from sys import stdin

def color_s(c,s):
	return '\033[38;5;{}m{}\033[m'.format(c,s)

def format_s(s,n):
	return '{}{} '.format(s,n)

def format_info(color_fn, colors, format_fn, symbols, info_tup):
	return ''.join(map(color_fn, colors, map(format_fn, symbols, info_tup)))

def file_counts(git_status_txt):
	match_files = re.compile(r'(^[ADM].\s.*$)|(^.M\s.*$)|(^\sD\s.*$)|(^\?\?\s.*$)', re.MULTILINE)
	str_tr = lambda s: 0 if len(s) is 0 else 1
	tuple_tr = lambda t: map(str_tr,t)
	tuple_add = lambda t1,t2: map(add,t1,t2)
	return reduce(tuple_add, map(tuple_tr, re.findall(match_files, git_status_txt)),(0,0,0,0))

def repo_status(file_counts):
	if sum(file_counts) == 0:
		return color_s(40,'✓')
	format_if_not_empty = lambda s,n: format_s(s,n) if n > 0 else ''
	color_if_not_empty = lambda c,s: color_s(c,s) if len(s) > 0 else ''
	return format_info(color_if_not_empty, (40,208,196,226), format_if_not_empty,('●','○','✗','?'), file_counts) 

def branch_info(git_status_txt):
	match_branch_status = re.compile(r'##\s(.*)\.\.\..*\s\[(?:ahead (\d+))?(?:,\s)?(?:behind (\d+))?\]')
	match = re.match(match_branch_status, git_status_txt)
	if match is not None:
		return match.groups()
	elif git_status_txt.split('\n')[0] == '## Initial commit on master':
		return ('master', None, None)
	else:
		return (None,None,None)

def branch_status(branch_info):
	color_if_not_None = lambda c,s: '' if s is None else color_s(c,s)
	format_if_not_None = lambda s,d: None if d is None else format_s(s,d)
	return format_info(color_if_not_None, (40,226,196), format_if_not_None, ('','↾','⇂'), branch_info)

if __name__ == '__main__':
	txt = stdin.read()
	bs = branch_status(branch_info(txt))
	if len(bs) > 0:
		rs = repo_status(file_counts(txt))
		print('(%s|%s)' % (bs,rs))
