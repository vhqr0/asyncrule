#!/usr/bin/env python

import setuptools

setuptools.setup(
    name='asyncrule',
    version='1.0.0',
    author='vhqr',
    description='async related macros for hylang',
    install_requires=['hy == 0.27.0', 'hyrule == 0.4.0'],
    py_modules=['asyncrule'],
)
