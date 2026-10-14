# ==============================================================================
# 0. SETUP
# ==============================================================================

library(tidyverse)
library(nflfastR)
library(nflreadr)

source("_global_fns.R")

output_ext <- 'games/2026_05_CHI_GB/charts'

# ==============================================================================
# 1. DATA
# ==============================================================================

# Raw data
team <- load_team_stats()
pbp <- load_pbp()
qbr <- load_espn_qbr()
ngs <- load_nextgen_stats()
pfr <- load_pfr_advstats()

# Dictionaries
pbp_dict <- dictionary_pbp

# ==============================================================================
# 2. GIVE IT A TRY
# ==============================================================================
brs <- pbp |>
  filter(game_id == '2026_05_CHI_GB')

pack_green <- teams_colors_logos$team_color[
  teams_colors_logos$team_abbr == 'GB'
]
bears_orange <- teams_colors_logos$team_color2[
  teams_colors_logos$team_abbr == 'CHI'
]

prep <- brs |>
  mutate(
    play = row_number(),
    wp = vegas_home_wp
  )

first_flip <- min(prep$play[prep$wp > 0.5])
flip_label <- prep |>
  filter(play == first_flip) |>
  mutate(
    label = paste0(
      "Packers lead Vegas odds for the first time:\n",
      qtr,
      'st Quarter - ',
      time
    )
  ) |>
  pull(label)

prep |>
  ggplot(aes(x = play)) +
  geom_ribbon(aes(ymin = 0.5, ymax = pmax(wp, 0.5)), fill = pack_green) +
  geom_ribbon(aes(ymin = pmin(wp, 0.5), ymax = 0.5), fill = bears_orange) +
  geom_hline(yintercept = 0.5, linewidth = 0.2) +
  geom_vline(xintercept = first_flip, linewidth = 0.2) +
  annotate(
    'text',
    x = first_flip + 2,
    y = 0.9,
    label = flip_label,
    hjust = 0,
    family = font,
    color = 'gray30',
    size = 2.5
  ) +

  scale_y_continuous(
    limits = c(0, 1),
    breaks = seq(0, 1, 0.25),
    labels = \(x) scales::percent(pmax(x, 1 - x))
  ) +
  annotate(
    'text',
    x = 0,
    y = 0.85,
    label = "Packers win probability",
    hjust = 0.5,
    family = font,
    color = pack_green,
    angle = 90,
    size = 2.5
  ) +
  annotate(
    'text',
    x = 0,
    y = 0.15,
    label = "Bears win probability",
    hjust = 0.5,
    family = font,
    color = bears_orange,
    angle = 90,
    size = 2.5
  ) +
  labs(
    x = 'Play',
    title = 'Packers dominated from early in the game',
    subtitle = 'Win probability during game'
  )

save_chart(file.path(output_ext, 'win_prob.png'))
