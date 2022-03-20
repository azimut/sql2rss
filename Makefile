SRC := $(wildcard src/*.ml)

_build/default/src/main.exe: $(SRC) src/dune dune-project
	opam exec -- dune build

.PHONY: clean
clean: ; opam exec -- dune clean

.PHONY: deps
deps: ; opam install . --deps-only --with-test

.PHONY: test
test: ; opam exec -- dune runtest

.PHONY: install
install: _build/default/src/main.exe
	install $< $(HOME)/.newsboat/feeds/sql2rss
