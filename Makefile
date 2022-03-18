
_build/default/sql2rss.exe:
	dune build

.PHONY: clean
clean: ; dune clean

.PHONY: install
install: _build/default/sql2rss.exe
	install $< $(HOME)/.newsboat/feeds/sql2rss
