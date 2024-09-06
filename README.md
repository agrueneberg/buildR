# buildR

Makefile-based build tools for R

## Usage

* Build package: `make build`
* Install package: `make install`
* Load package temporarily into an interactive R session: `make load`
* Check package: `make check`
* Test package with tinytest: `make test-tinytest`
* Test package with testthat: `make test-testthat`
* Submit to rhub: `make rhub`
* See Makefile for more features

The following directory structure is expected:

```
your_package/
├── Makefile
└── pkg
    ├── DESCRIPTION
    ├── ...
```
