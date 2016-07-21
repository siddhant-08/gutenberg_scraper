library(rvest)
library(curl)
library(RCurl)

get_text<-function(url,index,author)
{
  options(HTTPUserAgent='Mozilla/5.0 (X11; U; Linux i686; en-US) AppleWebKit/534.3 (KHTML, like Gecko) Chrome/6.0.472.63 Safari/534.3')
  # creating names for the files to be stored
  text = paste(index,"_",author,".txt",sep='')
  file.create(text)
  download.file(url, destfile = text,method='curl')
  
  fin_text <- readLines(text)
  
  open<-file(text)
  writeLines(fin_text, open)
  close(open)
}

scrap_ip_author <- function(name="Jane Austen")
{
  x<-strsplit(name,' ')
  first_name<-as.character(x[[1]][1])
  last_name<-as.character(x[[1]][2])
  
  first_char <- tolower(substring(last_name,1,1))
  
  # browse by first character of last name of the author
  url <- paste("https://www.gutenberg.org/browse/authors/",first_char,sep="")
  parse <- read_html(url)
  
  #list of authors
  authors <- parse%>%html_nodes("div.pgdbbyauthor h2 a")%>% html_text()
  # only the odd numbered nodes contain the authors
  # so selecting those
  authors<-authors[c(TRUE,FALSE)]
  
  # splittig author names
  last_names_authors<- sapply(strsplit(authors,', '), function(x) x[1])
  first_names_authors<- sapply(strsplit(authors,', '), function(x) x[2])
  #forming a names data frame
  names<-as.data.frame(cbind(first_names_authors,last_names_authors),stringsAsFactors = FALSE)
  
  # finding row which matches the searched author
  row_num<-which(grepl(first_name,names$first_names_authors) & grepl(last_name,names$last_names_authors))
  
  # list of books written by the author
  book_list <- (parse%>%html_nodes("div.pgdbbyauthor ul"))[row_num]%>%html_nodes("li.pgdbetext a")
  
  #codes of the ebooks 
  book_codes <- html_attr(book_list,"href")
  bx<- as.vector(strsplit(book_codes,'/'))
  
  codes<-vector()
  for(i in 1: length(book_codes)){
    codes<-append(codes,bx[[i]][3])
  }
  index<-1
  for(book_code in codes){
    # webpage of the ebook
    book_page<-paste("http://www.gutenberg.org/ebooks/",book_code,sep = '')
    book_page<-read_html(book_page)
    # The book is available in many formats like epub,html,txt etc.
    # we are interested in only txt i.e text/plain type.
    formats<- book_page%>%html_nodes("table.files tr td a")%>%html_attr("type")
    
    # finding the row number of the node corresponding to the txt format
    val_num<-formats=="text/plain"
    row_num<- which(val_num==TRUE)
    
    text_file_node<- (book_page%>%html_nodes("table.files tr td a"))[row_num]
    
    url_of_text<- text_file_node%>%html_attr("href")
    fin_url<-paste("www.gutenberg.org/cache/epub/",book_code,"/pg",book_code,".txt",sep='')
    
    get_text(fin_url,index,last_name)
    index<- index + 1
  }
}
scrap_ip_author()
