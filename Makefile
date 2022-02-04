PKGS  := xmlm unix pgx_unix stdio
WARNS := -w @A-4-33-40-41-42-43-34-44-70
OPTS  := $(foreach i,$(PKGS),-package $(i)) $(WARNS)
SRCS  := sql.ml rss.ml main.ml

main: $(SRCS)
	ocamlfind ocamlopt -linkpkg $(OPTS) -o $@ $^

.PHONY: clean
clean:
	rm -f main{,.cmi,.cmo,.cmx,.o}
