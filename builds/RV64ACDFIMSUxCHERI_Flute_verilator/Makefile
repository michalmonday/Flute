###  -*-Makefile-*-

# *** DO NOT EDIT! ***
# *** This file is program-generated, not hand-written. ***
# ================================================================

REPO ?= ../../
ARCH ?= RV64ACDFIMSUxCHERI


CAPSIZE = 128
TAGS_STRUCT = 0 64
TAGS_ALIGN = 32

# ================================================================
# RISC-V config macros passed into Bluespec 'bsc' compiler

BSC_COMPILATION_FLAGS += \
	-D RV64 \
	-D ISA_PRIV_M  -D ISA_PRIV_U  -D ISA_PRIV_S  \
	-D SV39  \
	-D RISCV\
	-D CapWidth=128 -D CAP128\
	-D PERFORMANCE_MONITORING\
	-D ISA_I  -D ISA_M  -D ISA_A  -D ISA_F  -D ISA_D  -D INCLUDE_FDIV  -D INCLUDE_FSQRT  -D ISA_C  -D ISA_CHERI  \
	-D SHIFT_BARREL    \
	-D MULT_SYNTH    \
	-D Near_Mem_Caches    \
	-D FABRIC64    \
	-D WATCH_TOHOST    \


# Default ISA test

#TEST ?= rv64ui-p-add
TEST ?= riscv-example-baremetal-short

#================================================================
# Common boilerplate rules

include $(REPO)/builds/Resources/Include_Common.mk

#================================================================
# Makefile rules for building for specific simulator: verilator

include $(REPO)/builds/Resources/Include_verilator.mk

