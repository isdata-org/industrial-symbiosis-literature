#never ever convert strings to factors
options(stringsAsFactors = FALSE)

options(java.parameters="-Xmx2g")   # optional, but more memory for Java helps
# devtools::install_github("agoldst/dfrtopics")
library(dfrtopics)
library(RefManageR)
library(mallet)

# this is an export from zotero where files are exported as well
# Aside from the paths here, the rest of the paths are relative, 
# assuming that you loaded this code by opening the project (R.Rproj)
entries = ReadBib("/home/cbdavis/Desktop/IndustrialSymbiosis/IndustrialSymbiosis.bib", .Encoding = "UTF-8", check=FALSE)
df = as.data.frame(entries)
rm(entries)
baseDir = "/home/cbdavis/Desktop/IndustrialSymbiosis/files"


df$FullText = ""

entriesWithMultiplePDFs = c()
entriesNoPDFs = c()
# process the pdfs which are included
for (i in c(1:nrow(df))){
  print(i)
  files = strsplit(df$file[i], ":files")[[1]]
  files = tail(files, n=-1) # remove first entry, just metadata
  pdfCount = 0
  for (file in files){
    name = strsplit(file, ":")[[1]]
    name = name[1]
    if (grepl("\\.pdf$", name)){
      pdfCount = pdfCount + 1
      fileName = paste(baseDir, name, sep="")
      fileName = shQuote(fileName, type = "sh")
      
      text = system(paste('pdftotext ', fileName, " -", sep=""), intern=TRUE)
      text = paste(text, collapse = " ")
      text = gsub("\\f", "", text)
      text = gsub("-\n", "", text) # remove hyphenation at new lines
      
      df$FullText[i] = text
      
      print(name)
    }
  }
  if (pdfCount > 1){
    entriesWithMultiplePDFs = c(entriesWithMultiplePDFs, i)
  } else if (pdfCount == 0){
    entriesNoPDFs = c(entriesNoPDFs, i)
  }
}


# titles of references with multiple pdfs (probably duplicates)
# df$title[entriesWithMultiplePDFs]
# titles of references without abstracts
# gsub("\\{|\\}", "", df$title[which(is.na(df$abstract))])
# titles without abstracts and pdfs
# gsub("\\{|\\}", "", df$title[intersect(which(is.na(df$abstract)), entriesNoPDFs)])

removeText = "[^A-za-z0-9+,.;:() ]+"

df$SoupText = paste(df$title, df$keywords, df$abstract, df$FullText)
#df$SoupText = paste(df$title, df$keywords, df$abstract)
df$SoupText = gsub(removeText, " ", df$SoupText)
df$title = gsub(removeText, " ", df$title)

df$journal = gsub("\\\\&", "&", df$journal)
df$author = gsub("\\{|\\}", "", df$author)

# dfr-browser expects seven metadata columns: id,title,author,journaltitle,volume,issue,pubdate,pagerange
df$id = df$url
df$journaltitle = df$journal
df$issue = df$number
df$pubdate = df$year
df$pagerange = df$pages

# replace NA with ""
cols = c("title", "author", "journaltitle", "volume", "issue", "pubdate", "pagerange")
for (col in cols){
  naVals = which(is.na(df[,col]))
  if (any(naVals)){
    df[naVals,col] = ""
  }
}

locs = which(!is.na(df$doi))
df$id[locs] = paste0("http://dx.doi.org/", df$doi[locs])

emptyIDs = which(is.na(df$id))

# link to google scholar if we can't find stuff
#https://scholar.google.nl/scholar?hl=en&q=2-s2.0-8491989818
df$id[emptyIDs] = paste0("https://scholar.google.nl/scholar?hl=en&q=",
                         unlist(lapply(paste0('"',
                                              df$title[emptyIDs],
                                              '" ',
                                              df$journal[emptyIDs]), URLencode)))


df$id = gsub("http://dx.doi.org/http://dx.doi.org/", "http://dx.doi.org/", df$id)

instance = mallet.import(df$id, df$SoupText, "en.txt")

df = df[,c("id", "title", "author", "journaltitle", "volume", "issue", "pubdate", "pagerange", "doi")]
# authors need to be separated by a tab in order to show up correctly
df$author = gsub(" and ", "\t", df$author)

m <- train_model(instance, n_topics=50, n_iters=1000, metadata=df, threads=8)

dfr_browser(m, out_dir = "../topic-modelling-visualization", internalize = TRUE, browse = FALSE)