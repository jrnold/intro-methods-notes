#!/usr/bin/env Rscript --quiet
bookdown::serve_book(dir = ".",
                     output_dir = "_book",
                     preview = TRUE,
                     port = 4321
                     )
