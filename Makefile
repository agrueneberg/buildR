packageName := $(shell grep Package pkg/DESCRIPTION | cut -d ':' -f 2 | sed -e 's/^[[:space:]]*//g')
packageVersion := $(shell grep Version pkg/DESCRIPTION | cut -d ':' -f 2 | sed -e 's/^[[:space:]]*//g')
tarballName := $(packageName)_$(packageVersion).tar.gz

.PHONY: build check install test

build:
	R CMD build pkg

check: build
	R CMD check $(tarballName)

install: build
	R CMD INSTALL $(tarballName)

test: install
	Rscript -e 'testthat::test_dir("pkg/tests")'
