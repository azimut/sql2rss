(lang dune 2.9)

(name sql2rss)
(version 1.0.4)

(generate_opam_files true)

(maintainers "azimut.github@protonmail.com")

(package
 (name sql2rss)
 (synopsis "psql -> rss")
 (depends
  pgx_unix
  stdio
  calendar))

