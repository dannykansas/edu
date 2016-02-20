#!/usr/bin/env python

'''
Function:
Generate random dollar figures between two input values for `x` number of iters.

Purpose:
Pretty much useless. Experimenting with pseudo-Random Number Generator functions
and implementing them in various languages. I wouldn't recommend using this for
anything that needs a true RNG.

Enjoy?

Example Usage:
> python xpense.py --min=10 --max=45 --num=3
  $12.00
  $19.00
  $18.00
'''

import os
import sys
import argparse

def parse_args():
    '''
    Get arguments from the command like with argparse
    '''
    parser = argparse.ArgumentParser(
        description='Generate a list of random whole dollar values between a minimum and maximum.'
        )
    parser.add_argument(
        '--min', '-m', required=True, help='Minimum Dollar Value',
            type=int)
    parser.add_argument(
        '--max', '-x', required=True, help='Maximum Dollar Value',
            type=int)
    parser.add_argument(
        '--iter', '-i', required=False, help='Total number of figures to be iterated',
			default=10, type=int)
    # parser.add_argument(
    #     '--force_download', '-F', required=False,
    #     help='Force Download', action='store_true')
    # parser.add_argument(
    #     '--file', '-f', required=False, help='Config File',
    #     default=os.path.expanduser('~') + '/.ec2_addr_cache')
    # parser.add_argument(
    #     '--region', '-r', required=False, help='EC2 Region',
    #     default='us-west-2')
    # parser.add_argument(
    #     '--perpage', '-P', required=False,
    #     help='Hosts to display per page (default 25, 0 to display all)',
    #     default=25, type=int)
    args = parser.parse_args()
    return args
