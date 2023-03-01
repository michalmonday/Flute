// Copyright (c) 2016-2020 Bluespec, Inc. All Rights Reserved

//-
// RVFI_DII + CHERI modifications:
//     Copyright (c) 2018 Jack Deeley (RVFI_DII)
//     Copyright (c) 2018 Peter Rugg (RVFI_DII + CHERI)
//     All rights reserved.
//
//     This software was developed by SRI International and the University of
//     Cambridge Computer Laboratory (Department of Computer Science and
//     Technology) under DARPA contract HR0011-18-C-0016 ("ECATS"), as part of the
//     DARPA SSITH research programme.
//-

package GPR_RegFile;

// ================================================================
// GPR (General Purpose Register) Register File

// ================================================================
// Exports

export GPR_RegFile_IFC (..), mkGPR_RegFile;

// ================================================================
// BSV library imports

import ConfigReg    :: *;
import RegFile      :: *;
import FIFOF        :: *;
import GetPut       :: *;
import ClientServer :: *;

// BSV additional libs

import GetPut_Aux :: *;

// ================================================================
// Project imports

import ISA_Decls :: *;
`ifdef ISA_CHERI
import CHERICap :: *;
import CHERICC_Fat :: *;
`endif

// ================================================================

`ifdef ISA_CHERI
`define INTERNAL_REG_TYPE CapReg
`define EXTERNAL_REG_TYPE_OUT CapPipe
`define EXTERNAL_REG_TYPE_IN CapReg
`define ZERO_REG_CONTENTS nullCap
`ifdef RVFI_DII
`define INITIAL_CONTENTS almightyCap
`else
`define INITIAL_CONTENTS nullCap
`endif
`else
`define INTERNAL_REG_TYPE Word
`define EXTERNAL_REG_TYPE_OUT Word
`define EXTERNAL_REG_TYPE_IN Word
`define ZERO_REG_CONTENTS 0
`ifdef RVFI
`define INITIAL_CONTENTS 0
`endif
`ifdef INCLUDE_TANDEM_VERIF
`define INITIAL_CONTENTS 0
`endif
`endif

`ifdef ISA_CHERI
`define CAST cast
`else
function id x = x;
`define CAST id
`endif


interface GPR_RegFile_IFC;
   // Reset
   interface Server #(Token, Token) server_reset;

   // GPR read
   (* always_ready *)
   method `EXTERNAL_REG_TYPE_OUT read_rs1 (RegName rs1);
   (* always_ready *)
   method `EXTERNAL_REG_TYPE_OUT read_rs1_port2 (RegName rs1);    // For debugger access only
   (* always_ready *)
   method `EXTERNAL_REG_TYPE_OUT read_rs2 (RegName rs2);

   (* always_ready *)
   method `EXTERNAL_REG_TYPE_OUT read_cms (RegName rs);
   (* always_ready *)
   method `EXTERNAL_REG_TYPE_OUT read_cms2 (RegName rs);
   (* always_ready *)
   method `EXTERNAL_REG_TYPE_OUT read_cms3 (RegName rs);
   (* always_ready *)
   method `EXTERNAL_REG_TYPE_OUT read_cms4 (RegName rs);


   (* always_ready *)
   method RegName written_reg_name;
   (* always_ready *)
   method `EXTERNAL_REG_TYPE_IN written_reg_value;
   (* always_ready *)
   method Bool written_reg_valid;

   // GPR write
   (* always_ready *)
   method Action write_rd (RegName rd, `EXTERNAL_REG_TYPE_IN rd_val
`ifdef ISA_CHERI_MERGED
       , Bool is_cap_not_int   // Specifies whether the register is written back
                               // by a capability or integer operation. This is
                               // distinct from the tag of the capability.
`endif
       );

endinterface

// ================================================================
// Major states of mkGPR_RegFile module

typedef enum { RF_RESET_START, RF_RESETTING, RF_RUNNING } RF_State
deriving (Eq, Bits, FShow);

// ================================================================

(* synthesize *)
module mkGPR_RegFile (GPR_RegFile_IFC);

   Reg #(RF_State) rg_state      <- mkReg (RF_RESET_START);

   // Reset
   FIFOF #(Token) f_reset_rsps <- mkFIFOF;

   // General Purpose Registers
   // TODO: can we use Reg [0] for some other purpose?
   RegFile #(RegName, `INTERNAL_REG_TYPE) regfile <- mkRegFileFull;

   // Reg#(RegName) rg_current_write_reg <- mkRegU;
   Reg#(RegName) rg_written_reg_name <- mkRegU;
   Reg#(`EXTERNAL_REG_TYPE_IN) rg_written_reg_value <- mkRegU;
   Reg#(Bool) rg_written_reg_valid[3] <- mkCReg(3, False);

   // ----------------------------------------------------------------
   // Reset.
   // This loop initializes all GPRs to 0.
   // The spec does not require this, but it's useful for debugging
   // and tandem verification
   // Required for CHERI

`ifdef INITIAL_CONTENTS
   Reg #(RegName) rg_j <- mkRegU;    // reset loop index
`endif

   rule rl_reset_start (rg_state == RF_RESET_START);
      rg_state <= RF_RESETTING;
`ifdef INITIAL_CONTENTS
      rg_j <= 1;
`endif
   endrule

   rule rl_reset_loop (rg_state == RF_RESETTING);
`ifdef INITIAL_CONTENTS
      regfile.upd (rg_j, `INITIAL_CONTENTS);

      // This will take priority over another rule that
      // overwrites the rg_written_reg_valid CReg (concurrent register) with "False"
      // on every clock cycle.
      rg_written_reg_name <= rg_j;
      rg_written_reg_value <= `INITIAL_CONTENTS;
      rg_written_reg_valid[2] <= True;

      rg_j <= rg_j + 1;
      if (rg_j == 31)
	 rg_state <= RF_RUNNING;
`else
      rg_state <= RF_RUNNING;
`endif
   endrule


   rule rl_reset_write_reg_valid;
      // This write only takes effect if the gp register file 
      // is not currently written to (when write_rd method is not called).
      // This happens thanks to the magic of CReg (concurrent register) which
      // allows 2 rules to write to the same register on the same clock cycle.
      // The value of register on the following clock cycle is determined by 
      // the write value to the highest index of CReg.
      // It is noteworthy that if for example we write to index [1], then the index [>1] will
      // immediately contain the value written to index [1].
      // If at the same clock cycle we wrote to index[3] as well, then the value written at index [1] 
      // won't overwrite the value written at index [3] or higher, it will only overwrite value at index[2].
      rg_written_reg_valid[0] <= False;
   endrule 


   // ----------------------------------------------------------------
   // INTERFACE

   // Reset
   interface Server server_reset;
      interface Put request;
	 method Action put (Token token);
	    rg_state <= RF_RESET_START;

	    // This response is placed here, and not in rl_reset_loop, because
	    // reset_loop can happen on power-up, where no response is expected.
	    f_reset_rsps.enq (?);
	 endmethod
      endinterface
      interface Get response;
	 method ActionValue #(Token) get if (rg_state == RF_RUNNING);
	    let token <- pop (f_reset_rsps);
	    return token;
	 endmethod
      endinterface
   endinterface

   // GPR read
   method `EXTERNAL_REG_TYPE_OUT read_rs1 (RegName rs1);
      return `CAST ((rs1 == 0) ? `ZERO_REG_CONTENTS : regfile.sub (rs1));
   endmethod

   // GPR read
   method `EXTERNAL_REG_TYPE_OUT read_rs1_port2 (RegName rs1);        // For debugger access only
      return `CAST ((rs1 == 0) ? `ZERO_REG_CONTENTS : regfile.sub (rs1));
   endmethod

   method `EXTERNAL_REG_TYPE_OUT read_cms (RegName rs1);        // For continuous monitoring system
      return `CAST ((rs1 == 0) ? `ZERO_REG_CONTENTS : regfile.sub (rs1));
   endmethod

   method `EXTERNAL_REG_TYPE_OUT read_cms2 (RegName rs1);        // For continuous monitoring system
      return `CAST ((rs1 == 0) ? `ZERO_REG_CONTENTS : regfile.sub (rs1));
   endmethod

   method `EXTERNAL_REG_TYPE_OUT read_cms3 (RegName rs1);        // For continuous monitoring system
      return `CAST ((rs1 == 0) ? `ZERO_REG_CONTENTS : regfile.sub (rs1));
   endmethod

   method `EXTERNAL_REG_TYPE_OUT read_cms4 (RegName rs1);        // For continuous monitoring system
      return `CAST ((rs1 == 0) ? `ZERO_REG_CONTENTS : regfile.sub (rs1));
   endmethod

   method `EXTERNAL_REG_TYPE_OUT read_rs2 (RegName rs2);
      return `CAST ((rs2 == 0) ? `ZERO_REG_CONTENTS : regfile.sub (rs2));
   endmethod

   // GPR write
   method Action write_rd (RegName rd, `EXTERNAL_REG_TYPE_IN rd_val);
     if (rd != 0) begin
         regfile.upd (rd, `CAST (rd_val));
         // This will take priority over another rule that
         // overwrites the rg_written_reg_valid CReg (concurrent register) with "False"
         // on every clock cycle.
         rg_written_reg_name <= rd;
         rg_written_reg_value <= rd_val;
         rg_written_reg_valid[1] <= True;
         $display("write_rd: rd = %d, rd_val = %d", rd, rd_val);
     end 
   endmethod

   method RegName written_reg_name;
      return rg_written_reg_name;
   endmethod 

   method `EXTERNAL_REG_TYPE_IN written_reg_value;
      return rg_written_reg_value;
   endmethod 

   method Bool written_reg_valid;
      return rg_written_reg_valid[0];
   endmethod 


endmodule

// ================================================================

endpackage
