
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

`ifdef ISA_CHERI
import CHERICap :: *;
import CHERICC_Fat :: *;
`endif


`ifdef ISA_CHERI
`define INTERNAL_REG_TYPE CapReg
`define EXTERNAL_REG_TYPE_OUT CapPipe
`define EXTERNAL_REG_TYPE_IN CapReg
`else
`define INTERNAL_REG_TYPE Word
`define EXTERNAL_REG_TYPE_OUT Word
`define EXTERNAL_REG_TYPE_IN Word
`endif


interface ContinuousMonitoring_IFC;
    (* always_ready, always_enabled *) method WordXL pc;
    (* always_ready, always_enabled *) method Instr instr; 

    // Events bitmap, indicating which event is currently taking place
    (* always_ready, always_enabled *) method Bit#(No_Of_Selected_Evts) performance_events;
    // (* always_ready, always_enabled *) method Bit#(2048) registers_meta;

    // This will allow to halt cpu when internal trace storage is full 
    // (which shouldn't happen in a non-instrusive monitoring system, ideally it won't happen)
    (* always_ready *) method Action halt_cpu(Bit#(1) state);

    (* always_ready, always_enabled *) method RegName gp_write_reg_name; // register index/address in GPR file
    (* always_ready, always_enabled *) method Capability gp_write_reg; 
    (* always_ready, always_enabled *) method Bool gp_write_valid;       // True if GPR is currently overwritten
    // OLD WAY:
    // (* always_ready, always_enabled *) method Bit#(512) registers;


    // (* always_ready, always_enabled *) method Bit#(1) perf_jal;
    // (* always_ready, always_enabled *) method Bit#(1) perf_branch;
    // (* always_ready, always_enabled *) method Bit#(1) perf_auipc;

    // (* always_ready, always_enabled *) method Stage_OStatus stage1_ostatus;
    // (* always_ready, always_enabled *) method Control stage1_control;
    // (* always_ready, always_enabled *) method Stage_OStatus stage2_ostatus;
endinterface


endpackage