packageName := $(shell grep '^Package:' pkg/DESCRIPTION | cut -d ':' -f 2 | sed -e 's/^[[:space:]]*//g')
packageVersion := $(shell grep '^Version:' pkg/DESCRIPTION | cut -d ':' -f 2 | sed -e 's/^[[:space:]]*//g')
tarballName := $(packageName)_$(packageVersion).tar.gz

.PHONY: build check check-as-cran install test rhub revdepcheck spellcheck clean

build:
	R CMD build pkg

check: build
	mkdir -p checks
	R CMD check -o checks $(tarballName)

check-as-cran: build
	mkdir -p checks
	R CMD check -o checks --as-cran $(tarballName)

install: build
	R CMD INSTALL $(tarballName)

test: install
	Rscript -e 'library(testthat); library($(packageName)); test_dir("pkg/tests/testthat")'

rhub: build
	Rscript -e 'rhub::check_for_cran("$(tarballName)")'

revdepcheck: build
	mkdir -p checks
	cp $(tarballName) checks
	Rscript -e 'summary(tools::check_packages_in_dir("checks", reverse = list()))'

spellcheck: build
	Rscript -e 'spelling::spell_check_package("pkg")'

clean:
	rm -f $(tarballName)
	rm -fr checks/
