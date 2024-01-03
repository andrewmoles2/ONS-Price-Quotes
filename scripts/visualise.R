library(tidyverse)
library(ragg)
library(scales)
library(ggtext)
library(ggrepel)
library(data.table)

olive_oil <- read_csv("data/olive_oil_price.csv")

oil_region <- olive_oil |>
  group_by(item_desc, start_date, region) |>
  summarise(mean_price = weighted.mean(price, stratum_weight)) |>
  ungroup() |>
  group_by(item_desc, region) |>
  mutate(roll_mean_price = data.table::frollmean(x = mean_price, n = 6, align = "right")) |>
  ungroup()
oil_region

oil_region_plot <- ggplot(oil_region, aes(x = start_date, y = roll_mean_price, colour = region)) +
  geom_line(show.legend = FALSE, linewidth = 1.75, lineend = "round") + 
  geom_vline(xintercept = as.Date("2022-09-23"), linetype = 2, alpha = 0.5) +
  annotate(geom = "text", x =  as.Date("2022-08-20"), y = 1.05, family = "Avenir",
           label = str_wrap("Truss 'Growth Plan' mini-budget", width = 15), hjust = 1, size = 2.5) +
  facet_wrap(vars(region)) +
  scale_x_date(name="", limits=c(as.Date("2017-01-01"), as.Date("2024-06-01"))) +
  scale_y_continuous(name="Mean price observed", labels = dollar_format(prefix = "£"), limits = c(0,6)) +
  scale_colour_manual(values=c("#0e3724", "#008c5c", "#33b983", "#0050ae", "#9b54f3", "#bf8cfc",
                               "#551153", "#ac0000", "#c85b00", "#f98517", "grey10", "grey40")) +
  labs(title = "The price of olive oil is highest in <span style='color:#0050ae;'>North East England</span>",
       subtitle = "Average observed price for olive oil (500ml - 1l)\nRolling 5-month average",
       caption = "Data from ONS price quotes | Plot by Andrew Moles") +
  theme_minimal(base_family = "Avenir", base_size = 16) +
  theme(plot.title.position = "plot",
        plot.title = element_markdown())
oil_region_plot

ggsave("outputs/regional_olive_oil_prices.png", plot = oil_region_plot, device = ragg::agg_png,
       dpi = 320, width = 13, height = 9, bg = "#FAFAF7")



