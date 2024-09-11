roms := \
        pokegold_rtc.gbc

pokegold_rtc_baserom = pokegold.gbc

RGBDS ?=
RGBASM  ?= $(RGBDS)rgbasm
RGBFIX  ?= $(RGBDS)rgbfix
RGBGFX  ?= $(RGBDS)rgbgfx
RGBLINK ?= $(RGBDS)rgblink

# Create a sym/map for debug purposes if `make` run with `DEBUG=1`
ifeq ($(DEBUG),1)
RGBLINKFLAGS += -n roms/$*.sym -m roms/$*.map
endif
RGBLINKFLAGS += -O roms/$($*_baserom)
RGBFIXFLAGS = -p0 -v

.PHONY: all gold_rtc
.SECONDEXPANSION:

patches/%.bps: roms/%.gbc roms/$$(%_baserom)
	flips --create --bps roms/$($*_baserom) roms/$*.gbc $@

roms/%.gbc: src/%.o roms/$$(%_baserom)
	$(RGBLINK) $(RGBLINKFLAGS) -o $@ $<
	$(RGBFIX) $(RGBFIXFLAGS) $@

%.o: %.asm
	$(RGBASM) -o $@ $<

all: gold_rtc

gold_rtc: patches/pokegold_rtc.bps

roms: roms/pokegold_rtc.gbc

clean:
	$(RM) roms/$(roms) \
	roms/$(roms:.gbc=.sym) \
	roms/$(roms:.gbc=.map) \
	src/$(roms:.gbc=.o) \
	patches/$(roms:.gbc=.bps)

