SRC := $(wildcard src/*.ml)

_build/default/src/main.exe: $(SRC) src/dune
	opam exec -- dune build

.PHONY: clean
clean: ; opam exec -- dune clean

.PHONY: install
install: _build/default/src/main.exe
	install $< $(HOME)/.newsboat/feeds/sql2rss
