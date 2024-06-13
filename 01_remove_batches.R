library(dplyr)
library(dlbaR)
library(stringr)


#create list of dir names
list_dirs_to_create <- c(
  here::here('input'),
  here::here('enable')
)

fn_create_dirs <- function(dirs_list=list_dirs_to_create) {
  #check if all dirs exist, if so print to console
  if(isTRUE(all(dir.exists(list_dirs_to_create)))) { 
    print("Directories Exist")
  } else { #if any dirs are missing
    for(i in 1:length(list_dirs_to_create)) { #create
      dir.create(list_dirs_to_create[i], showWarnings=F)
    }
  }
}

fn_create_dirs(list_dirs_to_create)

#add latest function file

cases <- dlbaR::latest_file("*cases.csv","input/")

cases <- sfimport(cases)


# Group the data frame by the 'group' variable and concatenate 'value' into a list
batch <- cases |> 
  group_by(ProjectBatchBatchID) |> 
  reframe(
    address_list = str_c(Address, collapse = ", "),
    ProjectSummary = str_c(ProjectBatchProjectSummary, " - Addresses Removed ",Sys.Date()," [", address_list, "]")
    )

batch <- unique(batch)


batch <- batch |> select(ProjectBatchBatchID, ProjectSummary)
cases$project_batch <- ""
cases$transfer_case <- "DLBA - Intake Review"
cases <- cases |> select(CaseID, project_batch, transfer_case)

writexl::write_xlsx(batch, paste0("enable/", Sys.Date(), "_update_batch_summary.xlsx"))
writexl::write_xlsx(cases, paste0("enable/", Sys.Date(), "_update_cases.xlsx"))


# openxlsx::write.xlsx(
#   list(update_batch = batch, update_case = cases),
#   here::here("enable/", paste0(Sys.Date(), "_update_batch_summary.xlsx")),tableStyle = "TableStyleMedium4", asTable = T)
