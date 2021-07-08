options(warn=-1)
# loading packages
library(dplyr)
library(ggplot2)
library(dbplyr)
library(DBI)
library(tidyverse)
library(lubridate)
library(tibble)

# Connect bugRzilla SQL Database with R
# connecting MySQL with R
con <- dbConnect(
    RMySQL::MySQL(),
    dbname='bugRzilla',
    username='root',
    password='1204',
    host='localhost',
    port=3306)
#  Accessing Tables from the Database
src_dbi(con)


# View the "bugs" tables from the database
bugs_db <- tbl(con, "bugs")
bugs_db %>%
    select(everything())

# Data Wrangling
bugs <- bugs_db %>%
    mutate_all(as.character) %>%
    as_tibble %>% # must be a data frame for na_if to work
    na_if("") %>% #replace empty strings with NA
    # converting all "char" data types to required data types
    mutate_at(vars(-one_of(c("bug_severity", "bug_status", "short_desc",
                             "priority", "rep_platform", "bug_file_loc", "lastdiffed",
                             "op_sys", "version", "resolution", "target_milestone",
                             "creation_ts", "delta_ts", "status_whiteboard"))), as.integer) %>%
    mutate_at(vars(-one_of(c("bug_severity", "bug_status", "short_desc",
                          "bug_file_loc", "priority", "rep_platform", "version", "resolution",
                          "target_milestone", "bug_id", "assigned_to", "op_sys", "status_whiteboard",
                          "product_id", "reporter", "component_id", "qa_contact",
                          "votes","everconfirmed", "reporter_accessible",
                          "cclist_accessible", "estimated_time",
                          "remaining_time"))), as.Date)

head(bugs)


# View the "attachments" Table from the database
attachments_db <- tbl(con, "attachments")
attachments_db %>%
    select(everything())

# Data Wrangling
attach_df <- attachments_db %>%
    as_tibble %>% # must be a data frame for na_if to work
    na_if("") %>% #replace empty strings with NA
    mutate_at(vars(-one_of(c("attach_id", "bug_id", "description", "mimetype", "ispatch", "filename", "submitter_id", "isobsolete", "isprivate"))), as.Date)

head(attach_df)


# View the "bugs_activity" Table from the database
bugs_activity_db <- tbl(con, "bugs_activity")
bugs_activity_db %>%
    select(everything())

# Data Wrangling
bugs_act <- bugs_activity_db %>%
    as_tibble %>% # must be a data frame for na_if to work
    na_if("") %>% #replace empty strings with NA
    mutate_at(vars(-one_of(c("attach_id", "bug_id", "who", "fieldid", "added", "comment_id", "removed", "id"))), as.Date)

head(bugs_act)
