VENV = .venv
BIN = $(VENV)/bin
PYTHON = $(BIN)/python3
PIP = $(BIN)/pip

## Clean pycache and venv folder
clean:
	rm -rf __pycache__
	rm -rf $(VENV)

## install venv
$(VENV)/bin/activate: requirements.txt
	python3 -m venv $(VENV)
	$(PIP) install -r requirements.txt

## Run SQLFluff
lint-sqlfluff: $(VENV)/bin/activate
	$(BIN)/sqlfluff lint ./*.sql --config .sqlfluff

## Fix SQLFluff
fix-sqlfluff: $(VENV)/bin/activate
	$(BIN)/sqlfluff fix *.sql

# Self Documenting Makefile, add comment prepended with ## before each make command
.DEFAULT_GOAL := show-help
# See <https://gist.github.com/klmr/575726c7e05d8780505a> for explanation.
.PHONY: show-help clean run-sqlfluff
show-help:
    @echo "$$(tput bold)Available rules:$$(tput sgr0)";echo;sed -ne"/^## /{h;s/.*//;:d" -e"H;n;s/^## //;td" -e"s/:.*//;G;s/\\n## /---/;s/\\n/ /g;p;}" ${MAKEFILE_LIST}|LC_ALL='C' sort -f|awk -F --- -v n=$$(tput cols) -v i=19 -v a="$$(tput setaf 6)" -v z="$$(tput sgr0)" '{printf"%s%*s%s ",a,-i,$$1,z;m=split($$2,w," ");l=n-i;for(j=1;j<=m;j++){l-=length(w[j])+1;if(l<= 0){l=n-i-length(w[j])-1;printf"\n%*s ",-i," ";}printf"%s ",w[j];}printf"\n";}'|more $(shell test $(shell uname) == Darwin && echo '-Xr')