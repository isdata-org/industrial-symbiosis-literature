# industrial-symbiosis-literature

- [What?](#what)
- [Visualization](#visualization)
- [Bibliography](#bibliography)

## What?

This is an ongoing effort to both collect and analyze literature related to [Industrial Symbiosis](https://en.wikipedia.org/wiki/Industrial_symbiosis).  To analyze the literature, we use [Topic Modelling](https://en.wikipedia.org/wiki/Topic_model) ([video](https://www.youtube.com/watch?v=5mkJcxTK1sQ)), which examines statistical properties of the text in order to determine the topics that are present.  

Topics represent collections of words that frequently co-occur within a documents, and by looking at the collection of words in a single topic, you can often deduce that the general theme is.  For example, if you see in a topic the words "*industrial, ecology, nature, metaphor, model, natural, ecosystem, analogy*", then this topic is a collection of documents that are talking about Industrial Ecology and how it uses the metaphor or analogy of nature and ecosystems.

## [Visualization](http://isdata-org.github.io/industrial-symbiosis-literature/topic-modelling-visualization/index.html)

<table><tr><td>
<a href="http://isdata-org.github.io/industrial-symbiosis-literature/topic-modelling-visualization/index.html#/model/list" target="_blank"><img src="https://github.com/isdata-org/industrial-symbiosis-literature/raw/master/images/TopicModelling.png" height="350"></a>
</td><td>
<a href="http://isdata-org.github.io/industrial-symbiosis-literature/topic-modelling-visualization/index.html#/model/grid" target="_blank"><img src="https://github.com/isdata-org/industrial-symbiosis-literature/raw/master/images/TopicModelling2.png" height="350"></a>
</td></tr></table>

[The visualization](http://isdata-org.github.io/industrial-symbiosis-literature/topic-modelling-visualization/index.html) is interactive and allows you to explore several things:

* [The collection of topics](http://isdata-org.github.io/industrial-symbiosis-literature/topic-modelling-visualization/index.html#/model/grid)
* [How closely topics are related to each other](http://isdata-org.github.io/industrial-symbiosis-literature/topic-modelling-visualization/index.html#/model/scaled)
* [How the prevalence of topics has changed over time](http://isdata-org.github.io/industrial-symbiosis-literature/topic-modelling-visualization/index.html#/model/list)
* [Which topics a word is prevalent in](http://isdata-org.github.io/industrial-symbiosis-literature/topic-modelling-visualization/index.html#/word/eip)
* [Which words are relevant for the topics](http://isdata-org.github.io/industrial-symbiosis-literature/topic-modelling-visualization/index.html#/words)

Topics including specific words:
* [Analysis](http://isdata-org.github.io/industrial-symbiosis-literature/topic-modelling-visualization/index.html#/word/analysis)
* [Assessment](
http://isdata-org.github.io/industrial-symbiosis-literature/topic-modelling-visualization/index.html#/word/assessment)
* [Criteria](http://isdata-org.github.io/industrial-symbiosis-literature/topic-modelling-visualization/index.html#/word/criteria)
* [Indicators](http://isdata-org.github.io/industrial-symbiosis-literature/topic-modelling-visualization/index.html#/word/indicators)
* [Metaphor](http://isdata-org.github.io/industrial-symbiosis-literature/topic-modelling-visualization/index.html#/word/metaphor)

## Bibliography

In the [literature overview](http://isdata-org.github.io/industrial-symbiosis-literature/topic-modelling-visualization/index.html#/bib) you can search by author, year, etc.

The source data used in the analysis below is from the file [IndustrialSymbiosis.bib](IndustrialSymbiosis.bib), which is stored using the [BibTeX](https://en.wikipedia.org/wiki/BibTeX) format.  This is an open standard and [can be read by most literature reference managers](https://en.wikipedia.org/wiki/Comparison_of_reference_management_software#Import_file_formats).

Entries in [IndustrialSymbiosis.bib](IndustrialSymbiosis.bib) containing `file = {Full Text PDF:` indicate that we have the actual pdf of the article and that this is used in the analysis.  Otherwise, only the title, abstract and keywords are used.
