library(dplyr)
library(dlbaR)
library(stringr)

cases <- sfimport("inputs/2024-06-12_cases.csv")


# Group the data frame by the 'group' variable and concatenate 'value' into a list
result <- cases |> 
  group_by(ProjectBatchBatchID) |> 
  summarise(
    address_list = str_c(Address, collapse = ", "),
    concatenated_data = str_c(ProjectBatchProjectSummary, " - Addresses Removed [", address_list, "]")
    )
