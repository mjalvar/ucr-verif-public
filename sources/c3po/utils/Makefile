# makefile
# project: counter
# melvin.alvarado

SRC_VERIF = tb.v
SRC_RTL = c3po_regs.v c3po.v
TB_TOP = tb
#DEFINE = ASSERT_ON COVERAGE_ON

SRC_RTL_EXTRA = -i $(CODE)/control/rtl -i $(CODE)/regs/rtl -i $(CODE)/unpacker/rtl -i $(CODE)/counter/rtl $(COMMON)/rtl/common.vh

include $(CODE)/makefiles/vivado.mk