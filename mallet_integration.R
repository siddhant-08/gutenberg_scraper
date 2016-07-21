# code to generate a vector of the most frequent words in a corpus using tm and stylo
# also performs cluster analysis using stylo
# topic modelling via mallet using LDA algorithm
# tm_map calls functions of the 'parallel' package and uses mclapply under the hood.
# N.B. 'parallel'does not work for windows so only a single core will be used in windows


# install required packages
if(!require(tm) | !require(SnowballC) | !require(stylo) | !require(mallet) | !require(parallel)) {
  install.packages(c('tm','SnowballC','stylo','mallet','parallel'))
}  

require(tm)
require(SnowballC)
require(stylo)
require(mallet)
require(parallel)

# preprocess the corpus
pre_process<- function(corpus_dir){
  corpus<- VCorpus(DirSource(corpus_dir))
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus,removePunctuation)
  corpus <- tm_map(corpus,removeNumbers)
  
  #remove english stopwords
  stop_words<- stopwords("english")
  corpus<-tm_map(corpus,removeWords,stp_wrds)
  
  #remove whitespace generated after removing stopwords
  corpus <- tm_map(corpus, stripWhitespace)

  #stemming
  corpus <- tm_map(corpus, stemDocument)
  return (corpus)
}  
  # generates the document term matrix for the corpus
  #dtm<-DocumentTermMatrix(corpus)

run_lda<- function(corpus, num_topics = 5){
  # now getting required format for mallet to work with 
  # a character vector of text in documents and a vector containing document ids
  
  #tokenizing
  token_corpus<-txt.to.words.ext(corpus,language = "English.all")
  #removing pronouns
  token_corpus_no_pronoun<- delete.stop.words(token_corpus,stop.words=stylo.pronouns(language="English"))

  # extracting document IDs
  id<-names(token_corpus_no_pronoun)

  num_docs<-length(token_corpus_no_pronoun)
  corpus_text<-vector()
  # forming the text to pass to mallet
  # It can't take DocumentTermMatrix as input
  # like the topicmodels package

  for(i in 1: num_docs){
    corpus_text<-rbind(corpus_text,paste(token_corpus_no_pronoun[[i]],collapse = ' '))
  }
  #removing NAs
  corpus_text<-corpus_text[!is.na(corpus_text)]
  
  # initialising the topic model.
  # default is 5 topics only because the sample corpus
  # is very small so overlap between topics is very high.

  topic.model<-MalletLDA(num.topics=num_topics)

  # "stop_words.txt" is a file containing stopwords
  # this has to be specified as a file
  # Mallet can't take a list of stopwords
  # suppy a 'pseudo(empty) file' as stop words
  # if you do not want to remove any stop words 

  mallet.instances<-mallet.import(id,corpus_text,"stop_words.txt")
  topic.model$loadDocuments(mallet.instances)

  #matrix of topic weights for every document
  document_topics<- mallet.doc.topics(topic.model,normalized=T,smoothed=T)

  # matrix of word weights for topics
  word_topics<-mallet.topic.words(topic.model,normalized=T,smoothed=T)
  
  # debugging
  """
  # top 10 words in topic 2
  topwords2<-mallet.top.words(topic.model,word_tops2[2,],10)
  topwords2

  # top 10 words in topic 3
  topwords3<-mallet.top.words(topic.model,word_tops2[3,],10)
  topwords3"""
  return (word_topics)
}
