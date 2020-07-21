# ------------------------------------------------------------------------
# write all pages
# ------------------------------------------------------------------------

library(here)

# function to generate CCR index.htmls  
write_html_files <- function(x, y) {
  rmarkdown::render(
    input = here("jamstack", "01_index.Rmd"), 
    output_file = 
      paste0(
        site_dir, 
        selected_gsa, "/", 
        selected_decline, 
        "/index.html"
      ),
    params = list(selected_gsa = x, selected_decline = y)
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


# ------------------------------------------------------------------------
# write the index.html files
# ------------------------------------------------------------------------

mapply(write_html_files, gsa_names[1], decline_v[1])
