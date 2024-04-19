size ?= A6
left ?= BT'03
right ?= NA28

all: screen print

.PHONY: screen
screen: $(left)-$(right)_screen.pdf

.PHONY: print
print: $(left)-$(right)_print.pdf

$(left)-$(right).html: info-$(left).html info-$(right).html chapters.sql render.sed
	mv "$(left).SQLite3" left.db; mv "$(right).SQLite3" right.db; \
	{ echo "<!DOCTYPE html><html><head><meta charset=\"utf-8\"><link rel=\"stylesheet\" href=\"style.css\"></head><body><h1>pocket-nt</h1><info>"; \
	  cat "info-$(left).html" "info-$(right).html"; \
	  echo "</info>"; \
	  sqlite3 < chapters.sql | sed -rf render.sed; \
	  echo "</body></html>"; \
	} > "$@"

%.zip:
	curl -s -o "$@" "https://raw.githubusercontent.com/placek/bible-databases/master/$(basename $@).zip"

%.SQLite3: %.zip
	unzip -j "$<"

%_screen.pdf: %.html
	docker run --rm -v "`pwd`":/data silquenarmo/princexml:15.3 --verbose --pdf-title="pocket-nt" --no-network --page-size=$(size) --media=screen --output="/data/$@" "/data/$<"

%_print_raw.pdf: %.html
	docker run --rm -v "`pwd`":/data silquenarmo/princexml:15.3 --verbose --pdf-title="pocket-nt" --no-network --page-size=$(size) --media=print --style=/data/print.css --output="/data/$@" "/data/$<"

%_print.pdf: %_print_raw.pdf
	gs -dPDFX -dBATCH -dNOPAUSE -dNOOUTERSAVE -dNoOutputFonts -sDEVICE=pdfwrite -sColorConversionStrategy=CMYK -dProcessColorModel=/DeviceCMYK -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress -dHaveTransparency=false -sOutputFile="$@" "$<"

info-%.html: %.SQLite3
	{ echo "<column><description>"; \
	  sqlite3 "$<" "select value from info where name = 'description'" | sed "s/,/<br>/g"; \
	  echo "</description></column>"; \
	} > "$@"

.PHONY: clean
clean:
	rm -f *.html *.pdf *.zip *.SQLite3 *.db
