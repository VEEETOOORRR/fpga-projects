# ─────────────────────────────────────────────────────────────────────────────
# Tang Nano 9K — Makefile
# Toolchain: Yosys + NextPnR-Himbaechel + Apicula + openFPGALoader
# HDL: SystemVerilog (.sv) e Verilog (.v)
# ─────────────────────────────────────────────────────────────────────────────

# ── Configuração do projeto ───────────────────────────────────────────────────
TOP       ?= top
BUILD_DIR := build

SV_SRCS   := $(wildcard *.sv src/*.sv)
V_SRCS    := $(wildcard *.v  src/*.v)
ALL_SRCS  := $(SV_SRCS) $(V_SRCS)

CST       ?= $(TOP).cst

# ── Dispositivo (Tang Nano 9K) ────────────────────────────────────────────────
DEVICE        := GW1NR-LV9QN88PC6/I5
FAMILY        := GW1N-9C
BOARD         := tangnano9k
NEXTPNR_FREQ  ?= 27

# ── Arquivos gerados ──────────────────────────────────────────────────────────
NETLIST   := $(BUILD_DIR)/$(TOP).json
PNR_OUT   := $(BUILD_DIR)/$(TOP)_pnr.json
BITSTREAM := $(BUILD_DIR)/$(TOP).fs

# ─────────────────────────────────────────────────────────────────────────────
# Alvos principais
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: all flash flash-persistent clean clean-all help

all: $(BITSTREAM)

flash: $(BITSTREAM)
	openFPGALoader -b $(BOARD) $(BITSTREAM)

flash-persistent: $(BITSTREAM)
	openFPGALoader -b $(BOARD) -f $(BITSTREAM)

clean:
	rm -f $(NETLIST) $(PNR_OUT)

clean-all:
	rm -rf $(BUILD_DIR)

# ─────────────────────────────────────────────────────────────────────────────
# Regras de build
# ─────────────────────────────────────────────────────────────────────────────

$(BUILD_DIR):
	mkdir -p $@

# 1. Síntese — .sv/.v → netlist JSON
# -sv habilita o parser SystemVerilog no read_verilog
# flatten é o comportamento padrão do synth_gowin (use -noflatten para desativar)
$(NETLIST): $(ALL_SRCS) | $(BUILD_DIR)
	@echo "── Síntese: $(ALL_SRCS) → $@"
	yosys -p "read_verilog -sv $(ALL_SRCS); synth_gowin -top $(TOP) -json $@"

# 2. Place & Route — netlist → netlist roteado
$(PNR_OUT): $(NETLIST) $(CST)
	@echo "── Place & Route → $@"
	nextpnr-himbaechel \
		--json $(NETLIST) \
		--write $@ \
		--device $(DEVICE) \
		--vopt family=$(FAMILY) \
		--vopt cst=$(CST) \
		--freq $(NEXTPNR_FREQ)

# 3. Bitstream — netlist roteado → .fs
$(BITSTREAM): $(PNR_OUT)
	@echo "── Bitstream → $@"
	gowin_pack -d $(FAMILY) -o $@ $<
	@echo "── Pronto: $@"

# ─────────────────────────────────────────────────────────────────────────────
# Ajuda
# ─────────────────────────────────────────────────────────────────────────────

help:
	@echo ""
	@echo "  Uso: make [alvo] [VAR=valor]"
	@echo ""
	@echo "  Alvos:"
	@echo "    all               Sintetiza e gera o bitstream (padrão)"
	@echo "    flash             Grava na SRAM (temporário)"
	@echo "    flash-persistent  Grava na Flash (persiste após desligar)"
	@echo "    clean             Remove intermediários, mantém .fs"
	@echo "    clean-all         Remove tudo (pasta build/)"
	@echo "    help              Exibe esta mensagem"
	@echo ""
	@echo "  Variáveis:"
	@echo "    TOP=$(TOP)   BUILD_DIR=$(BUILD_DIR)"
	@echo "    CST=$(CST)   NEXTPNR_FREQ=$(NEXTPNR_FREQ) MHz"
	@echo ""
	@echo "  Exemplos:"
	@echo "    make TOP=blink"
	@echo "    make flash TOP=blink"
	@echo "    make flash-persistent NEXTPNR_FREQ=50"
	@echo ""
