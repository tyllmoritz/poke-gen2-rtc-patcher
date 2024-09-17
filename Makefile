# Makefile specific
.PHONY: clean all patches_rtc patches_batteryless patches_batteryless_rtc
.SECONDEXPANSION:

RGBDS ?=
RGBASM  ?= $(RGBDS)rgbasm
RGBFIX  ?= $(RGBDS)rgbfix
RGBGFX  ?= $(RGBDS)rgbgfx
RGBLINK ?= $(RGBDS)rgblink

# get targets - every roms/* subdir with a input.gbc present
targets = $(patsubst %/, %, $(subst roms/, , $(dir $(wildcard roms/*/input.gbc))))

roms_rtc = $(foreach targetdir, ${targets}, \
$(shell grep -o "_RTC" roms/${targetdir}/settings.asm >/dev/null && echo "roms/${targetdir}/${targetdir}_rtc.gbc"))

roms_batteryless = $(foreach targetdir, ${targets}, \
$(shell grep -o "_BATTERYLESS" roms/${targetdir}/settings.asm >/dev/null && echo "roms/${targetdir}/${targetdir}_batteryless.gbc"))

roms_batteryless_rtc = $(foreach targetdir, ${targets}, \
$(shell { grep -o _RTC roms/${targetdir}/settings.asm >/dev/null && grep -o _BATTERYLESS roms/${targetdir}/settings.asm >/dev/null ;} && echo "roms/${targetdir}/${targetdir}_batteryless_rtc.gbc" ))

# if [ "$(grep -o _RTC roms/pokecrystal/settings.asm)" == "_RTC" -a "$(grep -o _BATTERYLESS roms/pokecrystal/settings.asm)" == "_BATTERYLESS" ]; then echo true; fi

roms = $(roms_rtc) $(roms_batteryless) $(roms_batteryless_rtc)


all: patches_rtc patches_batteryless patches_batteryless_rtc

patches_rtc: $(roms_rtc:.gbc=.bps)

patches_batteryless: $(roms_batteryless:.gbc=.bps)

patches_batteryless_rtc: $(roms_batteryless_rtc:.gbc=.bps)


# Create a sym/map for debug purposes if `make` run with `DEBUG=1`
ifeq ($(DEBUG),1)
RGBLINKFLAGS += -n $(@:.gbc=.sym) -m $(@:.gbc=.map)
RGBASMFLAGS = -E
endif


$(roms_rtc:.gbc=.o): RGBASMFLAGS += -D_RTC
$(roms_batteryless:.gbc=.o): RGBASMFLAGS += -D_BATTERYLESS
$(roms_batteryless_rtc:.gbc=.o): RGBASMFLAGS += -D_BATTERYLESS -D_RTC


$(roms:.gbc=.bps): $$(patsubst %.bps,%.gbc,$$@)
	flips --create --bps $(@D)/input.gbc $< $@

$(roms): $$(patsubst %.gbc,%.o,$$@)
	$(RGBLINK) $(RGBLINKFLAGS) -O $(@D)/input.gbc -o $@ $<
	$(RGBFIX) -p0 -v $@
	$(RM) $<

$(roms:.gbc=.o): $$(@D)/settings.asm src/main.asm
	$(RGBASM) $(RGBASMFLAGS) -o $@ --preinclude $< src/main.asm


clean:
	$(RM) $(roms) \
	$(roms:.gbc=.bps) \
	$(roms:.gbc=.sym) \
	$(roms:.gbc=.map) \
	$(roms:.gbc=.o)

