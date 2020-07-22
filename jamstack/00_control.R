# ------------------------------------------------------------------------
# write all pages
# ------------------------------------------------------------------------

library(here)
library(tidyverse)

# function to generate CCR index.htmls  
write_html_files <- function(x, y) {
  rmarkdown::render(
    input          = here("jamstack", "01_index.Rmd"), 
    output_dir     = paste0(site_dir, x, "/", y),
    output_file    = "index.html",
    params         = list(selected_gsa = x, selected_decline = y),
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


# ------------------------------------------------------------------------
# create directory structure
# ------------------------------------------------------------------------
if(!dir.exists("~/Github/jbp/gsas")){
  dir.create("~/Github/jbp/gsas")
  for(i in 1:length(gsa_names)) {
    dir.create(paste0("~/Github/jbp/gsas/", gsa_names[i]))
    for(j in 1:length(decline_v)){
      dir.create(paste0("~/Github/jbp/gsas/", gsa_names[i], "/", decline_v[j]))
    }
  }
}


# ------------------------------------------------------------------------
# write the index.html files
# ------------------------------------------------------------------------
for(i in 1:2){#:length(gsa_names)) {
  for(j in 1:2){#:length(decline_v)) {
    write_html_files(gsa_names[i], decline_v[j])
    
    # move index_files to top level directory
    if(i == 1 & j == 1) {
      if( !dir.exists("~/Github/jbp/index_files") ) {
        dir.create("~/Github/jbp/index_files")
      }
      file.copy(paste0(site_dir, gsa_names[i], "/", decline_v[j], "/index_files"),
                paste0("~/Github/jbp/"), recursive = TRUE)
      lines <- read_lines(paste0(site_dir, gsa_names[i], "/", decline_v[j], "/index.html"))
      replace <- lines[str_which(lines, "X2019|X2040")]
      # write the ALL/mt index to the root directory
      lines %>% 
        str_replace_all('href="../../../etc/w3.css"', 'href="etc/w3.css"') %>% 
        write_lines("~/Github/jbp/index.html")
    }
    
    # find file, read it in, and change paths to reference the index_files that
    # were moved above. pay special attention to the hashed groundwater level id
    file_loc <-  paste0(site_dir, gsa_names[i], "/", decline_v[j], "/index.html")
    lines    <- read_lines(file_loc)
    lines[str_which(lines, "X2019|X2040")] <- replace
    lines %>% 
      str_replace_all('script src="index_files', 'script src="../../../index_files') %>%
      str_replace_all('link href="index_files',  'link href="../../../index_files') %>% 
      write_lines(file_loc)
    unlink(paste0(site_dir, gsa_names[i], "/", decline_v[j], "/index_files"),
           recursive=TRUE)
  }
}
# gsa_names[1]; decline_v[1]
