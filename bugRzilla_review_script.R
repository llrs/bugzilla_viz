# loading packages
library(dplyr)
library(dbplyr)
library(RMySQL)
library(DBI)
library(tibble)
library(DT)
library(tidyverse)
library(lubridate)

# Connect bugRzilla SQL Database with R
# connecting MySQL with R
con <- dbConnect(
    MySQL(),
    dbname='bugRzilla', # change the database name to your database name
    username='root', # change the username to your username
    password='1204', # update your password
    host='localhost',
    port=3306)
#  Accessing Tables from the Database
src_dbi(con)


# View the "bugs" tables from the database
bugs_db <- tbl(con, "bugs")
bugs_data <- bugs_db %>%
    select(everything())

datatable(as.data.frame(bugs_data), options = list(scrollY = "645px"),
          class = "display", fillContainer = T, width = NULL,
          height = NULL, style = "default", editable = FALSE)

# Data Wrangling
bugs <- bugs_db %>%
    mutate_all(as.character) %>%  # converting all columns data types to "char"
    as_tibble %>% # must be a data frame for na_if to work
    na_if("") %>% #replace empty strings with NA
    # converting all "char" data types to int leaving the "char" datatype
    mutate_at(vars(-one_of(c("bug_severity", "bug_status", "short_desc",
                             "priority", "rep_platform", "bug_file_loc",
                             "lastdiffed", "op_sys", "version",
                             "resolution", "target_milestone", "creation_ts",
                             "delta_ts", "status_whiteboard", "deadline"))), as.integer) %>%
    # converting all columns data types to "Date" leaving the "char" and "int" datatype
    mutate_at(vars(-one_of(c("bug_severity", "bug_status", "short_desc",
                             "bug_file_loc", "priority", "rep_platform",
                             "version", "resolution", "target_milestone",
                             "bug_id", "assigned_to", "op_sys",
                             "status_whiteboard", "product_id", "reporter",
                             "component_id", "qa_contact", "votes",
                             "everconfirmed", "reporter_accessible",
                             "cclist_accessible", "estimated_time",
                             "remaining_time"))), as.Date)

# removing null or empty columns
bugs <- bugs %>%
    select(-c("target_milestone", "qa_contact", "status_whiteboard",
              "remaining_time", "remaining_time",  "estimated_time"))

bugs <- bugs %>%
    select(everything())
datatable(as.data.frame(bugs), options = list(scrollY = "645px"),
          class = "display", fillContainer = T, width = NULL,
          height = NULL, style = "default", editable = FALSE)


# View the "attachments" Table from the database
attach_df <- attachments_db %>%
    as_tibble %>% # must be a data frame for na_if to work
    na_if("") %>% #replace empty strings with NA
    # converting all columns data types to "Date" leaving the "char" and "int" datatype
    mutate_at(vars(-one_of(c("attach_id", "bug_id", "description", "mimetype",
                             "ispatch", "filename", "submitter_id",
                             "isobsolete", "isprivate"))), as.Date)

attach_df <- attach_df %>%
    select(-c("isprivate"))
attach_df <- attach_df %>%
    select(everything())

datatable(as.data.frame(attach_df), options = list(scrollY = "565px"),
          class = "display", fillContainer = T, width = NULL,
          height = NULL, style = "default", editable = FALSE)


# View the "bugs_activity" Table from the database
bugs_activity_db <- tbl(con, "bugs_activity")
bugs_activity_data <- bugs_activity_db %>%
    select(everything())

datatable(as.data.frame(bugs_activity_data), options = list(scrollY = "543px"),
          class = "display", fillContainer = T, width = NULL,
          height = NULL, style = "default", editable = FALSE)

# Data Wrangling
bugs_act <- bugs_activity_db %>%
    as_tibble %>% # must be a data frame for na_if to work
    na_if("") %>% #replace empty strings with NA
    mutate_at(vars(-one_of(c("attach_id", "bug_id", "who", "fieldid", "added",
                             "comment_id", "removed", "id"))), as.Date)

bugs_act <- bugs_act %>%
    select(everything())
datatable(as.data.frame(bugs_act), options = list(scrollY = "543px"),
          class = "display", fillContainer = T, width = NULL,
          height = NULL, style = "default", editable = FALSE)
