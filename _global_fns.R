# ==============================================================================
# ggplot2 theme
# ==============================================================================
font <- 'IBM Plex Sans'

theme_mb <- theme(
  panel.background = element_rect(fill = 'white', color = 'white'),
  plot.background = element_rect(fill = 'white', color = 'white'),
  panel.grid.major = element_line(linewidth = 0.2, color = 'gray95'),
  axis.ticks = element_blank(),
  plot.title.position = 'plot',
  text = element_text(size = 8, color = 'gray30', family = font),
  plot.title = element_text(
    size = 11,
    face = 'bold',
    color = 'black',
    hjust = 0,
    margin = margin(b = 5)
  ),
  plot.subtitle = element_text(margin = margin(b = 9), hjust = 0),
  axis.text = element_text(color = 'gray30')
)


theme_set(theme_mb)

# ==============================================================================
# saving fn
# ==============================================================================

save_chart <- function(
  file,
  chart = ggplot2::last_plot(),
  width = 8,
  height = 5
) {
  ggplot2::ggsave(
    filename = file,
    plot = chart,
    width = width,
    height = height,
    units = "in",
    dpi = 350,
    device = ragg::agg_png,
    bg = "white"
  )
  invisible(file)
}
