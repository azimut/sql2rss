SRC := $(wildcard *.ml)

_build/default/sql2rss.exe: $(SRC)
	dune build

.PHONY: clean
clean: ; dune clean

.PHONY: install
install: _build/default/sql2rss.exe
	install $< $(HOME)/.newsboat/feeds/sql2rss
