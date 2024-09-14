roms := \
        roms/pokegold_rtc.gbc\
	roms/pokesilver_rtc.gbc \
	roms/pokecrystal_rtc.gbc \
	roms/pokecrystal11_rtc.gbc

pokegold_rtc_baserom = pokegold.gbc
pokesilver_rtc_baserom = pokesilver.gbc
pokecrystal_rtc_baserom = pokecrystal.gbc
pokecrystal11_rtc_baserom = pokecrystal11.gbc

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

.PHONY: clean all gold_rtc
.SECONDEXPANSION:

patches/%.bps: roms/%.gbc roms/$$(%_baserom)
	flips --create --bps roms/$($*_baserom) roms/$*.gbc $@

roms/%.gbc: src/%.o roms/$$(%_baserom)
	$(RGBLINK) $(RGBLINKFLAGS) -o $@ $<
	$(RGBFIX) $(RGBFIXFLAGS) $@

%.o: %.asm
	$(RGBASM) -o $@ $<

all: gold_rtc silver_rtc crystal_rtc crystal11_rtc

gold_rtc: patches/pokegold_rtc.bps

silver_rtc: patches/pokesilver_rtc.bps

crystal_rtc: patches/pokecrystal_rtc.bps

crystal11_rtc: patches/pokecrystal11_rtc.bps

roms:   roms/pokegold_rtc.gbc \
	roms/pokesilver_rtc.gbc \
	roms/pokecrystal_rtc.gbc \
	roms/pokecrystal11_rtc.gbc

clean:
	$(RM) $(roms) \
	$(roms:.gbc=.sym) \
	$(roms:.gbc=.map) \
	$(patsubst roms/%,src/%,$(roms:.gbc=.o)) \
	$(patsubst roms/%,patches/%,$(roms:.gbc=.bps))

