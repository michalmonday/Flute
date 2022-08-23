
package ContinuousMonitoringStruct;

import CPU_Globals :: *;
import ISA_Decls :: *;

typedef struct {
    //PCC_T pcc; // tuple of caps object and 64 bits
    WordXL pc;
    Instr instr; // 32 bit
    Bool pc_valid;
 } ContinuousMonitoringStruct
 deriving (Bits);


//interface CMS_IFS;
//    method PCC_T pcc;
//endinterface

endpackage