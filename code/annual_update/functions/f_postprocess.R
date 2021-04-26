# postprocess model output: failp
f_postprocess_failp <- function(l){
  bind_rows(map(m, ~.x[[1]]))
}

# postprocess model output: sp
f_postprocess_sp <- function(l, scen_names){
  map2(
    l, scen_names,
    ~.x[[2]] %>% 
      st_as_sf() %>% 
      mutate(scen_name = .y)
  ) 
}
