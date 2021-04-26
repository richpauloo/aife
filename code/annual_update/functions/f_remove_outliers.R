# helper to replace outliers 
f_remove_outliers <- function(x) {
  qnt <- quantile(x$wse_ft, probs = c(.10, .90), na.rm = TRUE)
  x   <- x[x$wse_ft >= qnt[1] & x$wse_ft <= qnt[2], ] 
  return(x)
}