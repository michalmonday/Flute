// Copyright (c) 2013-2020 Bluespec, Inc. All Rights Reserved.

//-
// RVFI_DII modifications:
//     Copyright (c) 2018 Peter Rugg
//     All rights reserved.
//
//     This software was developed by SRI International and the University of
//     Cambridge Computer Laboratory (Department of Computer Science and
//     Technology) under DARPA contract HR0011-18-C-0016 ("ECATS"), as part of the
//     DARPA SSITH research programme.
//-

package Top_HW_Side;

// ================================================================
// mkTop_HW_Side is the top-level system for simulation.
// mkMem_Model is a memory model.

// ================================================================
// BSV lib imports

import GetPut       :: *;
import ClientServer :: *;
import Connectable  :: *;

// ----------------
// BSV additional libs

import Cur_Cycle  :: *;
import GetPut_Aux :: *;

// ================================================================
// Project imports

import ISA_Decls      :: *;
import TV_Info        :: *;
import SoC_Top        :: *;
import Mem_Controller :: *;
import Mem_Model      :: *;
import Fabric_Defs    :: *;
import PLIC           :: *;

import C_Imports        :: *;
import External_Control :: *;

import AXI4_Common_Types:: *;
import AXI4_Types::*;

`ifdef RVFI_DII
import RVFI_DII     :: *;
`endif

import AXI :: *;
import AXI4 :: *;
import SoC_Map :: *;

import Near_Mem_IFC :: *;    // For Wd_{Id,Addr,Data,User}_Dma

import ContinuousMonitoring_IFC :: *;

import CPU_Globals :: *;
// import ISA_Decls :: *;

import CHERICC_Fat :: *;

// ================================================================
// Top-level module.
// Instantiates the SoC.
// Instantiates a memory model.

`ifndef RVFI_DII
(* synthesize *)
module mkTop_HW_Side (Empty);
`else
module mkPre_Top_HW_Side(Flute_RVFI_DII_Server);
`endif

   SoC_Top_IFC    soc_top   <- mkSoC_Top;
   Mem_Model_IFC  mem_model <- mkMem_Model;

   // Reg #(Bit(1)) cms_halt_cpu <- mkReg(False);
   // mkConnection(soc_top.cms_halt_cpu, cms_halt_cpu);

   // rule rl_every_cycle;
   //    cms_halt_cpu <= get_cms_halt_cpu();
   // endrule

   // Connect SoC to raw memory
   let memCnx <- mkConnection (soc_top.to_raw_mem, mem_model.mem_server);

   // ================================================================
   // BEHAVIOR

   Reg #(Bool) rg_banner_printed <- mkReg (False);

   // Clock clk <- exposeCurrentClock;
   Reg #(Bit#(64)) rg_cycle <- mkReg (0);
   // Reset rst_n <- exposeCurrentReset;

   Reg #(Bit#(1)) cms_halt_cpu <- mkReg(1);


   // Reg #(ContinuousMonitoring_IFC) cms_ifc <- mkRegU;
   // rule rl_update_cms_ifc;
   //    cms_ifc <= soc_top.cms_ifc;
   // endrule

   //  (* always_ready, always_enabled *) method WordXL pc;
   //  (* always_ready, always_enabled *) method Instr instr; 
   //  (* always_ready, always_enabled *) method Bit#(No_Of_Selected_Evts) performance_events;
   //  (* always_ready *) method Action halt_cpu(Bit#(1) state);
   //  (* always_ready, always_enabled *) method RegName gp_write_reg_name; // register index/address in GPR file
   //  (* always_ready, always_enabled *) method Capability gp_write_reg; 
   //  (* always_ready, always_enabled *) method Bool gp_write_valid;       // True if GPR is currently overwritten
   //  (* always_ready, always_enabled *) method WordXL mstatus;
   //  (* always_ready, always_enabled *) method Bit#(2) mstatus_mpp;
   //  (* always_ready, always_enabled *) method Bit#(1) mstatus_spp;
   //  (* always_ready, always_enabled *) method Priv_Mode privilege_mode;

   Reg#(WordXL) rg_cms_pc <- mkRegU;
   Reg#(Instr) rg_cms_instr <- mkRegU;
   Reg#(RegName) rg_cms_gp_write_reg_name <- mkRegU;
   Reg#(Capability) rg_cms_gp_write_reg <- mkRegU;
   Reg#(Bool) rg_cms_gp_write_valid <- mkRegU;

   rule rl_cms_ifc;
      rg_cms_pc <= soc_top.cms_ifc.pc;
      rg_cms_instr <= soc_top.cms_ifc.instr;
      rg_cms_gp_write_reg_name <= soc_top.cms_ifc.gp_write_reg_name;
      rg_cms_gp_write_reg <= soc_top.cms_ifc.gp_write_reg;
      rg_cms_gp_write_valid <= soc_top.cms_ifc.gp_write_valid;
   endrule

   rule rl_count_cycle;
      rg_cycle <= rg_cycle + 1;
      for (Bit#(64) i = 538; i < 4000; i = i + 5) begin
            if (rg_cycle == i) begin
// The following part of the code is going to be automatically replaced
// by the python script (check_halting_integrity.py) in Flute/builds/RV64ACDFIMSUxCHERI_Flute_bluesim_debug
// This is to check if the halting affects the integrity of the simulation (to see if program counters 
// are corresponding to the same GPR writes and don't get desynchronized)
// EDITABLE PART BEGIN
//soc_top.cms_ifc.halt_cpu(cms_halt_cpu);
// EDITABLE PART END
               cms_halt_cpu <= ~cms_halt_cpu;               
            end
      end
   endrule 

   // rule rl_test_no_idea_what_im_doing;
   //    soc_top.master1.ar.arready(True);
   //    soc_top.master1.aw.awready(True);
   //    Bit#(Wd_MId_ext) mid = 0;
   //    AXI4_Resp resp = OKAY;
   //    Bit#(Wd_B_User_ext) respt = 0;
   //    soc_top.master1.b.bflit(True, mid, resp, respt);
   //    Bit#(Wd_Data) data = 0;
   //    Bit#(Wd_R_User_ext) user = 0;
   //    soc_top.master1.r.rflit(True, mid, data, resp, True, user);
   //    soc_top.master1.w.wready(True);

   //    // soc_top.other_peripherals_sig.ar.arflit(True, valueOf(Wd_SId),0,0,0,0,0,0,0,0,0,0);
   //    // soc_top.other_peripherals_sig.aw.awready(True);
   //    // soc_top.other_peripherals_sig.b.bflit(True, mid, resp, respt);
   //    // soc_top.other_peripherals_sig.r.rflit(True, mid, data, resp, True, user);
   //    // soc_top.other_peripherals_sig.w.wflit(True, mid, resp, respt);
   // endrule

   // AXI4_Slave_Sig #( Wd_MId_ext, Wd_Addr, Wd_Data, Wd_AW_User_ext, Wd_W_User_ext, Wd_B_User_ext, Wd_AR_User_ext, Wd_R_User_ext) test_cul_de_sac = culDeSac;
   // AXI4_Slave_Sig #( Wd_MId_ext, Wd_Addr, Wd_Data, Wd_AW_User_ext, Wd_W_User_ext, Wd_B_User_ext, Wd_AR_User_ext, Wd_R_User_ext) test_cul_de_sac2 = culDeSac;
   AXI4_Slave_Sig #(6, Wd_Addr, Wd_Data_Periph, 0, 0, 0, 0, 0) test_cul_de_sac = culDeSac;
   AXI4_Slave_Sig #(7, Wd_Addr, Wd_Data_Periph, 0, 0, 0, 0, 0) test_cul_de_sac2 = culDeSac;

   // AXI4_Master_Sig #(7, Wd_Addr, Wd_Data, Wd_AW_User_ext, Wd_W_User_ext, Wd_B_User_ext, Wd_AR_User_ext, Wd_R_User_ext) core_dmem_post_fabric;
   mkConnection(soc_top.core_dmem_pre_fabric, test_cul_de_sac);
   mkConnection(soc_top.core_dmem_post_fabric, test_cul_de_sac2);

   Reg #(Bit #(32)) rg_cycle_num <- mkReg(0);


   // let something <- culDeSac;
   // mkConnection (something, soc_top.other_peripherals_sig);

   // Display a banner
   rule rl_step0 (! rg_banner_printed);
`ifndef RVFI_DII
      $display ("================================================================");
      $display ("Bluespec RISC-V WindSoC simulation v1.2");
      $display ("Copyright (c) 2017-2020 Bluespec, Inc. All Rights Reserved.");
      $display ("================================================================");
`endif

      rg_banner_printed <= True;

      // Set DDR4 'ready'
      soc_top.ma_ddr4_ready;

      // Set CPU verbosity and logdelay (simulation only)
      Bool v1 <- $test$plusargs ("v1");
      Bool v2 <- $test$plusargs ("v2");
      // Bit #(4)  verbosity = ((v2 ? 2 : (v1 ? 1 : 0)));
      Bit #(4)  verbosity = 2;
      Bit #(64) logdelay  = 0;    // # of instructions after which to set verbosity
      soc_top.set_verbosity  (verbosity, logdelay);

`ifdef WATCH_TOHOST
      // ----------------
      // Load tohost addr from symbol-table file
      Bool watch_tohost <- $test$plusargs ("tohost");
      let tha <- c_get_symbol_val ("tohost");
      Fabric_Addr tohost_addr = truncate (tha);
      $display ("INFO: watch_tohost = %0d, tohost_addr = 0x%0h",
		pack (watch_tohost), tohost_addr);
      soc_top.set_watch_tohost (watch_tohost, tohost_addr);
`endif

      // ----------------
      // Start timing the simulation
      Bit #(32) cycle_num <- cur_cycle;
      c_start_timing (zeroExtend (cycle_num));

      // ----------------
      // Open file for Tandem Verification trace output
`ifdef INCLUDE_TANDEM_VERIF
      let success <- c_trace_file_open ('h_AA);
      if (success == 0) begin
	 $display ("ERROR: Top_HW_Side.rl_step0: error opening trace file.");
	 $display ("    Aborting.");
	 $finish (1);
      end
      else
	 $display ("Top_HW_Side.rl_step0: opened trace file.");
`endif

      // ----------------
      // Open connection to remote debug client
`ifdef INCLUDE_GDB_CONTROL
      let dmi_status <- c_debug_client_connect (dmi_default_tcp_port);
      if (dmi_status != dmi_status_ok) begin
	 $display ("ERROR: Top_HW_Side.rl_step0: error opening debug client connection.");
	 $display ("    Aborting.");
	 $finish (1);
      end
`endif

   endrule: rl_step0

   // ================================================================
   // Terminate on any non-zero status

   rule rl_terminate (soc_top.mv_status != 0);
      $display ("%0d: %m:.rl_terminate: soc_top status is 0x%0h (= 0d%0d)",
		cur_cycle, soc_top.mv_status, soc_top.mv_status);

      // End timing the simulation
      Bit #(32) cycle_num <- cur_cycle;
      c_end_timing (zeroExtend (cycle_num));
      $finish (0);
   endrule

   // Terminate on ISA test writing non-zero to <tohost_addr>

`ifdef WATCH_TOHOST
   rule rl_terminate_tohost (soc_top.mv_tohost_value != 0);
      let tohost_value = soc_top.mv_tohost_value;

      $display ("****************************************************************");
      $display ("%0d: %m:.rl_terminate_tohost: tohost_value is 0x%0h (= 0d%0d)",
		cur_cycle, tohost_value, tohost_value);
      let test_num = (tohost_value >> 1);
      if (test_num == 0) $display ("    PASS");
      else               $display ("    FAIL <test_%0d>", test_num);

      // End timing the simulation
      Bit #(32) cycle_num <- cur_cycle;
      c_end_timing (zeroExtend (cycle_num));
      $finish (0);
   endrule
`endif

   // ================================================================
   // Tandem verifier: drain and output vectors of bytes

`ifdef INCLUDE_TANDEM_VERIF
   rule rl_tv_vb_out;
      let tv_info <- soc_top.tv_verifier_info_get.get;
      let n  = tv_info.num_bytes;
      let vb = tv_info.vec_bytes;

      Bit #(32) success = 1;

      for (Bit #(32) j = 0; j < fromInteger (valueOf (TV_VB_SIZE)); j = j + 8) begin
	 Bit #(64) w64 = { vb [j+7], vb [j+6], vb [j+5], vb [j+4], vb [j+3], vb [j+2], vb [j+1], vb [j] };
	 let success1 <- c_trace_file_load_word64_in_buffer (j, w64);
      end

      if (success == 0)
	 $display ("ERROR: Top_HW_Side.rl_tv_vb_out: error loading %0d bytes into buffer", n);
      else begin
	 // Send the data
	 success <- c_trace_file_write_buffer (n);
	 if (success == 0)
	    $display ("ERROR: Top_HW_Side.rl_tv_vb_out: error writing out bytevec data buffer (%0d bytes)", n);
      end

      if (success == 0) begin
	 $finish (1);
      end
   endrule
`endif

   // ================================================================
   // UART console I/O

   // Relay system console output to terminal

   rule rl_relay_console_out;
      let ch <- soc_top.get_to_console.get;
      $write ("%c", ch);
      $fflush (stdout);
   endrule

   // Poll terminal input and relay any chars into system console input.
   // Note: rg_console_in_poll is used to poll only every N cycles, whenever it wraps around to 0.

   Reg #(Bit #(12)) rg_console_in_poll <- mkReg (0);

   rule rl_relay_console_in;
      if (rg_console_in_poll == 0) begin
	 Bit #(8) ch <- c_trygetchar (?);
	 if (ch != 0) begin
	    soc_top.put_from_console.put (ch);
	    /*
	    $write ("%0d: Top_HW_Side.bsv.rl_relay_console: ch = 0x%0h", cur_cycle, ch);
	    if (ch >= 'h20) $write (" ('%c')", ch);
	    $display ("");
	    */
	 end
      end
      rg_console_in_poll <= rg_console_in_poll + 1;
   endrule

   // ================================================================
   // Interaction with remote debug client

`ifdef INCLUDE_GDB_CONTROL
   rule rl_debug_client_request_recv;
      Bit #(64) req <- c_debug_client_request_recv ('hAA);
      Bit #(8)  status = req [63:56];
      Bit #(32) data   = req [55:24];
      Bit #(16) addr   = req [23:8];
      Bit #(8)  op     = req [7:0];
      if (status == dmi_status_err) begin
	 $display ("%0d: Top_HW_Side.rl_debug_client_request_recv: receive error; aborting",
		   cur_cycle);
	 $finish (1);
      end
      else if (status == dmi_status_ok) begin
	 // $write ("%0d: Top_HW_Side.rl_debug_client_request_recv:", cur_cycle);
	 if (op == dmi_op_read) begin
	    // $display (" READ 0x%0h", addr);
	    let control_req = Control_Req {op: external_control_req_op_read_control_fabric,
					   arg1: zeroExtend (addr),
					   arg2: 0};
	    soc_top.server_external_control.request.put (control_req);
	 end
	 else if (op == dmi_op_write) begin
	    // $display (" WRITE 0x%0h 0x%0h", addr, data);
	    let control_req = Control_Req {op: external_control_req_op_write_control_fabric,
					   arg1: zeroExtend (addr),
					   arg2: zeroExtend (data)};
	    soc_top.server_external_control.request.put (control_req);
	 end
	 else if (op == dmi_op_shutdown) begin
	    $display ("Top_HW_Side.rl_debug_client_request_recv: SHUTDOWN");

	    // End timing the simulation and print simulation speed stats
	    Bit #(32) cycle_num <- cur_cycle;
	    c_end_timing (zeroExtend (cycle_num));
	    $finish (0);
	 end
	 else if (op == dmi_op_start_command) begin    // For debugging only
	    // $display (" START COMMAND ================================");
	 end
	 else
	    $display (" Top_HW_Side.rl_debug_client_request_recv: UNRECOGNIZED OP %0d; ignoring", op);
      end
   endrule

   rule rl_debug_client_response_send;
      let control_rsp <- soc_top.server_external_control.response.get;
      // $display ("Top_HW_Side.rl_debug_client_response_send: 0x%0h", control_rsp.result);
      let status <- c_debug_client_response_send (truncate (control_rsp.result));
      if (status == dmi_status_err) begin
	 $display ("%0d: Top_HW_Side.rl_debug_client_response_send: send error; aborting",
		   cur_cycle);
	 $finish (1);
      end
   endrule
`endif

   // ================================================================
   // INTERFACE

   //  None (this is top-level)

   //  Except RVFI_DII interface if enabled
`ifdef RVFI_DII
    return soc_top.rvfi_dii_server;
`endif

endmodule

// ================================================================

`ifdef RVFI_DII
// ================================================================
// mkFlute_RVFI_DII instantiates the toplevel with the RVFI_DII
// interfaces enabled, allowing testing with directly
// ================================================================

(* synthesize *)
module mkTop_HW_Side(Empty)
    provisos (Add#(a__, TDiv#(XLEN,8), 8), Add#(b__, XLEN, 64), Add#(c__, TDiv#(XLEN,8), 8), Add#(d__, XLEN, 64));

    Reg #(Bool) rg_banner_printed <- mkReg (False);

    // Display a banner
    rule rl_step0 (! rg_banner_printed);
       $display ("================================================================");
       $display ("Bluespec RISC-V standalone system simulation v1.2");
       $display ("Copyright (c) 2017-2018 Bluespec, Inc. All Rights Reserved.");
       $display ("================================================================");

       rg_banner_printed <= True;
    endrule

    RVFI_DII_Bridge_Scalar #(XLEN, MEMWIDTH) bridge <- mkRVFI_DII_Bridge_Scalar("RVFI_DII", 5001);
    let    dut <- mkPre_Top_HW_Side(reset_by bridge.new_rst);
    mkConnection(bridge.client.report, dut.trace_report);

    rule rl_provide_instr;
        Dii_Id req <- dut.seqReq.get;
        Maybe#(Dii_Inst) inst <- bridge.client.getInst(req);
        dut.inst.put(tuple2(inst.Valid, req));
    endrule
endmodule
`endif

// ================================================================

endpackage: Top_HW_Side
