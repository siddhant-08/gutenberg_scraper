
# Used the ebook " Complete works of William Shakespeare" as default while testing

gutenberg_scraper <-function(url="http://www.gutenberg.org/cache/epub/100/pg100.txt"){
    down_file="input.txt"
    if(!file.exists(down_file)){
      download.file(url,destfile = down_file)
    }
    text_file=readLines(down_file)
  
  # The Licence at the end of all E-Books on the GUTENBERG Project
  # are of the type
  # *** END OF THIS PROJECT GUTENBERG EBOOK 'Name of the Book'
  
  # a denotes the line number of that particular line
  # all the lines following that are deleted
  
    a<- grep("*** END OF THIS PROJECT GUTENBERG EBOOK ",text_file,fixed=TRUE)
    text_file=text_file[-(a:length(text_file))]
  
  # Now removing the disclaimers in the documents that look like this
  
  #<<THIS ELECTRONIC VERSION OF THE .............
  #..............CHARGES FOR DOWNLOAD TIME OR FOR MEMBERSHIP.>>
  # A easier but inefficient way was to convert the text_file into 
  # a character string and then apply strsplit around " <<[^>]*>> "
  # to generate several documents and then 
  #stitch the generated documents back together.
  
  #The followning implemetation just finds all the starting(left) and ending(right)
  # line numbers of all the disclaimers in the document and removes them
  
    
  
    left<-grep("<<",text_file,fixed=TRUE)
    right<-grep(">>",text_file,fixed=TRUE)
    
    # const is the number of lines in a disclaimer  
    const<- right[1]-left[1] + 1
    
    # const(i-1) has to be subtracted in every iteration because we have 
    # deleted const*(i-1) number of lines before that so the lines
    # shift up by that much.
    
    for(i in  1:length(right)){
      text_file = text_file[-( ( left[i] - const*( i - 1 )) : ( right[i] - const*( i - 1 )) )]
    }
    file_opt<- file("output1.txt")
    writeLines(text_file,file_opt)
    close(file_opt)
}  
