
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

    // Events bitmap, indicating which event is currently taking place
    (* always_ready, always_enabled *) method Bit#(No_Of_Selected_Evts) performance_events;


    (* always_ready, always_enabled *) method Bit#(1) perf_jal;
    (* always_ready, always_enabled *) method Bit#(1) perf_branch;
    (* always_ready, always_enabled *) method Bit#(1) perf_auipc;

    // (* always_ready, always_enabled *) method Stage_OStatus stage1_ostatus;
    // (* always_ready, always_enabled *) method Control stage1_control;
    // (* always_ready, always_enabled *) method Stage_OStatus stage2_ostatus;
endinterface


endpackage