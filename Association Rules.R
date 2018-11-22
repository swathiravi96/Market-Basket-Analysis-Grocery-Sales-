##### Association Rules -------------------

##  Identifying Frequently-Purchased Groceries ----
## Step 2: Exploring and preparing the data ----

#Our market basket analysis will utilize the purchase data
#collected from one month of operation at a real-world grocery store. 
#The data contains 9,835 transactions or about 327 transactions per day

# load the grocery data into a sparse matrix

#Transactional data is stored in a slightly different format than that we used previously.
#transactional data is a more free form
#each record comprises a comma-separated list of any number of items, from one to many. 
#In essence, the features may differ from example to example.
#we need a dataset that does not treat a transaction as a set of positions
#to be filled (or not filled) with specific items, but rather as a market basket that either
#contains or does not contain each particular item.

install.packages('arules')
install.packages('arulesViz')
install.packages('arulesCBA')
library(arulesViz)
library(arulesCBA)
groceries <- read.transactions("groceries.csv", sep = ",")
summary(groceries)

# look at the first five transactions
inspect(groceries[1:5])

# examine the frequency of items
itemFrequency(groceries[, 1:3])
png('filu.jpg')
# plot the frequency of items
itemFrequencyPlot(groceries, support = 0.1)
dev.off()
png('filu2.jpg')
itemFrequencyPlot(groceries, topN = 20)
dev.off()
png('file.jpg')
# a visualization of the sparse matrix for the first five transactions
image(groceries[1:5])
dev.off()
# visualization of a random sample of 100 transactions
png('file2.jpg')
image(sample(groceries, 100))
dev.off()

## Step 3: Training a model on the data ----
library(arules)

# default settings result in zero rules learned
apriori(groceries)

# set better support and confidence levels to learn more rules
groceryrules <- apriori(groceries, parameter = list(support =
                          0.006, confidence = 0.25, minlen = 2))
groceryrules

## Step 4: Evaluating model performance ----
# summary of grocery association rules
summary(groceryrules)

# look at the first three rules
inspect(groceryrules[1:3])

## Step 5: Improving model performance ----

# sorting grocery rules by lift
inspect(sort(groceryrules, by = "confidence")[1:5])

# finding subsets of rules containing any berry items
berryrules <- subset(groceryrules, items %in% "berries")
inspect(berryrules)

# writing the rules to a CSV file
write(groceryrules, file = "groceryrules.csv",
      sep = ",", quote = TRUE, row.names = FALSE)

# converting the rule set to a data frame
groceryrules_df <- as(groceryrules, "data.frame")
str(groceryrules_df)
