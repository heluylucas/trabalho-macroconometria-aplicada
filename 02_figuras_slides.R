# 02_figuras_slides.R -------------------------------------------------------
# Regera as figuras de IRF em formato de slide (largas e baixas, 4:3), lendo os
# CSVs gravados por 01_analise_principal.Rmd. Saída em PDF vetorial (figs/),
# que fica nítido no Beamer.

library(dplyr); library(readr); library(ggplot2)

dir.create("figs", showWarnings = FALSE)

AZUL <- "#265AA6"; VERM <- "#C12A2A"

tema_slide <- theme_minimal(base_size = 10) +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major = element_line(colour = "grey92", linewidth = 0.3),
        plot.title = element_blank(),
        strip.text = element_text(size = 9.5, margin = margin(b = 3)),
        axis.title = element_text(size = 9, colour = "grey30"),
        axis.text = element_text(size = 8, colour = "grey30"),
        legend.position = "bottom",
        legend.margin = margin(t = -4))

painel <- function(df, ordem, ncol = 3, cores = c(AZUL, VERM), ylab = "%") {
  df |>
    mutate(variavel = factor(variavel, levels = ordem)) |>
    ggplot(aes(h / 12)) +
    geom_hline(yintercept = 0, linewidth = 0.3, colour = "grey20") +
    geom_ribbon(aes(ymin = q16, ymax = q84, fill = modelo), alpha = 0.18) +
    geom_line(aes(y = q50, colour = modelo), linewidth = 0.7) +
    facet_wrap(~ variavel, scales = "free_y", ncol = ncol) +
    scale_colour_manual(values = cores) +
    scale_fill_manual(values = cores) +
    labs(x = "anos após o choque", y = ylab, colour = NULL, fill = NULL) +
    tema_slide
}

g_dados <- read_csv("dados/dados_canada.csv", show_col_types = FALSE) |>
  filter(date >= as.Date("1997-01-01"), date <= as.Date("2019-12-01")) |>
  transmute(date,
            pib = 100 * log(pib), cpi = 100 * log(cpi), bcpi = 100 * log(bcpi),
            overnight, m1 = 100 * log(m1), cadusd = 100 * log(cadusd)) |>
  pivot_longer(-date) |>
  mutate(name = factor(name, levels = vars_ca, labels = rot_ca)) |>
  ggplot(aes(date, value)) +
  geom_line(colour = "#265AA6", linewidth = 0.4) +
  facet_wrap(~ name, scales = "free_y", ncol = 3) +
  labs(x = NULL, y = NULL) +
  theme_minimal(base_size = 10) +
  theme(panel.grid.minor = element_blank(),
        strip.text = element_text(size = 9.5))

ggsave("output/fig_dados_canada.png", g_dados, width = 10, height = 4.6, dpi = 300)

# EUA ----------------------------------------------------------------------
read_csv("output/irf_replicacao_uhlig.csv", show_col_types = FALSE) |>
  painel(c("PIB real", "Deflator do PIB", "Fed funds",
           "Commodities", "Reservas não emprestadas", "Reservas totais")) |>
  ggsave(filename = "figs/fig_replicacao_uhlig_slide.pdf", width = 10.2, height = 5.0)

# Canadá, sistema completo --------------------------------------------------
ca <- read_csv("output/irf_canada_baseline_cholesky.csv", show_col_types = FALSE)
ordem_ca <- c("PIB real", "CPI", "Taxa overnight",
              "BCPI (commodities)", "M1+", "CAD/USD (alta = depreciação)")
ggsave("figs/fig_canada_completo_slide.pdf", painel(ca, ordem_ca),
       width = 10.2, height = 5.0)

vars_ca <- c("pib", "cpi", "bcpi", "overnight", "m1", "cadusd")
rot_ca  <- c("PIB real", "CPI", "BCPI (commodities)", "Taxa overnight", "M1+",
             "CAD/USD (alta = depreciação)")

g_dados <- read_csv("dados/dados_canada.csv", show_col_types = FALSE) |>
  filter(date >= as.Date("1997-01-01"), date <= as.Date("2019-12-01")) |>
  transmute(date,
            pib = 100 * log(pib), cpi = 100 * log(cpi), bcpi = 100 * log(bcpi),
            overnight, m1 = 100 * log(m1), cadusd = 100 * log(cadusd)) |>
  pivot_longer(-date) |>
  mutate(name = factor(name, levels = vars_ca, labels = rot_ca)) |>
  ggplot(aes(date, value)) +
  geom_line(colour = "#265AA6", linewidth = 0.4) +
  facet_wrap(~ name, scales = "free_y", ncol = 3) +
  labs(x = NULL, y = NULL) +
  theme_minimal(base_size = 10) +
  theme(panel.grid.minor = element_blank(),
        strip.text = element_text(size = 9.5))

ggsave("output/fig_dados_canada.png", g_dados, width = 10, height = 4.6, dpi = 300)

# Canadá, foco: PIB e taxa overnight ---------------------------------------
ca |>
  filter(variavel %in% c("PIB real", "Taxa overnight")) |>
  painel(c("PIB real", "Taxa overnight"), ncol = 2) |>
  ggsave(filename = "figs/fig_canada_foco_slide.pdf", width = 10.2, height = 4.1)

# Câmbio --------------------------------------------------------------------
if (file.exists("output/irf_canada_cambio.csv")) {
  read_csv("output/irf_canada_cambio.csv", show_col_types = FALSE) |>
    painel(ordem_ca) |>
    ggsave(filename = "figs/fig_canada_cambio_slide.pdf", width = 10.2, height = 5.0)
}

# Defasagens ----------------------------------------------------------------
if (file.exists("output/irf_canada_lags.csv")) {
  read_csv("output/irf_canada_lags.csv", show_col_types = FALSE) |>
    painel("PIB real", ncol = 1) |>
    ggsave(filename = "figs/fig_canada_lags_slide.pdf", width = 8.6, height = 3.9)
}

# Robustez ------------------------------------------------------------------
rob <- read_csv("output/irf_robustez_pib.csv", show_col_types = FALSE)
g_rob <- rob |>
  mutate(modelo = factor(modelo, levels = unique(modelo))) |>
  ggplot(aes(h / 12)) +
  geom_hline(yintercept = 0, linewidth = 0.3, colour = "grey20") +
  geom_ribbon(aes(ymin = q16, ymax = q84), fill = AZUL, alpha = 0.18) +
  geom_line(aes(y = q50), colour = AZUL, linewidth = 0.7) +
  facet_wrap(~ modelo, ncol = 4) +
  labs(x = "anos após o choque", y = "%") +
  tema_slide
ggsave("figs/fig_robustez_pib_slide.pdf", g_rob, width = 10.4, height = 4.8)
