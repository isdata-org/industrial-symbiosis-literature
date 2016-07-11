#never ever convert strings to factors
options(stringsAsFactors = FALSE)

options(java.parameters="-Xmx2g")   # optional, but more memory for Java helps
library(dfrtopics)
library(RefManageR)
library(mallet)

# this is an export from zotero where files are exported as well
entries = ReadBib("/home/cbdavis/Desktop/IndustrialSymbiosis/IndustrialSymbiosis.bib", .Encoding = "UTF-8", check=FALSE)
df = as.data.frame(entries)
rm(entries)

baseDir = "/home/cbdavis/Desktop/IndustrialSymbiosis/files"

df$FullText = ""

# should analyze in blocks of 500 words

# process the pdfs which are included
for (i in c(1:nrow(df))){
  print(i)
  files = strsplit(df$file[i], ":files")[[1]]
  files = tail(files, n=-1) # remove first entry, just metadata
  for (file in files){
    name = strsplit(file, ":")[[1]]
    name = name[1]
    if (grepl("\\.pdf$", name)){

      fileName = paste(baseDir, name, sep="")
      fileName = shQuote(fileName, type = "sh")

      text = system(paste('pdftotext ', fileName, " -", sep=""), intern=TRUE)
      text = paste(text, collapse = " ")
      text = gsub("\\f", "", text)

      df$FullText[i] = text

      print(name)
    }
  }
}


removeText = "[^A-za-z0-9+,.;:() ]+"

df$SoupText = paste(df$title, df$keywords, df$abstract, df$FullText)
#df$SoupText = paste(df$title, df$keywords, df$abstract)
df$SoupText = gsub(removeText, " ", df$SoupText)
df$title = gsub(removeText, " ", df$title)

# dfr-browser expects seven metadata columns: id,title,author,journaltitle,volume,issue,pubdate,pagerange
df$id = df$url
df$journaltitle = df$journal
df$issue = df$number
df$pubdate = df$year
df$pagerange = df$pages

locs = which(!is.na(df$doi))
df$id[locs] = paste0("http://dx.doi.org/", df$doi[locs])

emptyIDs = which(is.na(df$id))
# need to figure out how to directly link to scopus
# link to google scholar if we can't find stuff
#https://scholar.google.nl/scholar?hl=en&q=2-s2.0-8491989818
df$id[emptyIDs] = paste0("https://scholar.google.nl/scholar?hl=en&q=",
                           unlist(lapply(paste0('"',
                                                df$title[emptyIDs],
                                                '" ',
                                                df$journal[emptyIDs]), URLencode)))


# instance = mallet.import(df$id,
#                          df$SoupText,
#                          "/home/cbdavis/Dropbox/IS Data/Twitter/Bot/en.txt")

instance = mallet.import(as.character(c(1:nrow(df))),
                        df$SoupText,
                        "/home/cbdavis/Dropbox/IS Data/Twitter/Bot/en.txt")


df = df[,c("id", "title", "author", "journaltitle", "volume", "issue", "pubdate", "pagerange", "doi")]

m <- train_model(instance, n_topics=100, n_iters=1000, metadata=df, threads=8)
#write_mallet_model(m, "modeling_results")
#export_browser_data(m, out_dir="browser", overwrite=TRUE)

dfr_browser(m, out_dir = "/home/cbdavis/Desktop/svn/industrial-symbiosis-literature/topic-modelling-visualization", internalize = TRUE, browse = FALSE)
