import pyvcdr
import sys
import argparse

parser = argparse.ArgumentParser(description='Reads VCD file and stores the states of signals of interest in a CSV file.')
#positional arg
parser.add_argument('vcd_file', type=str, help='VCD file to read')
#optional args
parser.add_argument('--output', '-o', type=str, default='vcd_to_datapoints_result.csv', help='Output CSV file')
args = parser.parse_args()


def read_signals_of_interest(f_name, signals_of_interest):
    ''' Reads .vcd waveform file and returns "steps",
    each step is a tuple (time, value) for each signal of interest
    (program counter, register address, register value).
    It converts binary string values to integers too. '''
    a = pyvcdr.VcdR()
    a.read_file(f_name)
    ret = [None] * len(signals_of_interest)
    for sig in a.signals:
        try:
            i = signals_of_interest.index(sig.module)
        except ValueError:
            continue
        # convert string "b1010011" values to integers
        for j, (time, value) in enumerate(sig.steps):
            # try:
            val = int(value[1:], 2) if value.startswith('b') else int(value)
            sig.steps[j] = (time, val)
            # except Exception as e:
            #     import pdb; pdb.set_trace()
        ret[i] = sig.steps
    return ret

def sync_other_steps(pc_steps, all_other_steps_list):
    '''By default .vcd file contains different number of steps for each signal
    (because their values change at different times). This function, for each 
    program counter value finds the corresponding values of other signals based 
    on their last changes (so their current state).

    Example input:
        pc_steps = [(0, 0x8000000), (100, 0x8000004), (300, 0x8000008)] 
        all_other_steps_list = [
            [(0, 0), (50, 4), (200, 1), (400, 2)], # rg_written_reg_name
            [(0, 0), (50, 5), (100, 1), (200, 2)]  # rg_written_reg_value
        ]
    
    Corresponding output:
        [(0x8000000, 0, 0), (0x8000004, 4, 1), (0x8000008, 1, 2)]
    '''
    most_recent_times = [0] * len(all_other_steps_list)
    most_recent_index = [0] * len(all_other_steps_list)
    states = []
    for time, value in pcs_steps:
        for i, other_steps in enumerate(all_other_steps_list):
            while most_recent_index[i] < len(other_steps) - 1:
                other_time, other_value = other_steps[ most_recent_index[i]+1 ]
                if other_time > time:
                    break
                most_recent_times[i] = other_time
                most_recent_index[i] += 1
        states.append((value, *[other_steps[most_recent_index[i]][1] for i, other_steps in enumerate(all_other_steps_list)]))
    return states

def store_states_in_csv(states, f_name, header=None):
    '''Stores the states in a CSV file. The first column is the program counter,
    the other columns are the values of the signals of interest.'''
    with open(f_name, 'w') as f:
        if header is not None:
            f.write(header + '\n')
        for state in states:
            f.write(','.join([hex(s) for s in state]) + '\n')


signals_of_interest = [
    'imem_rg_pc', 
    'rg_written_reg_name', # GPR address 
    'rg_written_reg_value'
]

# signals_of_interest = [
#     'rg_cms_pc',
#     'rg_cms_gp_write_reg_name',
#     'rg_cms_gp_write_reg',
#     'rg_cms_gp_write_valid',
#     'rg_cms_instr'
# ]

pcs_steps, *all_other_steps = read_signals_of_interest(args.vcd_file, signals_of_interest)
states = sync_other_steps(pcs_steps, all_other_steps)

store_states_in_csv(states, args.output, header=','.join(signals_of_interest))

# pcs_steps = [(0, 0x8000000), (100, 0x8000004), (300, 0x8000008), (400, 0x800000c)] 
# all_other_steps_list = [
#     [(0, 0), (50, 4), (200, 1), (400, 2)], # rg_written_reg_name
#     [(0, 0), (50, 5), (100, 1), (200, 2)]  # rg_written_reg_value
# ]
# states = get_program_counter_states(pcs_steps, all_other_steps_list)

# print(states)
