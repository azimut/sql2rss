.PHONY: dev release deps test clean run install

dev:     ; opam exec -- dune build
release: ; opam exec -- dune build --profile release --build-dir _build_release

deps:  ; opam install . --deps-only --with-test
test:  ; opam exec -- dune runtest
clean: ; opam exec -- dune clean ; rm -rf _build_release _build
run:   ; opam exec -- dune exec ./src/main.exe

install: release
	install _build_release/default/src/main.exe $(HOME)/.newsboat/feeds/sql2rss
