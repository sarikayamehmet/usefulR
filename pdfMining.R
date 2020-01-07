# folder of PDFs
dest <- "sl"

# make a vector of PDF file names
myfiles <- list.files(path = dest, pattern = "pdf",  full.names = TRUE)

# convert each PDF file that is named in the vector into a text file 
# text file is created in the same directory as the PDFs
# note that my pdftotext.exe is in a different location to yours
## Downloads "https://xpdfreader-dl.s3.amazonaws.com/xpdf-tools-win-4.02.zip"
lapply(myfiles, function(i) system(paste('"C:/Users/ms/Downloads/xpdf-tools-win-4.02/bin64/pdftotext.exe"', 
                                         paste0('"', i, '"')), wait = FALSE) )

# if you just want the abstracts, we can use regex to extract that part of
# each txt file, Assumes that the abstract is always between the words 'Abstract'
# and 'Introduction'
mytxtfiles <- list.files(path = dest, pattern = "txt",  full.names = TRUE)
abstracts <- lapply(mytxtfiles, function(i) {
  j <- paste0(scan(i, what = character()), collapse = " ")
  regmatches(j, gregexpr("(?<=Abstract).*?(?=Introduction)", j, perl=TRUE))
})

# write abstracts as txt files 
# (or use them in the list for whatever you want to do next)
lapply(1:length(abstracts),  
       function(i) write.table(abstracts[i], file=paste(mytxtfiles[i], "abstract", "txt", sep="."), 
                               quote = FALSE, row.names = FALSE, col.names = FALSE, eol = " " ))
