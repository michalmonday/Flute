
package ContinuousMonitoringStruct;

import CPU_Globals :: *;
import ISA_Decls :: *;

typedef struct {
    PCC_T pcc; // tuple of caps object and 64 bits
    Instr instr; // 32 bit
 } ContinuousMonitoringStruct
 deriving (Bits);

endpackage