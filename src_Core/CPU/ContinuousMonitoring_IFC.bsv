
package ContinuousMonitoring_IFC;

import CPU_Globals :: *;
import ISA_Decls :: *;

interface ContinuousMonitoring_IFC;
    (* always_ready, always_enabled *) method WordXL test_pc;
    (* always_ready, always_enabled *) method Instr test_instr; 
    (* always_ready, always_enabled *) method Bool test_pc_valid;
endinterface

endpackage