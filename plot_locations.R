#!/usr/bin/env Rscript
library(tidyverse)

# get args
args = commandArgs(trailingOnly=TRUE)
locations <- read_tsv(args[1])
window_size = 1000000

p <- filter(locations) %>%
  group_by(query_chr) %>%
  mutate(gene_count = n(), max_position = max(position)) %>%
  filter(gene_count > 15) %>%
  mutate(ints = as.numeric(as.character(cut(position,
                                            breaks = seq(0, max(position), window_size),
                                            labels = seq(window_size, max(position), window_size)))),
         ints = ifelse(is.na(ints), max(ints, na.rm = T) + window_size, ints)) %>%
  count(ints, assigned_chr, query_chr) %>%
  ungroup() %>%
  ggplot(aes(fill=assigned_chr, y=n, x=ints-window_size)) + 
  facet_grid(query_chr ~ ., scales = "free") +
  geom_bar(position="stack", stat="identity") + 
  theme_classic() + 
  xlab("Chromosome position (Mb)") + ylab("BUSCO count (n)") + 
  theme(panel.border = element_blank(), text = element_text(size=10), strip.text.y = element_text(angle = 0))

ggsave("buscopainter.pdf", plot = p, width = 20, height = 24, units = "cm", device = "pdf")


  
        

