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
# Data Exploration of Bugs Table from the Database
##################################################
bugs_df <- tbl(con, "bugs")

#for quick view of the datatypes and the structure of data
glimpse(bugs_df)

# Converting `bugs_df` to `dataframe`
bugs_df <- as.data.frame(bugs_df)

#converting the required fields in the correct datatype format
bugs_df <- bugs_df %>%
    mutate_at(vars("creation_ts", "delta_ts", "lastdiffed", "deadline"), as.Date)

# Taking the columns which are useful
bugs_df <- bugs_df %>%
    select("bug_id", "bug_severity", "bug_status", "creation_ts", "delta_ts",
           "op_sys", "priority", "resolution", "component_id",
           "version", "lastdiffed", "deadline")

#for quick view of the datatypes and the structure of data
glimpse(bugs_df)

#showing the `datatable`
datatable(head(bugs_df, 10), options = list(scrollX = TRUE))

################
# Visualizations
################

# Plotting the Time Series graph with the bug_id and creation_ts
bug_id <- bugs_df$bug_id
creation <- bugs_df$creation_ts
data <- data.frame(bug_id, creation)
fig1 <- plot_ly(data,
                x = ~creation,
                y = ~bug_id,
                type = 'scatter',
                mode = 'markers')
fig1

# Plotting the Bar graph and adding Trace of Time-Series graph with bug_id and creation_ts to see the spread
fig1 <- plot_ly(data,
                x = ~creation,
                y = ~bug_id,
                type = 'bar',
                name = "bug_creation bar")
fig1 <- fig1 %>%
    add_trace(fig1,
              type = 'scatter',
              mode='lines+markers',
              name = "bug_creation Time_series")
fig1

# Plotting the Time Series graph with the bug_id and delta_ts
delta <- bugs_df$delta_ts
data <- data.frame(bug_id, delta)
fig2 <- plot_ly(data,
                x = ~delta,
                y = ~bug_id,
                type = 'scatter',
                mode = 'markers')
fig2

# Plotting the Time Series graph with the bug_id and deadline
deadline <- bugs_df$deadline
data <- data.frame(bug_id, deadline)
fig3 <- plot_ly(data,
                y = ~bug_id,
                x = ~deadline,
                type = 'scatter',
                mode = 'markers')
fig3

# Plotting bar graph with bug_id and resolution
resolution <- bugs_df$resolution
data <- data.frame(bug_id, resolution)
fig4 <- plot_ly(data,
                x = ~resolution,
                y = ~bug_id,
                type = 'bar')
fig4

# Plotting bar graph with bug_id and bug_status
bug_status <- bugs_df$bug_status
data <- data.frame(bug_id, bug_status)
fig5 <- plot_ly(data,
                x = ~bug_status,
                y = ~bug_id,
                type = 'bar')
fig5

# Plotting bar graph with bug_id and bug_severity
bug_severity <- bugs_df$bug_severity
data <- data.frame(bug_id, bug_severity)
fig6 <- plot_ly(data,
                x = ~bug_severity,
                y = ~bug_id,
                type = 'bar')
fig6
