packageName := $(shell grep Package pkg/DESCRIPTION | cut -d ':' -f 2 | sed -e 's/^[[:space:]]*//g')
packageVersion := $(shell grep Version pkg/DESCRIPTION | cut -d ':' -f 2 | sed -e 's/^[[:space:]]*//g')
tarballName := $(packageName)_$(packageVersion).tar.gz

.PHONY: build check install test rhub revdepcheck clean

build:
	R CMD build pkg

check: build
	R CMD check $(tarballName)

install: build
	R CMD INSTALL $(tarballName)

test: install
	Rscript -e 'testthat::test_dir("pkg/tests")'

rhub: build
	Rscript -e 'rhub::check_for_cran("$(tarballName)")'

revdepcheck: build
	mkdir -p revdepcheck
	cp $(tarballName) revdepcheck
	Rscript -e 'summary(tools::check_packages_in_dir("revdepcheck", reverse = list()))'

clean:
	rm -f $(tarballName)
	rm -fr $(packageName).Rcheck
	rm -fr revdepcheck/
