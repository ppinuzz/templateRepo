# latexmk file to compile the thesis running 'latexmk' on the command line

# list of options used by Overleaf in its LatexMk "system-wide" file:
# https://www.overleaf.com/learn/how-to/How_does_Overleaf_compile_my_project%3F

# Main compilation command
#   -interaction=nonstopmode    try to compile without pausing for user interaction in case of errors
#   -synctex=1                  generate a synchronization file to go from source code to PDF and vice versa in an IDE (e.g., TeXstudio)
#   %O                          placeholder for optional compilation flags when calling latexmk
#   %S                          placeholder for the name of the LaTeX source file
$pdflatex = 'pdflatex -interaction=nonstopmode -synctex=1 %O %S';

# Where to find .bib files (outdated?)
#@BIBINPUTS = (".", "./chapters");

# Specify the output to be a .pdf (https://mg.readthedocs.io/latexmk.html#local-configuration-files):
$pdf_mode = 1;

# Specify the main file (if not specified, all the .tex files in the CWD will be used - in this case, there's no difference)
#@default_files = ('MAIN.tex');

# Keeps compiling whenever a change is saved (latexmk monitors your source code)
#$preview_continuous_mode = 1;

# Run BibTeX whenever a change in the .aux file occurs (to keep References updated)
$bibtex_use = 2;

# Clean these files before compilation (list of extensions)
$clean_ext = 'aux acn acr alg bbl bcf blg glo gls glsdefs idx ist lof lot nlg nlo nls out run.xml synctex.gz toc';

# Copied from Overleaf's default LatexMk
# https://www.overleaf.com/learn/how-to/How_does_Overleaf_compile_my_project%3F

# Glossaries 
add_cus_dep( 'glo', 'gls', 0, 'glo2gls' );
add_cus_dep( 'acn', 'acr', 0, 'glo2gls');  # from Overleaf v1
sub glo2gls {
    system("makeglossaries $_[0]");
}

# makeindex
@ist = glob("*.ist");
if (scalar(@ist) > 0) {
    $makeindex = "makeindex -s $ist[0] %O -o %D %S";
}

# nomenclature
add_cus_dep("nlo", "nls", 0, "nlo2nls");
sub nlo2nls {
        system("makeindex $_[0].nlo -s nomencl.ist -o $_[0].nls -t $_[0].nlg");
}


# Create nomenclature (https://mg.readthedocs.io/latexmk.html#advanced-options)
#@cus_dep_list = (@cus_dep_list, "glo gls 0 makenomenclature");
#sub makenomenclature {
#   system("makeindex $_[0].glo -s nomencl.ist -o $_[0].gls"); }
#@generated_exts = (@generated_exts, 'glo');

# Convert .eps figures into .pdf to be included in the thesis (https://mg.readthedocs.io/latexmk.html#advanced-options)
#@cus_dep_list = (@cus_dep_list, "eps pdf 0 eps2pdf");
#sub eps2pdf {
#   system("epstopdf $_[0].eps"); }

# If you want to move .cls, .sty and .bst files in other folders:
# read https://www.overleaf.com/learn/latex/Questions/I_have_a_lot_of_.cls%2C_.sty%2C_.bst_files%2C_and_I_want_to_put_them_in_a_folder_to_keep_my_project_uncluttered._But_my_project_is_not_finding_them_to_compile_correctly

# Specify the output directory (optional)
# $out_dir = 'build';

# Specify the file types to watch for changes (optional)
# @generated_exts = ('.pdf', '.synctex.gz', '.aux', '.bbl', '.bcf', '.blg', '.log', '.run.xml');

# Enable silent mode (optional)
# $silent = 1;

# Enable verbose mode (optional)
# $verbose = 1;

# Run PDF viewer at the end of compilation
#   start       run evince detached from the rest of the script (so that the script can finish or keep going even if evince is still open)
#$pdf_previewer = 'start evince %O %S';    # on LINUX

# Standard line to signify the end of the script
1;

