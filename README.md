
### author_scrap
This function takes an author's name as input . It then searches for the author on the project gutenberg site and saves all the works of the author as a text file.

### pos_tagger
pos_tagger is a R function that does Parts-of-Speech tagging on a document and extracts nouns from it.
It uses [koRpus](https://cran.r-project.org/web/packages/koRpus/index.html), a wrapper in R for [treetagger](http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/). 

korPus is installed from within the function itself. The useR just has to download treetagger before running the function.

The useR should follow the instructions [here](http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/) to download the treetagger.Kindly follow the instructions exactly as stated so that koRpus can locate all the necessary files. Install all the files in a single directory and also install the parameter files of the language of your document before running the function. 

pos_tagger was succesfully tested on Ubuntu 14.04 LTS, Windows 8.1 and Windows 10 on texts in english.

N.B. TreeTagger installs the english parameter file as 'english-utf8.par' whereas koRpus looks for 'english.par' so kindly rename the file in the 'lib' folder of your treetagger installation before proceeding further. This problem could exist for other languages as well so kindly take note.

### mallet_integration
This is a complete workflow from taking a corpus as input,cleaning it and performing topic modelling using the 'mallet' package based on the Latent Dirichlet Allocation(LDA) algorithm.

Do let me know of any bugs or suggestions by dropping me a mail at [siddhantsingh707@gmail.com](mailto:siddhantsingh707@gmail.com)
