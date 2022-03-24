.PHONY: dev release deps test clean install

dev:     ; opam exec -- dune build
release: ; opam exec -- dune build --profile release --build-dir _build_release

deps:  ; opam install . --deps-only --with-test
test:  ; opam exec -- dune runtest
clean: ; opam exec -- dune clean ; rm -rf _build_release _build

install: release
	install _build_release/default/src/main.exe $(HOME)/.newsboat/feeds/sql2rss
