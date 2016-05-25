# code to generate a vector of the most frequent words in a corpus using tm and stylo
# also performs cluster analysis using stylo
# topic modelling via mallet using LDA algorithm
# SnowballC enables parallel computing in the tm_map function for stemming.
# tm_map calls functions of the 'parallel' package.
# Uses mclapply under the hood.
# N.B. 'parallel'does not work for windows so only a single core will be used in windows


if(!require(tm) | !require(SnowballC) | !require(stylo) | !require(mallet) | !require(parallel)) {
  install.packages(c('tm','SnowballC','stylo','mallet','parallel'))
}  

require(tm)
require(SnowballC)
require(stylo)
require(mallet)
require(parallel)

corpus<- VCorpus(DirSource("looted_heritage_reports"))

corpus <- tm_map(corpus, content_transformer(tolower))

corpus <- tm_map(corpus,removePunctuation)

corpus <- tm_map(corpus,removeNumbers)

#remove english stopwords and '>'
stop_words<- stopwords("english")
corpus<-tm_map(corpus,removeWords,c(stp_wrds,">"))

#remove whitespace generated after removing stopwords
corpus <- tm_map(corpus, stripWhitespace)

#stemming
corpus <- tm_map(corpus, stemDocument)

# generates the document term matrix for the corpus
dtm<-DocumentTermMatrix(corpus)

# taking only those words which are in atleast 10% of texts
# taking maximum 100 words
# input is the frequencies matrix generated in tm

pre_process<-stylo(gui=FALSE,
                    analysis.type="CA",
                    frequencies = as.matrix(dtm),
                    corpus.lang="english",
                    mfw.min=100,mfw.max=100,
                    culling.min =10,culling.max=10,
                    write.jpg.file=TRUE,
                    save.distance.tables = TRUE,
                    save.analyzed.features = TRUE,
                    save.analyzed.freqs = TRUE)

processed<-pre_process$features.actually.used
#list of the mfw
vocab<-as.vector(processed)

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
# 5 topics only because the sample corpus
# is related to just one subject hence
# overlap between topics is very high.
# lots of the words are in many topics

topic.model<-MalletLDA(num.topics=5)

# "stop_words.txt" is a file containing stopwords
# this has to be specified as a file
# Mallet can't take a list of stopwords
# suppy a 'pseudo file' as stop words
# if you do not want to remove any stop words 

mallet.instances<-mallet.import(id,corpus_text,"stop_words.txt")
topic.model$loadDocuments(mallet.instances)

#matrix of topic weights for every document
docment_topics<- mallet.doc.topics(topic.model,normalized=T,smoothed=T)

# matrix of word weights for topics
word_topsics<-mallet.topic.words(topic.model,normalized=T,smoothed=T)

# top 10 words in topic 2
topwords2<-mallet.top.words(topic.model,word_tops2[2,],10)
topwords2

# top 10 words in topic 3
topwords3<-mallet.top.words(topic.model,word_tops2[3,],10)
topwords3
