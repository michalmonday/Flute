// 
// package UART_Model;
// 
// export Other_Peripherals_IFC (..), mkOther_Peripherals;
// 
// // ================================================================
// // BSV library imports
// 
// import  Vector        :: *;
// import  FIFOF         :: *;
// import  GetPut        :: *;
// import  ClientServer  :: *;
// import  ConfigReg     :: *;
// 
// // ----------------
// // BSV additional libs
// 
// import Cur_Cycle  :: *;
// import GetPut_Aux :: *;
// import Semi_FIFOF :: *;
// import AXI4       :: *;
// import SourceSink :: *;
// 
// // ================================================================
// // Project imports
// 
// import Fabric_Defs :: *;
// import SoC_Map     :: *;
// 
// interface Other_Peripherals_IFC;
//    // Reset
//    interface Server #(Bit #(0), Bit #(0))  server_reset;
// 
//    // set_addr_map should be called after this module's reset
//    method Action set_addr_map (Fabric_Addr addr_base, Fabric_Addr addr_lim);
// 
//    // Main Fabric Reqs/Rsps
//    interface AXI4_Slave #(Wd_SId, Wd_Addr, Wd_Data_Periph, 0, 0, 0, 0, 0)
//       slave;
// 
// //    // Interrupt pending
// //    (* always_ready *)
// //    method Bool  intr;
// endinterface
// 
// 
// 
// (* synthesize *)
// module mkOther_Peripherals (Other_Peripherals_IFC);
// 
//    // These regs represent where this UART is placed in the address space.
//    Reg #(Fabric_Addr)  rg_addr_base <- mkRegU;
//    Reg #(Fabric_Addr)  rg_addr_lim  <- mkRegU;
// 
//    // ----------------
//    // Connector to AXI4 fabric
// 
//    let slavePortShim <- mkAXI4ShimFF;
// 
//    // Main Fabric Reqs/Rsps
//    interface  slave = slavePortShim.slave;
// 
// endmodule
// 
// // ================================================================
// 
// endpackage
// 