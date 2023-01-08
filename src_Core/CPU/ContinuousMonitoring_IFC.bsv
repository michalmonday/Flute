
package ContinuousMonitoring_IFC;

import CPU_Globals :: *;
import ISA_Decls :: *;

import AXI4_Types  :: *;
import Fabric_Defs :: *;
import GetPut       :: *;
import ClientServer :: *;
import AXI4         :: *;
import Near_Mem_IFC :: *;    // For Wd_Id/Addr/Data/User_Dma

import StatCounters::*;

import Vector::*;


interface ContinuousMonitoring_IFC;
    (* always_ready, always_enabled *) method WordXL pc;
    (* always_ready, always_enabled *) method Instr instr; 
    // (* always_ready, always_enabled *) method Bool pc_valid;
    (* always_ready, always_enabled *) method Bit#(9) pc_valid;

    (* always_ready, always_enabled *) method Stage_OStatus stage1_ostatus;
    (* always_ready, always_enabled *) method Control stage1_control;
    (* always_ready, always_enabled *) method Stage_OStatus stage2_ostatus;


    // All events bitmap, indicating which event is currently taking place
    // No_Of_Evts = 115 in this case of which 85 are active 
    (* always_ready, always_enabled *) method Bit#(No_Of_Nonzero_Evts) performance_events;

    // // Core events
    // (* always_ready, always_enabled *) method Bit#(Report_Width) evt_MEM_CAP_LOAD;
	// (* always_ready, always_enabled *) method Bit#(Report_Width) evt_MEM_CAP_STORE;
	// (* always_ready, always_enabled *) method Bit#(Report_Width) evt_MEM_CAP_LOAD_TAG_SET;
	// (* always_ready, always_enabled *) method Bit#(Report_Width) evt_MEM_CAP_STORE_TAG_SET;

    // // TGC (tag cache) events
	// (* always_ready, always_enabled *) method Bit#(Report_Width) tgc_evt_WRITE;
	// (* always_ready, always_enabled *) method Bit#(Report_Width) tgc_evt_WRITE_MISS;
	// (* always_ready, always_enabled *) method Bit#(Report_Width) tgc_evt_READ;
	// (* always_ready, always_enabled *) method Bit#(Report_Width) tgc_evt_READ_MISS;
	// (* always_ready, always_enabled *) method Bit#(Report_Width) tgc_evt_EVICT;
	// (* always_ready, always_enabled *) method Bit#(Report_Width) tgc_evt_SET_TAG_WRITE;
	// (* always_ready, always_enabled *) method Bit#(Report_Width) tgc_evt_SET_TAG_READ;

    // interface AXI4_Slave #( Wd_Id_Dma, Wd_Addr_Dma, Wd_Data_Dma
    //     , Wd_AW_User_Dma, Wd_W_User_Dma, Wd_B_User_Dma
    //     , Wd_AR_User_Dma, Wd_R_User_Dma)  axi_mem;

    // (* always_ready, always_enabled *) method WordXL stageD_pc;
    // (* always_ready, always_enabled *) method Instr stageD_instr; 
    // (* always_ready, always_enabled *) method Bool stage1_valid;
    // (* always_ready, always_enabled *) method WordXL stage1_pc;
    // (* always_ready, always_enabled *) method Instr stage1_instr; 
    // (* always_ready, always_enabled *) method Bool stage2_valid;
    // (* always_ready, always_enabled *) method WordXL stage2_pc;
    // (* always_ready, always_enabled *) method Instr stage2_instr; 
    // (* always_ready, always_enabled *) method Stage_OStatus ostatusF;
    // (* always_ready, always_enabled *) method Stage_OStatus ostatusD;
    // (* always_ready, always_enabled *) method Stage_OStatus ostatus1;
    // (* always_ready, always_enabled *) method Stage_OStatus ostatus2;
    // (* always_ready, always_enabled *) method Stage_OStatus ostatus3;
endinterface

// function Bit#(No_Of_Evts) generateHPMBitmap(Vector#(115, Bit#(64)) ev);
// 	Bit#(No_Of_Evts) events; //= mkWire(0);
// 	if (ev.mab_EventsCore matches tagged Valid .t) begin
// 		events[0] = t.evt_NO_EV[0];
// 		events[1] = t.evt_REDIRECT[0];
// 		events[2] = t.evt_TRAP[0];
// 		events[3] = t.evt_BRANCH[0];
// 		events[4] = t.evt_JAL[0];
// 		events[5] = t.evt_JALR[0];
// 		events[6] = t.evt_AUIPC[0];
// 		events[7] = t.evt_LOAD[0];
// 		events[8] = t.evt_STORE[0];
// 		events[9] = t.evt_LR[0];
// 		events[10] = t.evt_SC[0];
// 		events[11] = t.evt_AMO[0];
// 		events[12] = t.evt_SERIAL_SHIFT[0];
// 		events[13] = t.evt_INT_MUL_DIV_REM[0];
// 		events[14] = t.evt_FP[0];
// 		events[15] = t.evt_SC_SUCCESS[0];
// 		events[16] = t.evt_LOAD_WAIT[0];
// 		events[17] = t.evt_STORE_WAIT[0];
// 		events[18] = t.evt_FENCE[0];
// 		events[19] = t.evt_F_BUSY_NO_CONSUME[0];
// 		events[20] = t.evt_D_BUSY_NO_CONSUME[0];
// 		events[21] = t.evt_1_BUSY_NO_CONSUME[0];
// 		events[22] = t.evt_2_BUSY_NO_CONSUME[0];
// 		events[23] = t.evt_3_BUSY_NO_CONSUME[0];
// 		events[24] = t.evt_IMPRECISE_SETBOUND[0];
// 		events[25] = t.evt_UNREPRESENTABLE_CAP[0];
// 		events[26] = t.evt_MEM_CAP_LOAD[0];
// 		events[27] = t.evt_MEM_CAP_STORE[0];
// 		events[28] = t.evt_MEM_CAP_LOAD_TAG_SET[0];
// 		events[29] = t.evt_MEM_CAP_STORE_TAG_SET[0];
// 		events[30] = t.evt_INTERRUPT[0];
// 	end
// 	if (ev.mab_EventsL1I matches tagged Valid .t) begin
// 		events[32] = t.evt_LD[0];
// 		events[33] = t.evt_LD_MISS[0];
// 		events[34] = t.evt_LD_MISS_LAT[0];
// 		events[41] = t.evt_TLB[0];
// 		events[42] = t.evt_TLB_MISS[0];
// 		events[43] = t.evt_TLB_MISS_LAT[0];
// 		events[44] = t.evt_TLB_FLUSH[0];
// 	end
// 	if (ev.mab_EventsL1D matches tagged Valid .t) begin
// 		events[48] = t.evt_LD[0];
// 		events[49] = t.evt_LD_MISS[0];
// 		events[50] = t.evt_LD_MISS_LAT[0];
// 		events[51] = t.evt_ST[0];
// 		events[52] = t.evt_ST_MISS[0];
// 		events[53] = t.evt_ST_MISS_LAT[0];
// 		events[54] = t.evt_AMO[0];
// 		events[55] = t.evt_AMO_MISS[0];
// 		events[56] = t.evt_AMO_MISS_LAT[0];
// 		events[57] = t.evt_TLB[0];
// 		events[58] = t.evt_TLB_MISS[0];
// 		events[59] = t.evt_TLB_MISS_LAT[0];
// 		events[60] = t.evt_TLB_FLUSH[0];
// 		events[61] = t.evt_EVICT[0];
// 	end
// 	if (ev.mab_EventsTGC matches tagged Valid .t) begin
// 		events[64] = t.evt_WRITE[0];
// 		events[65] = t.evt_WRITE_MISS[0];
// 		events[66] = t.evt_READ[0];
// 		events[67] = t.evt_READ_MISS[0];
// 		events[68] = t.evt_EVICT[0];
// 		events[69] = t.evt_SET_TAG_WRITE[0];
// 		events[70] = t.evt_SET_TAG_READ[0];
// 	end
// 	if (ev.mab_AXI4_Slave_Events matches tagged Valid .t) begin
// 		events[71] = t.evt_AW_FLIT[0];
// 		events[72] = t.evt_W_FLIT[0];
// 		events[73] = t.evt_W_FLIT_FINAL[0];
// 		events[74] = t.evt_B_FLIT[0];
// 		events[75] = t.evt_AR_FLIT[0];
// 		events[76] = t.evt_R_FLIT[0];
// 		events[77] = t.evt_R_FLIT_FINAL[0];
// 	end
// 	if (ev.mab_AXI4_Master_Events matches tagged Valid .t) begin
// 		events[78] = t.evt_AW_FLIT[0];
// 		events[79] = t.evt_W_FLIT[0];
// 		events[80] = t.evt_W_FLIT_FINAL[0];
// 		events[81] = t.evt_B_FLIT[0];
// 		events[82] = t.evt_AR_FLIT[0];
// 		events[83] = t.evt_R_FLIT[0];
// 		events[84] = t.evt_R_FLIT_FINAL[0];
// 	end
// 	if (ev.mab_EventsLL matches tagged Valid .t) begin
// 		events[96] = t.evt_LD[0];
// 		events[97] = t.evt_LD_MISS[0];
// 		events[98] = t.evt_LD_MISS_LAT[0];
// 		events[99] = t.evt_ST[0];
// 		events[100] = t.evt_ST_MISS[0];
// 		events[105] = t.evt_TLB[0];
// 		events[106] = t.evt_TLB_MISS[0];
// 		events[108] = t.evt_TLB_FLUSH[0];
// 		events[109] = t.evt_EVICT[0];
// 	end
// 	if (ev.mab_EventsTransExe matches tagged Valid .t) begin
// 		events[112] = t.evt_RENAMED_INST[0];
// 		events[113] = t.evt_WILD_JUMP[0];
// 		events[114] = t.evt_WILD_EXCEPTION[0];
// 	end
// 	return events;
// endfunction



endpackage