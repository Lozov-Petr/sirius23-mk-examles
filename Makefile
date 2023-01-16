.PHONY: family nat WGC bottles bridge hanoi einstein WGC_noCanren

build:
	dune build

clean:
	dune clean

family:
	dune exec family/family.exe

nat:
	dune exec nat/nat.exe

WGC:
	dune exec WGC/WGC.exe

bottles:
	dune exec noCanren/bottles_run.exe

bridge:
	dune exec noCanren/bridge_run.exe

hanoi:
	dune exec noCanren/hanoi_run.exe

einstein:
	dune exec noCanren/einstein_run.exe

WGC_noCanren:
	dune exec noCanren/WGC_run.exe