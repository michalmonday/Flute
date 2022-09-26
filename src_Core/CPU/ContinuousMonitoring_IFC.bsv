
package ContinuousMonitoring_IFC;

import CPU_Globals :: *;
import ISA_Decls :: *;

interface ContinuousMonitoring_IFC;
    (* always_ready, always_enabled *) method WordXL pc;
    (* always_ready, always_enabled *) method Instr instr; 
    (* always_ready, always_enabled *) method Bool pc_valid;
    (* always_ready, always_enabled *) method Bit#(Report_Width) evt_MEM_CAP_LOAD;
	(* always_ready, always_enabled *) method Bit#(Report_Width) evt_MEM_CAP_STORE;
	(* always_ready, always_enabled *) method Bit#(Report_Width) evt_MEM_CAP_LOAD_TAG_SET;
	(* always_ready, always_enabled *) method Bit#(Report_Width) evt_MEM_CAP_STORE_TAG_SET;

    // TGC (tag cache) events
	(* always_ready, always_enabled *) method Bit#(Report_Width) tgc_evt_WRITE;
	(* always_ready, always_enabled *) method Bit#(Report_Width) tgc_evt_WRITE_MISS;
	(* always_ready, always_enabled *) method Bit#(Report_Width) tgc_evt_READ;
	(* always_ready, always_enabled *) method Bit#(Report_Width) tgc_evt_READ_MISS;
	(* always_ready, always_enabled *) method Bit#(Report_Width) tgc_evt_EVICT;
	(* always_ready, always_enabled *) method Bit#(Report_Width) tgc_evt_SET_TAG_WRITE;
	(* always_ready, always_enabled *) method Bit#(Report_Width) tgc_evt_SET_TAG_READ;

    // (* always_ready, always_enabled *) method Bool stageD_valid;
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

endpackage