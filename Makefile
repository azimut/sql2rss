main: main.ml
	ocamlc -o $@ $<

.PHONY: clean
clean:
	rm -f main
