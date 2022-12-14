import pandas as pd


def read_signal_values_from_vcd_file(signals=None, f_name='vlt_dump.vcd'):
    """Reads the signal values from a VCD file and returns a dictionary
    with the signal names as keys and a list of tuples (time, value) as
    values.
    """
    signal_values = {}
    with open(f_name, 'r') as f:
        for line in f:
            line = line.strip()
            if line.startswith('$var'):
                values = line.split()
                vcd_signal_name = values[3]
                verilog_signal_name = values[4]
                if verilog_signal_name in signals:
                    signal_values[vcd_signal_name] = {'name': verilog_signal_name, 'values': []}
            elif line.startswith('#'):
                time = int(line[1:])
            elif line.startswith('b'):
                value, vcd_signal_name = line.split()
                value = int(value[1:], 2)
                if vcd_signal_name in signal_values:
                    signal_values[vcd_signal_name]['values'].append((time, value))
                    # print(line)
                    # import pdb; pdb.set_trace()
    return signal_values

values = read_signal_values_from_vcd_file(signals = ['send_performance_events_evts'])

all_events = [[] for _ in range(115)]
for vcd_signal_name, values  in values.items():
    print(values['name'])
    for time, value in values['values']:
        mask = (1 << 64) - 1
        for i in range(115):
            all_events[i].append(value & mask)
            value >>= 64
        

df = pd.DataFrame(all_events).T
for col in df:
    print(df[col].value_counts())
import pdb; pdb.set_trace()