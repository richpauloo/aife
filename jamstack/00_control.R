# ------------------------------------------------------------------------
# write all pages
# ------------------------------------------------------------------------

library(here)
library(tidyverse)

# function to generate CCR index.htmls  
write_html_files <- function(x, y, w, z) {
  rmarkdown::render(
    input          = here("jamstack", "01_index.Rmd"), 
    output_dir     = paste0(site_dir, 
                            str_replace_all(x,"_","-"), 
                            "/", 
                            y),
    output_file    = "index.html",
    params         = list(selected_gsa = x, selected_decline = y,
                          gsa_names_full = w, decline_v_full = z),
    output_options = list(self_contained = FALSE, 
                          #lib_dir = "../../../libs/",
                          css     = "../../../etc/w3.css")
  )
}

# root dir for website
site_dir <- "/Users/richpauloo/Github/jbp/gsas/"

# gsa names
gsa_names <- 
  read_rds(here("code", "results", "gsa_ll.rds"))@data$gsp_name %>% 
  tolower() %>% 
  str_remove_all("[\\(\\)]") %>% 
  str_remove_all(" dm") %>% 
  str_replace_all(" |-", "_") 

# declines (from code/05_postprocess.R) 
decline_v <- c(0,10,20,30,40,50,100,150,200,250,300,400,500)

# add ALL and mt scenario to GSAs and declines
gsa_names <- c("ALL", gsa_names)
decline_v <- c("mt" , decline_v)

# full GSA names and GWL decline scenarios for the report title
gsa_names_full <- 
  c("ALL", 
    read_rds(here("code", "results", "gsa_ll.rds"))@data$gsp_name
  )
decline_v_full <- 
  c("Min Threshold", paste0(decline_v[2:length(decline_v)], " ft."))

gsa_names_url <- str_replace_all(gsa_names, "_", "-")


# ------------------------------------------------------------------------
# create directory structure
# ------------------------------------------------------------------------
unlink("~/Github/jbp/gsas", recursive = TRUE)
dir.create("~/Github/jbp/gsas")
for(i in 1:length(gsa_names)) {
  dir.create(paste0("~/Github/jbp/gsas/", gsa_names_url[i]))
  for(j in 1:length(decline_v)){
    dir.create(paste0("~/Github/jbp/gsas/", 
                      gsa_names_url[i], "/",
                      decline_v[j])
    )
  }
}


# ------------------------------------------------------------------------
# write the index.html files - takes about 30 min for ~500 files
# ------------------------------------------------------------------------
for(i in 1:2){#length(gsa_names)) {
  for(j in 1:2){#length(decline_v)) {
    write_html_files(gsa_names[i], decline_v[j],
                     gsa_names_full[i], decline_v_full[j])
    
    # move index_files to top level directory
    if(i == 1 & j == 1) {
      if( !dir.exists("~/Github/jbp/index_files") ) {
        dir.create("~/Github/jbp/index_files")
      }
      file.copy(paste0(site_dir, gsa_names_url[i], "/", decline_v[j], "/index_files"),
                paste0("~/Github/jbp/"), recursive = TRUE)
      lines <- read_lines(paste0(site_dir, gsa_names_url[i], "/", decline_v[j], "/index.html"))
      replace <- lines[str_which(lines, "X2019|X2040")]
      # write the ALL/mt index to the root directory
      lines %>% 
        str_replace_all('href="../../../etc/w3.css"', 'href="etc/w3.css"') %>% 
        write_lines("~/Github/jbp/index.html")
    }
    
    # find file, read it in, and change paths to reference the index_files that
    # were moved above. pay special attention to the hashed groundwater level id
    file_loc <-  paste0(site_dir, gsa_names_url[i], "/", decline_v[j], "/index.html")
    lines    <- read_lines(file_loc)
    lines[str_which(lines, "X2019|X2040")] <- replace
    lines %>% 
      str_replace_all('script src="index_files', 'script src="../../../index_files') %>%
      str_replace_all('link href="index_files',  'link href="../../../index_files') %>% 
      write_lines(file_loc)
    unlink(paste0(site_dir, gsa_names_url[i], "/", decline_v[j], "/index_files"),
           recursive=TRUE)
  }
}
# gsa_names[1]; decline_v[1]

