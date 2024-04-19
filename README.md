# pocket-nt

A parallel Bible text comparison PDF generator.

## Overview
This project is designed to generate a printable PDF file that provides a parallel comparison of two versions of Bible texts. It fetches data from two SQLite databases and generates a PDF that synchronizes the texts at the beginning of each chapter.

## Features
- **Parallel text comparison:** Directly compares two different Bible texts side by side, starting synchronization at the beginning of each chapter.
- **Multiple texts available:** Includes several Bible texts for comparison, which can be found in the `db/` directory of the project.
- **Pocket PDF format:** Generates a pocket-sized PDF suitable for printing or viewing in standard PDF viewers.
- **Data source:** The Bible texts used in this project are sourced from the library of Bible databases[^1].

## Getting Started
To use this PDF generator, follow these steps:

1. **Clone the repository:**
   ```
   git clone https://github.com/placek/pocket-nt.git
   cd pocket-nt
   ```

2. **Run the PDF generator script:**
   Execute the script to generate the PDF:
   ```
   make
   ```
   Alternatively, you can use any known versions of the Bible:
   ```
   make left=PAU right=NVUL
   ```
   By default, the make command prepares two versions of the PDF: one for use on electronic devices (such as PCs and mobile devices) `*_screen.pdf` and one ready for printing (with printing marks and bevels) `*_print.pdf`. To select only one option for generation, use dedicated targets:
   ```
   make screen left=CVUL right=NA27
   make print left=CVUL right=NA27
   ```
   **NOTE** If there is any problem with the generation of any variant, please [report that](https://github.com/placek/pocket-nt/issues/new).

3. **View or print the PDF:**
   Once generated, the PDF will be available in the specified output directory. You can open it with any PDF viewer or send it to a printer.

## Dependencies
- SQLite3 3.43.2
- [PrinceXML 15.3](https://www.princexml.com) (via Docker image[^2])
- GNU Make 4.4.1
- GNU sed 4.9
- cUrl 8.4.0
- UnZip 6.00

## Contributing
Contributions to this project are welcome. Please ensure to follow the existing coding style.

## License
The project can be distributed under the [MIT License](./LICENSE).

### DISCLAIMER
There are some limitations on the two aspects of the resources used by this tool:
1. The author of pocket-nt is not the owner of the SQLite databases. Each database has its own license and has to be carefully considered when such will be in any circumstance used/sold/modified/published/etc.
2. The PrinceXML has its own [limited license](https://www.princexml.com/purchase/).


[^1]: https://github.com/placek/bible-databases
[^2]: https://hub.docker.com/r/silquenarmo/princexml
