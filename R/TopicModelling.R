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


df$SoupText = paste(df$title, df$keywords, df$abstract, df$FullText)
df$SoupText = gsub("[\\{|\\}]", "", gsub("\\\\", "", df$SoupText))

instance = mallet.import(as.character(c(1:nrow(df))),
                         df$SoupText,
                         "/home/cbdavis/Dropbox/IS Data/Twitter/Bot/en.txt")

# dfr-browser expects seven metadata columns: id,title,author,journaltitle,volume,issue,pubdate,pagerange
df$id = c(1:nrow(df))
df$journaltitle = df$journal
df$issue = df$number
df$pubdate = df$year
df$pagerange = df$pages

df = df[,c("id", "title", "author", "journaltitle", "volume", "issue", "pubdate", "pagerange", "doi", "SoupText")]

m <- train_model(instance, n_topics=50, n_iters=300, metadata=df, threads=8)
#write_mallet_model(m, "modeling_results")
#export_browser_data(m, out_dir="browser", overwrite=TRUE)


dfr_browser(m, out_dir = "/home/cbdavis/Desktop/svn/industrial-symbiosis-literature/topic-modelling-visualization", internalize = TRUE, browse = TRUE)

