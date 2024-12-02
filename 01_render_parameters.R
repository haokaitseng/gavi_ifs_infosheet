# File name: 01_render_parameters.R
# Authors: Hao-Kai Tseng, Anthony Nguyen
# Date: 30 Nov 2024
# Description: This R script is used to walk through the parameters set in the 
#   00_infosheet_quarto.qmd file, using a self-defined function to render English & French insheets
#   dwelling at specified folders
###################################


###################################
# 0. Setting up & reading data ####
###################################
rm(list=ls())

# libraries
packages_CRAN <- c("here", #if error then: unlink("C:/Users/hktseng/AppData/Local/Programs/R/R-4.4.1/library/00LOCK", recursive = TRUE)
                   "glue", "here","tidyverse", "readxl", "janitor")

for (i in packages_CRAN) {
  if (!i %in% rownames(installed.packages()) ) {
    install.packages(i, repos = "http://cran.us.r-project.org")} 
  }

lapply(packages_CRAN, require, character.only = TRUE)

# mapping file: to get English and French speaking countries
country_mapping <- read_excel("I:/40. Data/IFS_mapping-files/country-mapping.xlsx",# no need to setwd("I:/") since it will
                          sheet = "country_mapping") |> 
  clean_names()|>
  filter(!is.na(cofi_group))# drop Syria-TAR
  
#########################
# 1. Render Function ####
#########################
## (1) a rendering function ####
# Also copy and move the file to wanted folder
# For parameters like ghed_year, projected_year, and jrf_year, they are not used as inputs here, 
# since there are decided as defaults in quarto file
# no need for french names inputs here because it will be applied in section 3. rendering

func_render_pdfs <- function(
    current_iso3, # input parameters needs to match the params in the quarto file
    current_country_en,
    lang, 
    current_year) { 
  
  output_pdf <- glue::glue("Infosheet_{current_year}_{current_country_en}_{current_iso3}_{lang}.pdf")# the initial document rendered in the root directory
  
  #setwd(here::here(""))# set directory to where the quarto file lives, i.e. 41. Analytics/InfoSheets re-design/2024/
  
  quarto::quarto_render(
    input = '00_infosheet_quarto.qmd',  # specify Quarto file
    output_file = output_pdf, #paste0(current_iso3, '_infosheet_en.pdf'),   # output filename
    execute_params = list(current_iso3 = current_iso3, # Parameters to pass
                          current_country_en = current_country_en,
                          lang = lang,
                          current_year = current_year # for file name 
                          # ghed_year = ghed_year, 
                          # projected_year = projected_year,
                          # jrf_year = jrf_year 
                          )  
    )
  
# copy and move the pdf document to desired subfolder by languages:
  final_directory_en <- here::here("output_infosheet", "English", output_pdf) 
  final_directory_fr <- here::here("output_infosheet", "French", output_pdf)
  
  file.copy(from = output_pdf,
            to =  ifelse(lang == "en",
                         final_directory_en,
                         final_directory_fr) 
            )
  
  file.remove(output_pdf) #remove the unwanted pdf in the folder where quarto file lives
  
  #setwd(here::here()); getwd() # the directroy of qmd unchanged
}

#################################################
# 1-2. pilot testing for rendering single pdf####
#################################################
func_render_pdfs("BEN", "Benin","en", 2024)

func_render_pdfs("MDG", "Madagascar","fr", 2024)

func_render_pdfs("ERI","Eritrea","en", 2024)

# unprinted countries #due to insufficient projection years, all sorted except for Korea
func_render_pdfs("AFG","Afghanistan","en", 2024)
func_render_pdfs("CAF","CAR","en", 2024)
func_render_pdfs("TCD","Chad","en", 2024)
func_render_pdfs("PRK","Korea DPR","en", 2024)#failed, due to no projections for PRK for now
func_render_pdfs("MMR","Myanmar","en", 2024)
func_render_pdfs("SOM","Somalia","en", 2024)

# FY countries
func_render_pdfs("PAK","Pakistan","en", 2024)
func_render_pdfs("ETH","Ethiopia","en", 2024)
func_render_pdfs("","","en", 2024)
func_render_pdfs("","","en", 2024)

#########################
# 2. English for all #### 
#########################
#vectors_current_iso3 <- c("BGD","BEN") #test

vectors_iso3_en <- country_mapping|>
  filter(cofi_group!="Fully self-financing")|>
  pull(iso3)

vectors_countryname_en <- country_mapping|>
  filter(cofi_group!="Fully self-financing")|>
  pull(country_name_ifs)

# iterating the loop
for (i in seq_along(vectors_iso3_en) ) {
  
  i_iso3 <- vectors_iso3_en[i]
  i_countryname <- vectors_countryname_en[i]
  
  tryCatch({
    func_render_pdfs(i_iso3, 
                     i_countryname,
                     "en", 
                     2024)
  }, error = function(e) {
    message(paste("Error in rendering report for", i, ":", e))
  })
}


#######################################
# 3. French for selected countries #### 
#######################################

vectors_iso3_fr <- country_mapping|>
  filter(cofi_group!="Fully self-financing",
         !is.na(country_name_fr))|> #drop non-French speaking countries
  pull(iso3)

vectors_countryname_fr <- country_mapping|>
  filter(cofi_group!="Fully self-financing",
         !is.na(country_name_fr))|>
  pull(country_name_fr)

# iterating the loop
for (i in seq_along(vectors_iso3_fr) ) {
  
  i_iso3 <- vectors_iso3_fr[i]
  i_countryname <- vectors_countryname_fr[i]
  
  tryCatch({
    func_render_pdfs(i_iso3, 
                     i_countryname,
                     "fr", #French!
                     2024)
  }, error = function(e) {
    message(paste("Error in rendering report for", i, ":", e))
  })
}

