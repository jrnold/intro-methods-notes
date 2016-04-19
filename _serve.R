#!/usr/bin/env Rscript --quiet
quiet = "--quiet" %in% commandArgs(FALSE)
bookdown::serve_book(dir = ".",
                     preview = FALSE,
                     daemon = FALSE,
                     in_session = FALSE)
