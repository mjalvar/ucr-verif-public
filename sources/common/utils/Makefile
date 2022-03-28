# melvin.alvarado
# makefile to run all blocks in list

MY_PROJ ?= counter


export CODE = /home/developer/code
export PROJ = $(CODE)/$(MY_PROJ)

SOURCE = $(CODE)/env.sh
MAKE_PROJ = make -f $(CODE)/$(MY_PROJ)/utils/Makefile
MAKE = make -f $(CODE)/common/utils/Makefile


PROJ_LIST = counter arbiter regs uvm-tutorial mem-control control unpacker

targets = $(addsuffix .o, $(PROJ_LIST))



all: $(targets)

# $(targets): proj_%: rambo%.sh
#     sh $<
#	  @echo $@ $*

$(targets):
	$(MAKE) run MY_PROJ=$*
	@grep "Test:" ./*/test.status

run:
	@mkdir -p $(MY_PROJ)
	cd $(MY_PROJ) && $(MAKE_PROJ)