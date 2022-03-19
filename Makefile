SRC := $(wildcard bin/sql2rss/*.ml)

_build/default/bin/sql2rss/main.exe: $(SRC) bin/sql2rss/dune
	dune build

.PHONY: clean
clean: ; dune clean

.PHONY: install
install: _build/default/bin/sql2rss/main.exe
	install $< $(HOME)/.newsboat/feeds/sql2rss
