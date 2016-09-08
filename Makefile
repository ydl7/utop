# Makefile
# --------
# Copyright : (c) 2012, Jeremie Dimino <jeremie@dimino.org>
# Licence   : BSD3
#
# Generic Makefile for oasis project

# Set to setup.exe for the release
SETUP := ocaml setup.ml

# Default rule
default: build

# Setup for the development version
setup-dev.exe: _oasis setup.ml
	sed '/^#/D' setup.ml > setup_dev.ml
	ocamlfind ocamlopt -o $@ -linkpkg -package ocamlbuild,oasis.dynrun setup_dev.ml || \
	  ocamlfind ocamlc -o $@ -linkpkg -package ocamlbuild,oasis.dynrun setup_dev.ml || true
	rm -f setup_dev.*

# Setup for the release
setup.exe: setup.ml
	ocamlopt.opt -w -3 -o $@ $< || ocamlopt -w -3 -o $@ $< || ocamlc -w -3 -o $@ $<
	rm -f setup.cmx setup.cmi setup.o setup.obj setup.cmo

build: setup.data
	$(SETUP) -build $(BUILDFLAGS)

doc: setup.data build
	$(SETUP) -doc $(DOCFLAGS)
	cp style.css _build/utop-api.docdir/

test: setup.data build
	$(SETUP) -test $(TESTFLAGS)

all:
	$(SETUP) -all $(ALLFLAGS)

install: setup.data
	ocamlfind remove utop 2>/dev/null || true
	$(SETUP) -install $(INSTALLFLAGS)

uninstall: setup.data
	$(SETUP) -uninstall $(UNINSTALLFLAGS)

reinstall: setup.data
	ocamlfind remove utop 2>/dev/null || true
	$(SETUP) -reinstall $(REINSTALLFLAGS)

clean:
	$(SETUP) -clean $(CLEANFLAGS)

distclean:
	$(SETUP) -distclean $(DISTCLEANFLAGS)

configure:
	$(SETUP) -configure $(CONFIGUREFLAGS)

setup.data:
	$(SETUP) -configure $(CONFIGUREFLAGS)

gh-pages: doc
	git clone `git config --get remote.origin.url` .gh-pages --reference .
	git -C .gh-pages checkout --orphan gh-pages
	git -C .gh-pages reset
	git -C .gh-pages clean -dxf
	cp -t .gh-pages/ _build/utop-api.docdir/*
	git -C .gh-pages add .
	git -C .gh-pages commit -m "Update Pages"
	git -C .gh-pages push origin gh-pages -f
	rm -rf .gh-pages

.PHONY: default build doc test all install uninstall reinstall clean distclean configure gh-pages
