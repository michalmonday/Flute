import pandas as pd

# read vcd wave file
import pyvcdr

def read_signals_of_interest(f_name, signals_of_interest):
    ''' Reads .vcd waveform file and returns "steps",
    each step is a tuple (time, value) for each signal of interest
    (program counter, register address, register value).
    It converts binary string values to integers too. '''
    a = pyvcdr.VcdR()
    a.read_file(f_name)
    ret = [] 
    for sig in a.signals:
        if sig.module in signals_of_interest:
            # convert string "b1010011" values to integers
            for i, (time, value) in enumerate(sig.steps):
                sig.steps[i] = (time, int(value[1:], 2))
            ret.append(sig.steps)
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
            f.write(','.join([str(s) for s in state]) + '\n')

signals_of_interest = [
    'imem_rg_pc', 
    'rg_written_reg_name', # GPR address 
    'rg_written_reg_value'
]
pcs_steps, gpr_addresses_steps, gpr_values_steps = read_signals_of_interest('sim2.vcd', signals_of_interest)
states = sync_other_steps(pcs_steps, [gpr_addresses_steps, gpr_values_steps])

store_states_in_csv(states, 'check_halting_integrity_states.csv', header='pc,rg_addr,rg_val')

# pcs_steps = [(0, 0x8000000), (100, 0x8000004), (300, 0x8000008), (400, 0x800000c)] 
# all_other_steps_list = [
#     [(0, 0), (50, 4), (200, 1), (400, 2)], # rg_written_reg_name
#     [(0, 0), (50, 5), (100, 1), (200, 2)]  # rg_written_reg_value
# ]
# states = get_program_counter_states(pcs_steps, all_other_steps_list)

print(states)
raise SystemExit




# # for sig_name, sig in signals_of_interest.items():
# #     if sig is None:
# #         print(f'Signal {sig_name} not found')
# #         continue
# #     if sig_name == 'rg_cycle':
# #         continue
# #     print(f'Signal {sig_name} found')
# #     for i, (time, value) in enumerate(sig.steps):
# #         print(f'{i}: {time} {value:X}')

# raise SystemExit

# # import json
# # import sys
# # from pyDigitalWaveTools.vcd.parser import VcdParser

# # with open('sim2.vcd') as vcd_file:
# #     vcd = VcdParser()
# #     vcd.parse(vcd_file)
# #     data = vcd.scope.toJson()
# #     import pdb; pdb.set_trace()
# #     print(json.dumps(data, indent=4, sort_keys=True))

# # def read_signal_values_from_vcd_file(signals=None, f_name='vlt_dump.vcd'):
# #     """Reads the signal values from a VCD file and returns a dictionary
# #     with the signal names as keys and a list of tuples (time, value) as
# #     values.
# #     """
# #     signal_values = {}
# #     time = 0
# #     with open(f_name, 'r') as f:
# #         for line in f:
# #             line = line.strip()
# #             if line.startswith('$var'):
# #                 values = line.split()
# #                 vcd_signal_name = values[3]
# #                 verilog_signal_name = values[4]
# #                 if verilog_signal_name in signals:
# #                     signal_values[vcd_signal_name] = {'name': verilog_signal_name, 'values': []}
# #             elif line.startswith('#'):
# #                 time = int(line[1:])
# #             elif line.startswith('b'):
# #                 value, vcd_signal_name = line.split()
# #                 print(f'{time} {value} {vcd_signal_name}')
# #                 value = int(value[1:], 2)
# #                 if vcd_signal_name in signal_values:
# #                     signal_values[vcd_signal_name]['values'].append((time, value))
# #                     # print(line)
# #                     # import pdb; pdb.set_trace()
# #     return signal_values

# values = read_signal_values_from_vcd_file(signals=['rg_cycle'], f_name='sim2.vcd')#  signals = ['send_performance_events_evts'])

# import pdb; pdb.set_trace()

# all_events = [[] for _ in range(115)]
# for vcd_signal_name, values in values.items():
#     print(values['name'])
#     for time, value in values['values']:
#         mask = (1 << 64) - 1
#         for i in range(115):
#             all_events[i].append(value & mask)
#             value >>= 64

# df = pd.DataFrame(all_events, index=event_names).T
# for col in df:
#     print(df[col].value_counts())

# # these events are counted (and later collected/traced) by continuous monitoring system
# used_events = [
#     'Core__BRANCH',
#     'Core__JAL',
#     'Core__LOAD',
#     'Core__STORE',
#     'L1I__LD',
#     'L1D__LD',
#     'TGC__WRITE',
#     'TGC__READ'
# ]

# # these events were observed to be not zero when running a short program
# # + Core__TRAP and Core__INTERRUPT added
# selected_events = [
#     'Core__TRAP', # added manually
#     'Core__BRANCH',
#     'Core__JAL',
#     'Core__JALR',
#     'Core__AUIPC',
#     'Core__LOAD',
#     'Core__STORE',
#     'Core__SERIAL_SHIFT',
#     'Core__LOAD_WAIT',
#     'Core__STORE_WAIT',
#     'Core__F_BUSY_NO_CONSUME',
#     'Core__1_BUSY_NO_CONSUME',
#     'Core__2_BUSY_NO_CONSUME',
#     'Core__INTERRUPT', # added manually
#     'L1I__LD',
#     'L1I__LD_MISS',
#     'L1I__LD_MISS_LAT',
#     'L1I__TLB',
#     'L1D__LD',
#     'L1D__LD_MISS',
#     'L1D__LD_MISS_LAT',
#     'L1D__ST',
#     'L1D__TLB',
#     'TGC__WRITE',
#     'TGC__WRITE_MISS',
#     'TGC__READ',
#     'TGC__READ_MISS',
#     'TGC__EVICT',
#     'TGC__SET_TAG_WRITE',
#     'TGC__SET_TAG_READ',
#     'AXI4_Slave__AW_FLIT',
#     'AXI4_Slave__W_FLIT',
#     'AXI4_Slave__W_FLIT_FINAL',
#     'AXI4_Slave__B_FLIT',
#     'AXI4_Slave__AR_FLIT',
#     'AXI4_Slave__R_FLIT',
#     'AXI4_Slave__R_FLIT_FINAL',
#     'AXI4_Master__AW_FLIT',
#     'AXI4_Master__W_FLIT',
#     'AXI4_Master__W_FLIT_FINAL',
#     'AXI4_Master__B_FLIT',
#     'AXI4_Master__AR_FLIT',
#     'AXI4_Master__R_FLIT',
#     'AXI4_Master__R_FLIT_FINAL'
#     ]



# used_events_indices = [event_names.index(e) for e in used_events]
# selected_events_indices = [event_names.index(e) for e in selected_events]

# with open('performance_event_names_used.csv', 'w') as f:
#     f.write('orig_index,new_index,event_name\n')
#     for new_index, (orig_index, e) in enumerate(zip(used_events_indices, used_events)):
#         if new_index != 0:
#             f.write('\n')
#         f.write(f'{orig_index},{new_index},{e}')

# with open('performance_event_names_selected.csv', 'w') as f:
#     f.write('orig_index,new_index,event_name\n')
#     for new_index, (orig_index, e) in enumerate(zip(selected_events_indices, selected_events)):
#         if new_index != 0:
#             f.write('\n')
#         f.write(f'{orig_index},{new_index},{e}')

# with open('performance_event_names_selected_template.txt', 'w') as f:
#     f.write('This file contains lines that can be pasted into CPU.bsv\n')
#     for new_index, (orig_index, e) in enumerate(zip(selected_events_indices, selected_events)):
#         if new_index != 0:
#             f.write('\n')
#         f.write(f'performance_events_local[{new_index}] = events[{orig_index}][0]; // {e}')

#     f.write('\n\n')
#     f.write(f'Selected events counts: {len(selected_events_indices)}')

