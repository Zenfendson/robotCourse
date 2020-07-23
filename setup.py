from setuptools import setup, find_packages
import os
import shutil
import sys
import subprocess
from distutils.dir_util import copy_tree
hw_data_files = []
sw_data_files = []
if os.geteuid() != 0:
    print("This program must be run as root. Aborting.")
    sys.exit(1)

if os.environ['BOARD'] != 'Pynq-Z2' and os.environ['BOARD'] != 'Pynq-Z1':
    print("Only supported on a Pynq-Z2 and Pynq-Z1 Board")
    exit(1)

def copy_notebooks():
    src_nb_dir = os.path.join(f'', 'notebook')
    dst_nb_dir = os.path.join(os.environ['PYNQ_JUPYTER_NOTEBOOKS'], 'PYNQ_Car')
    if os.path.exists(dst_nb_dir):
        shutil.rmtree(dst_nb_dir)
    copy_tree(src_nb_dir, dst_nb_dir)

def copy_overlays():
    src_ol_dir = os.path.join('hw/', '')
    dst_ol_dir = os.path.join(f'/usr/local/lib/python3.6/dist-packages/PYNQ_Car/Overlay', '')
    copy_tree(src_ol_dir, dst_ol_dir)
    hw_data_files.extend([os.path.join("..", dst_ol_dir, f) for f in os.listdir(dst_ol_dir)])

def copy_lib():
    src_lib_dir = os.path.join('PYNQ_Car/', '')
    dst_lib_dir = os.path.join(f'/usr/local/lib/python3.6/dist-packages/PYNQ_Car', '')
    if os.path.exists(dst_lib_dir):
        shutil.rmtree(dst_lib_dir)
    copy_tree(src_lib_dir, dst_lib_dir)
    sw_data_files.extend([os.path.join("..", dst_lib_dir, f) for f in os.listdir(dst_lib_dir)])


copy_lib()
copy_notebooks()
copy_overlays()
setup(
        name = "PYNQ_Car",
        version = 1.0,
        license = 'BSD 3-Clause License',
        author = "Liang Sen",

        include_package_data = True,
        packages = find_packages(),
        package_data = {
        '' : hw_data_files+sw_data_files,
        },
    install_requires=[
        'pynq>=2.4','numpy','matplotlib'
    ],
)
