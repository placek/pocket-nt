size ?= A6
left ?= PAU
right ?= NA28
name ?= pocket-nt

screen:= /app/screen.css
print := /app/print.css
chapters := /app/chapters.sql
render := /app/render.sed
url := https://github.com/placek/pocket-nt

all: screen print

.PHONY: screen
screen: $(left)-$(right)_screen.pdf

.PHONY: print
print: $(left)-$(right)_print.pdf

$(left)-$(right).xml: info-$(left).xml info-$(right).xml cross_references.SQLite3
	mv "$(left).SQLite3" left.db; mv "$(right).SQLite3" right.db; \
	{ echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"; \
	  echo "<nt>"; \
	  echo "<name>$(name)</name>"; \
	  echo "<logo></logo>"; \
	  echo "<info>"; \
	  echo "$$(cat 'info-$(left).xml' 'info-$(right).xml')"; \
	  echo "<description>$(url)</description>"; \
	  echo "</info>"; \
	  cat $(chapters) | sqlite3 | sed -rf $(render); \
	  echo "</nt>"; \
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
	sqlite3 "$@" "CREATE TABLE cross_references (book_number INTEGER, chapter INTEGER, verse INTEGER, b1 INTEGER, c1 INTEGER, v1 INTEGER, b2 INTEGER, c2 INTEGER, v2 INTEGER, rate INTEGER);"
	sqlite3 "$@" ".mode csv" ".import $< cross_references"

%.SQLite3: %.zip
	unzip -j "$<"

%_screen.pdf: %.xml
	prince --verbose --pdf-title="$(name)" --no-network --page-size=$(size) --media=screen --style=$(screen) --output="/data/$@" "/data/$<"

%_print_raw.pdf: %.xml
	prince --verbose --pdf-title="$(name)" --no-network --page-size=$(size) --media=print --style=$(print) --output="/data/$@" "/data/$<"

%_print.pdf: %_print_raw.pdf
	gs -dPDFX -dBATCH -dNOPAUSE -dNOOUTERSAVE -dNoOutputFonts -sDEVICE=pdfwrite -sColorConversionStrategy=CMYK -dProcessColorModel=/DeviceCMYK -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress -dHaveTransparency=false -sOutputFile="$@" "$<"

info-%.xml: %.SQLite3
	{ echo "<description>"; \
	  sqlite3 "$<" "SELECT value FROM info WHERE name = 'description'"; \
	  echo "</description>"; \
	} > "$@"

.PHONY: clean
clean:
	rm -f *.xml *.pdf *.db *.txt *.csv *.SQLite3
