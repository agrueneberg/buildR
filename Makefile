packageName := $(shell grep '^Package:' pkg/DESCRIPTION | cut -d ':' -f 2 | sed -e 's/^[[:space:]]*//g')
packageVersion := $(shell grep '^Version:' pkg/DESCRIPTION | cut -d ':' -f 2 | sed -e 's/^[[:space:]]*//g')
tarballName := $(packageName)_$(packageVersion).tar.gz

.PHONY: build build-no-latex check check-no-latex check-as-cran check-reverse-dependencies check-all-reverse-dependencies install-tmp test-testthat test-tinytest load install spellcheck clean

build:
	R CMD build pkg

build-no-latex:
	R CMD build --no-manual --no-build-vignettes pkg

check: build
	@mkdir -p checks
	R CMD check -o checks $(tarballName)

check-no-latex: build-no-latex
	@mkdir -p checks
	R CMD check -o checks --no-manual --no-build-vignettes $(tarballName)

check-as-cran: build
	@mkdir -p checks
	R CMD check -o checks --as-cran $(tarballName)

check-reverse-dependencies: build
	@mkdir -p checks
	cp $(tarballName) checks
	Rscript -e 'setRepositories(ind = c(1, 2)); summary(tools::check_packages_in_dir("checks", reverse = list()))'

check-all-reverse-dependencies: build
	@mkdir -p checks
	cp $(tarballName) checks
	Rscript -e 'setRepositories(ind = c(1, 2)); summary(tools::check_packages_in_dir("checks", reverse = list(which = "all")))'

install-tmp: build-no-latex
	@mkdir -p lib
	R CMD INSTALL -l lib $(tarballName)

test-testthat: install-tmp
	Rscript -e 'library($(packageName), lib = "lib"); testthat::test_dir("pkg/tests/testthat")'

test-tinytest: install-tmp
	Rscript -e 'library($(packageName), lib = "lib"); tinytest::test_package("$(packageName)")'

load: install-tmp
	R_LIBS_USER="lib:$$R_LIBS_USER" R_DEFAULT_PACKAGES="datasets,utils,grDevices,graphics,stats,methods,$(packageName)" R

install: build
	R CMD INSTALL $(tarballName)

spellcheck: build
	Rscript -e 'spelling::spell_check_package("pkg")'

clean:
	rm -f $(tarballName)
	rm -fr checks/
	rm -fr lib/
