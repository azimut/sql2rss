.PHONY: dev release deps test install clean

dev:     ; opam exec -- dune build --profile dev --build-dir _build_dev
release: ; opam exec -- dune build --profile release --build-dir _build_release

deps: ; opam install . --deps-only --with-test
test: ; opam exec -- dune runtest

install: release
	install _build_release/default/src/main.exe $(HOME)/.newsboat/feeds/sql2rss

clean:
	opam exec -- dune clean
	rm -rf _build_release _build_dev
