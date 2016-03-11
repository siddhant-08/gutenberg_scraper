pos_tagger<-function(doc="korpusIP.txt"){
  # doc is your text file
  
  library(koRpus)
  
  #language of the text.
  # N.B. for different languages download the parameter files from
  # http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/
  
  language<-"en"
  
  # path of installation of the treetagger package. Install all the installation files in the same directory
  # installation instructions at http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/
  tree_tagger_path<-"treetagger"
  
  #returns an S4 object of type kRp.tsgged can be used further by extracting required slots
  # as given at http://finzi.psych.upenn.edu/library/koRpus/html/kRp.tagged-class.html
  
  tagged_text<-treetag(doc,treetagger="manual",lang=language,TT.options=list(path=tree_tagger_path,preset="en"))
  
  #####################################################################################################################
  # NOTE:For english the koRpus package searches for parameter file 'tree_tag_path/lib/english.par'
  # The newer version of the treetagger instead ships with the file 'english-utf8.par'
  # So manually rename the file to 'english.par' in the treetag installation folder (tree_tagger_path/lib  in my case)
  ######################################################################################################################
  #Results of the called tokenizer and POS tagger. The data.frame has eight columns:
  tags_df<-slot(tagged_text,"TT.res")
  
  
  # The sample document contains the text "It is a cheerful morning. The sun is shining brightly."
  # Now extracting nouns from the tagged document
  
  y<-(tags_df$token[tags_df$tag %in% c( "NN" ) ]) 
  
  return (y)
}
