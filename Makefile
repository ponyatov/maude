CWD    = $(CURDIR)
MODULE = $(notdir $(CWD))

NOW = $(shell date +%d%m%y)
REL = $(shell git rev-parse --short=4 HEAD)

WGET = wget -c --no-check-certificate

MAUDE = $(CWD)/maude/maude-Yices2.linux64



.PHONY: all maude
all: $(MAUDE)
	$^



.PHONY: install
install: debian gz

.PHONY: bin
bin: $(MAUDE)

$(MAUDE): gz/Maude-3.0-yices2-linux.zip
	unzip $< -d maude && touch $@ && chmod +x $@

.PHONY: gz
gz: gz/Maude-3.0-yices2-linux.zip

.PHONY: debian
debian:
	sudo apt update
	sudo apt install -u `cat apt.txt`

gz/Maude-3.0-yices2-linux.zip:
	$(WGET) -O $@ http://maude.cs.illinois.edu/w/images/2/27/Maude-3.0%2Byices2-linux.zip
gz/Maude-3.0-cvc4-linux.zip:
	$(WGET) -O $@ http://maude.cs.illinois.edu/w/images/7/73/Maude-3.0%2Bcvc4-linux.zip



.PHONY: master shadow release zip

MERGE  = Makefile README.md .gitignore .vscode apt.txt
MERGE += doc gz

master:
	git checkout $@
	git checkout shadow -- $(MERGE)

shadow:
	git checkout $@

release:
	git tag $(NOW)-$(REL)
	git push -v && git push -v --tags
	git checkout shadow

zip:
	git archive --format zip --output $(MODULE)_src_$(NOW)_$(REL).zip HEAD
