# loading packages
library(dplyr)
library(dbplyr)
library(RMySQL)
library(DBI)
library(DT)
library(tidyverse)
library(ggplot2)
library(plotly)

#######################################
# Connect bugRzilla SQL Database with R
#######################################

# Connecting R with MySQL
con <- dbConnect(
    MySQL(),
    dbname='bugRzilla', # change the database name to your database name
    username='root', # change the username to your username
    password='1204', # update your password
    host='localhost',
    port=3306)

#  Accessing Tables names from the Database
DBI::dbListTables(con)

##################################################
# Data Exploartion of Bugs Table from the Database
##################################################
bugs_df <- tbl(con, "bugs")

# View the "bugs" tables from the database
bugs_db <- tbl(con, "bugs")
bugs_data <- bugs_db %>%
    select(everything())

# Converting `bugs_df` to `dataframe` and showing the `datatable`
bugs_df <- as.data.frame(bugs_df)
datatable(bugs_df, options = list(scrollX = TRUE,
                                  pageLength = 5, lengthMenu = c(5, 10, 50, 100)))

#for quick view of the datatypes and the structure of data
glimpse(bugs_df)

#converting the required fields in the correct datatype format
bugs_df <- bugs_df %>%
    mutate_at(vars("creation_ts", "delta_ts", "lastdiffed", "deadline"), as.Date)

glimpse(bugs_df)

################
# Visualizations
################

# Line plot for creation_ts, delta_ts, deadline
creation <- bugs_df$creation_ts
delta <- bugs_df$delta_ts
deadline <- bugs_df$deadline
last_diffed <- bugs_df$lastdiffed
bug_id <- bugs_df$bug_id
component_id <- bugs_df$component_id
resolution <- bugs_df$resolution


data <- data.frame(bug_id, creation)
fig <- plot_ly(data, y = ~bug_id, x = ~creation, type = 'scatter', mode = 'markers')
fig

data <- data.frame(bug_id, delta)
fig <- plot_ly(data, y = ~bug_id, x = ~delta, type = 'scatter', mode = 'markers')
fig

data <- data.frame(bug_id, deadline)
fig <- plot_ly(data, y = ~bug_id, x = ~deadline, type = 'scatter', mode = 'markers')
fig

data <- data.frame(bug_id, resolution)
fig <- plot_ly(data, x = ~resolution, y = ~bug_id, name = 'creation', type = 'bar')
fig
