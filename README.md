# nano-lazar-paper

Source code for nano-lazar publication (and oral presentations).

Validation experiments can be repeated with the included Makefile. New validation results will be included into `nano-lazar.pdf`.

## Repeat validations with the same dataset

  `make clean-validations; make`

## Update dataset from eNanoMapper and repeat validations

  `make clean; make`

## Docker image

  A docker image with all required software dependencies (e.g. `lazar`, `Rserve`, `pandoc` with filters) can be found at <https://hub.docker.com/r/insilicotox/nano-lazar-paper>.
