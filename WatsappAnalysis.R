install.packages("ggplot2")
install.packages("tm")
install.packages("wordcloud")
install.packages("syuzhet")

library(ggplot2)
library(tm)
library(wordcloud)
library(syuzhet)

texts=readLines("ChatwithTrainersArena.txt")
print(texts)


docs=Corpus(VectorSource(texts))
docs

trans=content_transformer(function(x,pattern) gsub(pattern," ",x))
docs=tm_map(docs,trans,"/")
docs=tm_map(docs,trans,"@")
docs=tm_map(docs,trans,"\\|")
docs=tm_map(docs,content_transformer(tolower))
docs=tm_map(docs,removeNumbers)
docs=tm_map(docs,removeWords,stopwords("english"))
docs=tm_map(docs,removePunctuation)
docs=tm_map(docs,stripWhitespace)
install.packages("SnowballC")
library(SnowballC)
docs=tm_map(docs,stemDocument)

dtm=TermDocumentMatrix(docs)
dtm
mat=as.matrix(dtm)
mat

v=sort(rowSums(mat),decreasing=TRUE)
print(v)

d=data.frame(word=names(v),freq=v)
head(d)

set.seed(1056)
wordcloud(words=d$word,freq=d$freq,min.freq=1,max.words=200,random.order=FALSE,rot.per=0.35,colors=brewer.pal(8,"Dark2"))

?get_nrc_sentiment

sentiment=get_nrc_sentiment(texts)
text=cbind(texts,sentiment)
print(text)

TotalSentiment=data.frame(colSums(text[,c(2:11)]))

names(TotalSentiment)="count"
TotalSentiment
TotalSentiment=cbind("sentiment" = rownames(TotalSentiment),TotalSentiment)

print(TotalSentiment)

rownames(TotalSentiment)=NULL

ggplot(data=TotalSentiment, aes(x = sentiment, y = count)) + geom_bar(aes(fill=sentiment), stat="identity") + theme(legend.position="none") + xlab("sentiment") + ylab("Total Count") + ggtitle("Total Sentiment Score")

