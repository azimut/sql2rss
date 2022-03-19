SRC := $(wildcard src/*.ml)

_build/default/src/main.exe: $(SRC) src/dune
	dune build

.PHONY: clean
clean: ; dune clean

.PHONY: install
install: _build/default/src/main.exe
	install $< $(HOME)/.newsboat/feeds/sql2rss
