import pandas as pd

events_definitions = '''
	if (ev.mab_EventsCore matches tagged Valid .t) begin
		events[0] = t.evt_NO_EV;
		events[1] = t.evt_REDIRECT;
		events[2] = t.evt_TRAP;
		events[3] = t.evt_BRANCH;
		events[4] = t.evt_JAL;
		events[5] = t.evt_JALR;
		events[6] = t.evt_AUIPC;
		events[7] = t.evt_LOAD;
		events[8] = t.evt_STORE;
		events[9] = t.evt_LR;
		events[10] = t.evt_SC;
		events[11] = t.evt_AMO;
		events[12] = t.evt_SERIAL_SHIFT;
		events[13] = t.evt_INT_MUL_DIV_REM;
		events[14] = t.evt_FP;
		events[15] = t.evt_SC_SUCCESS;
		events[16] = t.evt_LOAD_WAIT;
		events[17] = t.evt_STORE_WAIT;
		events[18] = t.evt_FENCE;
		events[19] = t.evt_F_BUSY_NO_CONSUME;
		events[20] = t.evt_D_BUSY_NO_CONSUME;
		events[21] = t.evt_1_BUSY_NO_CONSUME;
		events[22] = t.evt_2_BUSY_NO_CONSUME;
		events[23] = t.evt_3_BUSY_NO_CONSUME;
		events[24] = t.evt_IMPRECISE_SETBOUND;
		events[25] = t.evt_UNREPRESENTABLE_CAP;
		events[26] = t.evt_MEM_CAP_LOAD;
		events[27] = t.evt_MEM_CAP_STORE;
		events[28] = t.evt_MEM_CAP_LOAD_TAG_SET;
		events[29] = t.evt_MEM_CAP_STORE_TAG_SET;
		events[30] = t.evt_INTERRUPT;
	end
	if (ev.mab_EventsL1I matches tagged Valid .t) begin
		events[32] = t.evt_LD;
		events[33] = t.evt_LD_MISS;
		events[34] = t.evt_LD_MISS_LAT;
		events[41] = t.evt_TLB;
		events[42] = t.evt_TLB_MISS;
		events[43] = t.evt_TLB_MISS_LAT;
		events[44] = t.evt_TLB_FLUSH;
	end
	if (ev.mab_EventsL1D matches tagged Valid .t) begin
		events[48] = t.evt_LD;
		events[49] = t.evt_LD_MISS;
		events[50] = t.evt_LD_MISS_LAT;
		events[51] = t.evt_ST;
		events[52] = t.evt_ST_MISS;
		events[53] = t.evt_ST_MISS_LAT;
		events[54] = t.evt_AMO;
		events[55] = t.evt_AMO_MISS;
		events[56] = t.evt_AMO_MISS_LAT;
		events[57] = t.evt_TLB;
		events[58] = t.evt_TLB_MISS;
		events[59] = t.evt_TLB_MISS_LAT;
		events[60] = t.evt_TLB_FLUSH;
		events[61] = t.evt_EVICT;
	end
	if (ev.mab_EventsTGC matches tagged Valid .t) begin
		events[64] = t.evt_WRITE;
		events[65] = t.evt_WRITE_MISS;
		events[66] = t.evt_READ;
		events[67] = t.evt_READ_MISS;
		events[68] = t.evt_EVICT;
		events[69] = t.evt_SET_TAG_WRITE;
		events[70] = t.evt_SET_TAG_READ;
	end
	if (ev.mab_AXI4_Slave_Events matches tagged Valid .t) begin
		events[71] = t.evt_AW_FLIT;
		events[72] = t.evt_W_FLIT;
		events[73] = t.evt_W_FLIT_FINAL;
		events[74] = t.evt_B_FLIT;
		events[75] = t.evt_AR_FLIT;
		events[76] = t.evt_R_FLIT;
		events[77] = t.evt_R_FLIT_FINAL;
	end
	if (ev.mab_AXI4_Master_Events matches tagged Valid .t) begin
		events[78] = t.evt_AW_FLIT;
		events[79] = t.evt_W_FLIT;
		events[80] = t.evt_W_FLIT_FINAL;
		events[81] = t.evt_B_FLIT;
		events[82] = t.evt_AR_FLIT;
		events[83] = t.evt_R_FLIT;
		events[84] = t.evt_R_FLIT_FINAL;
	end
	if (ev.mab_EventsLL matches tagged Valid .t) begin
		events[96] = t.evt_LD;
		events[97] = t.evt_LD_MISS;
		events[98] = t.evt_LD_MISS_LAT;
		events[99] = t.evt_ST;
		events[100] = t.evt_ST_MISS;
		events[105] = t.evt_TLB;
		events[106] = t.evt_TLB_MISS;
		events[108] = t.evt_TLB_FLUSH;
		events[109] = t.evt_EVICT;
	end
	if (ev.mab_EventsTransExe matches tagged Valid .t) begin
		events[112] = t.evt_RENAMED_INST;
		events[113] = t.evt_WILD_JUMP;
		events[114] = t.evt_WILD_EXCEPTION;
	end
	return events;
endfunction
'''


def get_event_names(s):
    names = []
    current_index = 0
    missing_names = 0
    cat = 'CATEGORY_NONE'
    for line in s.splitlines():
        line = line.strip()
        if line.startswith('if'):
            cat = line.split('mab_')[1].split(' ')[0].replace('_Events', '').replace('Events', '')
            print(cat)
        if line.startswith('events'):
            event_index = int(line.split('[')[1].split(']')[0])
            while current_index < event_index:
                names.append(f'UNKNOWN_{current_index}')
                current_index += 1
            name = cat + '__' + line.split('evt_')[1].split(';')[0]
            names.append(name)
            current_index = event_index + 1
            print('   ', name)
    return names

event_names = get_event_names(events_definitions)

# typedef struct {
# 	Maybe#(EventsCore) mab_EventsCore;
# 	Maybe#(EventsL1I) mab_EventsL1I;
# 	Maybe#(EventsL1D) mab_EventsL1D;
# 	Maybe#(EventsTGC) mab_EventsTGC;
# 	Maybe#(AXI4_Slave_Events) mab_AXI4_Slave_Events;
# 	Maybe#(AXI4_Master_Events) mab_AXI4_Master_Events;
# 	Maybe#(EventsLL) mab_EventsLL;
# 	Maybe#(EventsTransExe) mab_EventsTransExe;
# } HPMEvents deriving (Bits, FShow);


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
for vcd_signal_name, values in values.items():
    print(values['name'])
    for time, value in values['values']:
        mask = (1 << 64) - 1
        for i in range(115):
            all_events[i].append(value & mask)
            value >>= 64
        

df = pd.DataFrame(all_events, index=event_names).T
for col in df:
    print(df[col].value_counts())
import pdb; pdb.set_trace()