# Step 1 convert htmlwidget to character representation of HTML components
as.character.htmlwidget <- function(x, ...) {
  htmltools::HTML(
    htmltools:::as.character.shiny.tag.list(
      htmlwidgets:::as.tags.htmlwidget(
        x
      ),
      ...
    )
  )
}

add_deps <- function(dtbl, name, pkg = name) {
  tagList(
    dtbl,
    htmlwidgets::getDependency(name, pkg)
  )
}
