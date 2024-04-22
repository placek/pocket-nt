size ?= A6
left ?= PAU
right ?= NA28

style := /app/style.css
print := /app/print.css
chapters := /app/chapters.sql
render := /app/render.sed

all: screen print

.PHONY: screen
screen: $(left)-$(right)_screen.pdf

.PHONY: print
print: $(left)-$(right)_print.pdf

$(left)-$(right).html: info-$(left).html info-$(right).html
	mv "$(left).SQLite3" left.db; mv "$(right).SQLite3" right.db; \
	{ echo "<!DOCTYPE html><html><head><meta charset=\"utf-8\"><link rel=\"stylesheet\" href=\"$(style)\"></head><body><h1>pocket-nt</h1><info>"; \
	  cat "info-$(left).html" "info-$(right).html"; \
	  echo "</info>"; \
	  sqlite3 < $(chapters) | sed -rf $(render); \
	  echo "</body></html>"; \
	} > "$@"

%.zip:
	curl -s -o "$@" "https://raw.githubusercontent.com/placek/bible-databases/master/$(basename $@).zip"

cross_references.zip:
	curl -s -o "$@" "https://a.openbible.info/data/cross-references.zip"

cross_references.txt: cross_references.zip
	unzip -j "$<"

cross_references.csv: cross_references.txt
	sed -rf cr_to_db.sed "$<" > "$@"

cross_references.SQLite3: cross_references.csv
	sqlite3 "$@" "create table cross_references (book_number integer, chapter integer, verse integer, b1 integer, c1 integer, v1 integer, b2 integer, c2 integer, v2 integer, rate integer);"
	sqlite3 "$@" ".mode csv" ".import $< cross_references"

%.SQLite3: %.zip
	unzip -j "$<"

%_screen.pdf: %.html
	prince --verbose --pdf-title="pocket-nt" --no-network --page-size=$(size) --media=screen --output="/data/$@" "/data/$<"

%_print_raw.pdf: %.html
	prince --verbose --pdf-title="pocket-nt" --no-network --page-size=$(size) --media=print --style=$(print) --output="/data/$@" "/data/$<"

%_print.pdf: %_print_raw.pdf
	gs -dPDFX -dBATCH -dNOPAUSE -dNOOUTERSAVE -dNoOutputFonts -sDEVICE=pdfwrite -sColorConversionStrategy=CMYK -dProcessColorModel=/DeviceCMYK -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress -dHaveTransparency=false -sOutputFile="$@" "$<"

info-%.html: %.SQLite3
	{ echo "<column><description>"; \
	  sqlite3 "$<" "select value from info where name = 'description'" | sed "s/,/<br>/g"; \
	  echo "</description></column>"; \
	} > "$@"
