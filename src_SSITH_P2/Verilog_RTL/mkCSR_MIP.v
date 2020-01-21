//
// Generated by Bluespec Compiler, version 2019.05.beta2 (build a88bf40db, 2019-05-24)
//
//
//
//
// Ports:
// Name                         I/O  size props
// fv_read                        O    64
// fav_write                      O    64
// fv_sip_read                    O    64
// fav_sip_write                  O    64
// CLK                            I     1 clock
// RST_N                          I     1 reset
// fav_write_misa                 I    28
// fav_write_wordxl               I    64
// fav_sip_write_misa             I    28
// fav_sip_write_wordxl           I    64
// m_external_interrupt_req_req   I     1 reg
// s_external_interrupt_req_req   I     1 reg
// software_interrupt_req_req     I     1 reg
// timer_interrupt_req_req        I     1 reg
// EN_reset                       I     1
// EN_fav_write                   I     1
// EN_fav_sip_write               I     1
//
// Combinational paths from inputs to outputs:
//   (fav_write_misa, fav_write_wordxl) -> fav_write
//   (fav_sip_write_misa, fav_sip_write_wordxl) -> fav_sip_write
//
//

`ifdef BSV_ASSIGNMENT_DELAY
`else
  `define BSV_ASSIGNMENT_DELAY
`endif

`ifdef BSV_POSITIVE_RESET
  `define BSV_RESET_VALUE 1'b1
  `define BSV_RESET_EDGE posedge
`else
  `define BSV_RESET_VALUE 1'b0
  `define BSV_RESET_EDGE negedge
`endif

module mkCSR_MIP(CLK,
		 RST_N,

		 EN_reset,

		 fv_read,

		 fav_write_misa,
		 fav_write_wordxl,
		 EN_fav_write,
		 fav_write,

		 fv_sip_read,

		 fav_sip_write_misa,
		 fav_sip_write_wordxl,
		 EN_fav_sip_write,
		 fav_sip_write,

		 m_external_interrupt_req_req,

		 s_external_interrupt_req_req,

		 software_interrupt_req_req,

		 timer_interrupt_req_req);
  input  CLK;
  input  RST_N;

  // action method reset
  input  EN_reset;

  // value method fv_read
  output [63 : 0] fv_read;

  // actionvalue method fav_write
  input  [27 : 0] fav_write_misa;
  input  [63 : 0] fav_write_wordxl;
  input  EN_fav_write;
  output [63 : 0] fav_write;

  // value method fv_sip_read
  output [63 : 0] fv_sip_read;

  // actionvalue method fav_sip_write
  input  [27 : 0] fav_sip_write_misa;
  input  [63 : 0] fav_sip_write_wordxl;
  input  EN_fav_sip_write;
  output [63 : 0] fav_sip_write;

  // action method m_external_interrupt_req
  input  m_external_interrupt_req_req;

  // action method s_external_interrupt_req
  input  s_external_interrupt_req_req;

  // action method software_interrupt_req
  input  software_interrupt_req_req;

  // action method timer_interrupt_req
  input  timer_interrupt_req_req;

  // signals for module outputs
  wire [63 : 0] fav_sip_write, fav_write, fv_read, fv_sip_read;

  // register rg_meip
  reg rg_meip;
  wire rg_meip$D_IN, rg_meip$EN;

  // register rg_msip
  reg rg_msip;
  wire rg_msip$D_IN, rg_msip$EN;

  // register rg_mtip
  reg rg_mtip;
  wire rg_mtip$D_IN, rg_mtip$EN;

  // register rg_seip
  reg rg_seip;
  wire rg_seip$D_IN, rg_seip$EN;

  // register rg_ssip
  reg rg_ssip;
  reg rg_ssip$D_IN;
  wire rg_ssip$EN;

  // register rg_stip
  reg rg_stip;
  wire rg_stip$D_IN, rg_stip$EN;

  // register rg_ueip
  reg rg_ueip;
  reg rg_ueip$D_IN;
  wire rg_ueip$EN;

  // register rg_usip
  reg rg_usip;
  reg rg_usip$D_IN;
  wire rg_usip$EN;

  // register rg_utip
  reg rg_utip;
  wire rg_utip$D_IN, rg_utip$EN;

  // rule scheduling signals
  wire CAN_FIRE_fav_sip_write,
       CAN_FIRE_fav_write,
       CAN_FIRE_m_external_interrupt_req,
       CAN_FIRE_reset,
       CAN_FIRE_s_external_interrupt_req,
       CAN_FIRE_software_interrupt_req,
       CAN_FIRE_timer_interrupt_req,
       WILL_FIRE_fav_sip_write,
       WILL_FIRE_fav_write,
       WILL_FIRE_m_external_interrupt_req,
       WILL_FIRE_reset,
       WILL_FIRE_s_external_interrupt_req,
       WILL_FIRE_software_interrupt_req,
       WILL_FIRE_timer_interrupt_req;

  // remaining internal signals
  wire [11 : 0] new_mip__h526, new_mip__h944;
  wire seip__h560,
       ssip__h564,
       ssip__h984,
       stip__h562,
       ueip__h561,
       ueip__h983,
       usip__h565,
       usip__h985,
       utip__h563;

  // action method reset
  assign CAN_FIRE_reset = 1'd1 ;
  assign WILL_FIRE_reset = EN_reset ;

  // value method fv_read
  assign fv_read = { 52'd0, new_mip__h526 } ;

  // actionvalue method fav_write
  assign fav_write = { 52'd0, new_mip__h944 } ;
  assign CAN_FIRE_fav_write = 1'd1 ;
  assign WILL_FIRE_fav_write = EN_fav_write ;

  // value method fv_sip_read
  assign fv_sip_read =
	     { 54'd0,
	       rg_seip,
	       rg_ueip,
	       2'b0,
	       rg_stip,
	       rg_utip,
	       2'b0,
	       rg_ssip,
	       rg_usip } ;

  // actionvalue method fav_sip_write
  assign fav_sip_write =
	     { 54'd0,
	       rg_seip,
	       ueip__h983,
	       2'b0,
	       rg_stip,
	       rg_utip,
	       2'b0,
	       ssip__h984,
	       usip__h985 } ;
  assign CAN_FIRE_fav_sip_write = 1'd1 ;
  assign WILL_FIRE_fav_sip_write = EN_fav_sip_write ;

  // action method m_external_interrupt_req
  assign CAN_FIRE_m_external_interrupt_req = 1'd1 ;
  assign WILL_FIRE_m_external_interrupt_req = 1'd1 ;

  // action method s_external_interrupt_req
  assign CAN_FIRE_s_external_interrupt_req = 1'd1 ;
  assign WILL_FIRE_s_external_interrupt_req = 1'd1 ;

  // action method software_interrupt_req
  assign CAN_FIRE_software_interrupt_req = 1'd1 ;
  assign WILL_FIRE_software_interrupt_req = 1'd1 ;

  // action method timer_interrupt_req
  assign CAN_FIRE_timer_interrupt_req = 1'd1 ;
  assign WILL_FIRE_timer_interrupt_req = 1'd1 ;

  // register rg_meip
  assign rg_meip$D_IN = m_external_interrupt_req_req ;
  assign rg_meip$EN = 1'b1 ;

  // register rg_msip
  assign rg_msip$D_IN = software_interrupt_req_req ;
  assign rg_msip$EN = 1'b1 ;

  // register rg_mtip
  assign rg_mtip$D_IN = timer_interrupt_req_req ;
  assign rg_mtip$EN = 1'b1 ;

  // register rg_seip
  assign rg_seip$D_IN = s_external_interrupt_req_req ;
  assign rg_seip$EN = 1'b1 ;

  // register rg_ssip
  always@(EN_reset or
	  EN_fav_write or ssip__h564 or EN_fav_sip_write or ssip__h984)
  case (1'b1)
    EN_reset: rg_ssip$D_IN = 1'd0;
    EN_fav_write: rg_ssip$D_IN = ssip__h564;
    EN_fav_sip_write: rg_ssip$D_IN = ssip__h984;
    default: rg_ssip$D_IN = 1'b0 /* unspecified value */ ;
  endcase
  assign rg_ssip$EN = EN_fav_write || EN_fav_sip_write || EN_reset ;

  // register rg_stip
  assign rg_stip$D_IN = !EN_reset && stip__h562 ;
  assign rg_stip$EN = EN_fav_write || EN_reset ;

  // register rg_ueip
  always@(EN_reset or
	  EN_fav_write or ueip__h561 or EN_fav_sip_write or ueip__h983)
  case (1'b1)
    EN_reset: rg_ueip$D_IN = 1'd0;
    EN_fav_write: rg_ueip$D_IN = ueip__h561;
    EN_fav_sip_write: rg_ueip$D_IN = ueip__h983;
    default: rg_ueip$D_IN = 1'b0 /* unspecified value */ ;
  endcase
  assign rg_ueip$EN = EN_fav_write || EN_fav_sip_write || EN_reset ;

  // register rg_usip
  always@(EN_reset or
	  EN_fav_write or usip__h565 or EN_fav_sip_write or usip__h985)
  case (1'b1)
    EN_reset: rg_usip$D_IN = 1'd0;
    EN_fav_write: rg_usip$D_IN = usip__h565;
    EN_fav_sip_write: rg_usip$D_IN = usip__h985;
    default: rg_usip$D_IN = 1'b0 /* unspecified value */ ;
  endcase
  assign rg_usip$EN = EN_fav_write || EN_fav_sip_write || EN_reset ;

  // register rg_utip
  assign rg_utip$D_IN = !EN_reset && utip__h563 ;
  assign rg_utip$EN = EN_fav_write || EN_reset ;

  // remaining internal signals
  assign new_mip__h526 =
	     { rg_meip,
	       1'b0,
	       rg_seip,
	       rg_ueip,
	       rg_mtip,
	       1'b0,
	       rg_stip,
	       rg_utip,
	       rg_msip,
	       1'b0,
	       rg_ssip,
	       rg_usip } ;
  assign new_mip__h944 =
	     { rg_meip,
	       1'b0,
	       seip__h560,
	       ueip__h561,
	       rg_mtip,
	       1'b0,
	       stip__h562,
	       utip__h563,
	       rg_msip,
	       1'b0,
	       ssip__h564,
	       usip__h565 } ;
  assign seip__h560 = fav_write_misa[18] && fav_write_wordxl[9] ;
  assign ssip__h564 = fav_write_misa[18] && fav_write_wordxl[1] ;
  assign ssip__h984 = fav_sip_write_misa[18] && fav_sip_write_wordxl[1] ;
  assign stip__h562 = fav_write_misa[18] && fav_write_wordxl[5] ;
  assign ueip__h561 = fav_write_misa[13] && fav_write_wordxl[8] ;
  assign ueip__h983 = fav_sip_write_misa[13] && fav_sip_write_wordxl[8] ;
  assign usip__h565 = fav_write_misa[13] && fav_write_wordxl[0] ;
  assign usip__h985 = fav_sip_write_misa[13] && fav_sip_write_wordxl[0] ;
  assign utip__h563 = fav_write_misa[13] && fav_write_wordxl[4] ;

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (RST_N == `BSV_RESET_VALUE)
      begin
        rg_meip <= `BSV_ASSIGNMENT_DELAY 1'd0;
	rg_msip <= `BSV_ASSIGNMENT_DELAY 1'd0;
	rg_mtip <= `BSV_ASSIGNMENT_DELAY 1'd0;
	rg_seip <= `BSV_ASSIGNMENT_DELAY 1'd0;
	rg_ssip <= `BSV_ASSIGNMENT_DELAY 1'd0;
	rg_stip <= `BSV_ASSIGNMENT_DELAY 1'd0;
	rg_ueip <= `BSV_ASSIGNMENT_DELAY 1'd0;
	rg_usip <= `BSV_ASSIGNMENT_DELAY 1'd0;
	rg_utip <= `BSV_ASSIGNMENT_DELAY 1'd0;
      end
    else
      begin
        if (rg_meip$EN) rg_meip <= `BSV_ASSIGNMENT_DELAY rg_meip$D_IN;
	if (rg_msip$EN) rg_msip <= `BSV_ASSIGNMENT_DELAY rg_msip$D_IN;
	if (rg_mtip$EN) rg_mtip <= `BSV_ASSIGNMENT_DELAY rg_mtip$D_IN;
	if (rg_seip$EN) rg_seip <= `BSV_ASSIGNMENT_DELAY rg_seip$D_IN;
	if (rg_ssip$EN) rg_ssip <= `BSV_ASSIGNMENT_DELAY rg_ssip$D_IN;
	if (rg_stip$EN) rg_stip <= `BSV_ASSIGNMENT_DELAY rg_stip$D_IN;
	if (rg_ueip$EN) rg_ueip <= `BSV_ASSIGNMENT_DELAY rg_ueip$D_IN;
	if (rg_usip$EN) rg_usip <= `BSV_ASSIGNMENT_DELAY rg_usip$D_IN;
	if (rg_utip$EN) rg_utip <= `BSV_ASSIGNMENT_DELAY rg_utip$D_IN;
      end
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    rg_meip = 1'h0;
    rg_msip = 1'h0;
    rg_mtip = 1'h0;
    rg_seip = 1'h0;
    rg_ssip = 1'h0;
    rg_stip = 1'h0;
    rg_ueip = 1'h0;
    rg_usip = 1'h0;
    rg_utip = 1'h0;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on
endmodule  // mkCSR_MIP

