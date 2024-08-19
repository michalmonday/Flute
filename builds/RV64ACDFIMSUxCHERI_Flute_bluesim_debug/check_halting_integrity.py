# Dependencies: vcd_to_datapoints.py 
# python3 -m pip install pyvcd

import subprocess
import sys
import os
import glob
import argparse 
from pathlib import Path
import re

# THIS SCRIPT WONT WORK AS INTENDED WHEN FLUTE IS COMPILED WITH INCLUDE_GDB_CONTROL
# (the "debug" version can be used/recompiled after removing the INCLUDE_GDB_CONTROL flag from the Makefile and running "make clean")
# btw when the INCLUDE_GDB_CONTROL flag is used, the CPU keeps being halted after CMS resumes it 


parser = argparse.ArgumentParser(description='Compiles CPU with and without halting, then checks if it produces the same PC + GPR write sequences.')

parser.add_argument('--simulation-file', '-s', type=str, default='sim2.vcd', help='Simulation file name to open.')
parser.add_argument('--dont-simulate', '-d', action='store_true', help='Only show differing lines from previous simulations.')

args = parser.parse_args()

def get_root_git_dir():
    '''Returns the root directory of the git repository.'''
    return Path(subprocess.check_output(['git', 'rev-parse', '--show-toplevel']).decode().strip())

def edit_top_file(halt_cpu: bool):
    ''' Edit marked section of the Top_HW_Side.bsv file.
    search for a line that is: "// EDITABLE PART BEGIN" and "// EDITABLE PART END"
    remove anything between these two lines and replace it with the following: soc_top.cms_ifc.halt_cpu(cms_halt_cpu); '''
    top_file_path = get_root_git_dir() / 'src_Testbench' / 'Top' / 'Top_HW_Side.bsv'
    text_to_insert = f'''\
// EDITABLE PART BEGIN
{'' if halt_cpu else '//'}soc_top.cms_ifc.halt_cpu(cms_halt_cpu);
// EDITABLE PART END'''
    with open(top_file_path, 'r') as f:
        text = f.read()
    text = re.sub(r'// EDITABLE PART BEGIN.*// EDITABLE PART END', text_to_insert, text, flags=re.DOTALL)
    with open(top_file_path, 'w') as f:
        f.write(text)

def vcd_to_datapoints_result(vcd_fname, output_fname):
    subprocess.run(['python3', 'vcd_to_datapoints.py', vcd_fname, '-o', output_fname])

def run_simulation(f_name):
    subprocess.run(['make', 'simulator', 'run_example', f'SIM_VCD_NAME={f_name}'])

def get_differing_lines_and_indices(f_name, f_name2):
    '''Can't simply compare content because halted simulation may have less
    datapoints due to limited simulation time.'''
    lines_and_indices = []
    with open(f_name) as f, open(f_name2) as f2:
        lines = f.readlines()
        lines2 = f2.readlines()
    for i in range(min(len(lines), len(lines2))):
        if lines[i] != lines2[i]:
            lines_and_indices.append((lines[i], lines2[i], i))
    return lines_and_indices


halting_datapoints_fname = 'vcd_to_datapoints_result_halting.csv'
no_halting_datapoints_fname = 'vcd_to_datapoints_result_no_halting.csv'
halting_sim_fname = 'sim_halting.vcd'
no_halting_sim_fname = 'sim_no_halting.vcd'

if not args.dont_simulate:
    edit_top_file(halt_cpu=True)
    run_simulation(halting_sim_fname)
    vcd_to_datapoints_result(halting_sim_fname, halting_datapoints_fname)

    edit_top_file(halt_cpu=False)
    run_simulation(no_halting_sim_fname)
    vcd_to_datapoints_result(no_halting_sim_fname, no_halting_datapoints_fname)

lines_and_indices = get_differing_lines_and_indices(halting_datapoints_fname, no_halting_datapoints_fname)

if not lines_and_indices:
    print(('\n\nNoice, two simulations (with and without halting CPU) produced the same PC + GPR write sequences. '
           'Unless the testing program was not sufficiently long, behaviour seems consistent.'
           'Whatever change was done to CPU, it fixed the halting issue.'))
else:
    print()
    print('Differing lines:')
    print()
    for line, line2, i in lines_and_indices:
        print(f'Line {i}:')
        print(f'With halting:    {line.strip()}')
        print(f'Without halting: {line2.strip()}')
        print()



