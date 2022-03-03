.PHONY: clean
.PHONY: all
.PHONY: run

SDKBIN=../../bin
SIM="Playdate Simulator"

all: Hammer\ Down.pdx

Hammer\ Down.pdx: Source/main.lua
	$(SDKBIN)/pdc Source Hammer\ Down.pdx

clean:
	rm -rf Hammer\ Down.pdx

run: all
	$(SDKBIN)/$(SIM).app/Contents/MacOS/$(SIM) Hammer\ Down.pdx

