(lang dune 2.9)

(name sql2rss)
(version 1.0.4)

(generate_opam_files true)
(license MIT)
(source (github azimut/sql2rss))
(authors "azimut")
(homepage "https://github.com/azimut/sql2rss")
(bug_reports "https://github.com/azimut/sql2rss/issues")
(maintainers "azimut.github@protonmail.com")

(package
 (name sql2rss)
 (synopsis "Converts a psql query into rss feed")
 (depends
  pgx_unix
  calendar))

