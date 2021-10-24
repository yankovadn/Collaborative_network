#load packages
library(readxl)
library(dplyr)
library(igraph)
library(writexl)
library(data.table)
library(networkD3)
library(tidyverse)
library(visNetwork)
library(htmlwidgets)




#load data
data <- read_excel("Convocatorias_AVI_2018-2021.xlsx") %>%
  filter(Approved == 1)




#count the total number of projects
length(unique(data$ProjectTitle))

#count the total number of unique organizations
length(unique(data$Entity))

#count the number of projects per year
distinct_projects <- distinct(data, `ProjectTitle`, .keep_all=TRUE)
table(distinct_projects$`Year`)

#create an adjacency matrix
adj_matrix <- crossprod(table(select(data, c("ProjectTitle","Entity"))))
diag(adj_matrix) <- 0

edgelist <- as_edgelist(graph_from_adjacency_matrix(adj_matrix, mode="undirected", weighted=T))
ties <- length(as.data.frame(edgelist)[,1])

#visualize the network
network <- simpleNetwork(as.data.frame(edgelist), height="100px", width="100px", zoom=t)
network
saveNetwork(network, "AVI.html", selfcontained = TRUE)
