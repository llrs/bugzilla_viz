# From: contributors_plots chunk modified:
library("ggtext")
library("ggrepel")
background <- "white"
ggplot(act_o) +
    geom_point(aes(open, comment, shape = r_core), col = "blue") +
    labs(x = "Bug reports opened", y = "Comments", title = "Contributors") +
    scale_color_viridis_c() +
    scale_y_log10() +
    scale_x_continuous(expand = expansion(add = c(1, 1))) +
    geom_text_repel(aes(open, comment, label = ifelse(r_core == "yes", "R core", "user")), data = . %>% filter(., comment >= 1)) +
    geom_richtext(data = data.frame(open = 40, comment = 50, label = "<span style='color:blue;font-size:15pt'>**You?**</span>", size = 20),
                  mapping = aes(x = open, y = comment, label = label), fill = background) +
    guides(fill = "none", shape = "none", col = "none") +
    theme(panel.background = element_rect(fill = background, linetype = "blank"), # bg of the panel
          plot.background = element_rect(fill = background, linetype = "blank"),
          axis.text = element_text(colour = "black"))
ggsave(filename = "~/Downloads/R_contributors3_bg2.png", width = 1500, height=500, units = "px", device = "png")


