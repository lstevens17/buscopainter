#!/usr/bin/env Rscript
library(tidyverse)

# get args
args = commandArgs(trailingOnly=TRUE)
locations <- read_tsv(args[1])
window_size = 1000000

count <- length(unique(sort(locations$status)))

pal <-c("grey40", rainbow(count-1)) 

p <- filter(locations) %>%
  group_by(query_chr) %>%
  mutate(gene_count = n(), max_position = max(position)) %>%
  filter(gene_count > 1) %>%
  mutate(ints = as.numeric(as.character(cut(position,
                                            breaks = seq(0, max(position), window_size),
                                            labels = seq(window_size, max(position), window_size)))),
         ints = ifelse(is.na(ints), max(ints, na.rm = T) + window_size, ints)) %>%
  count(ints, status, query_chr) %>%
  rowwise %>%
  mutate(query_chr=fct_reorder(query_chr, status)) %>%
  ungroup() %>%
  ggplot(aes(fill=status, y=n, x=ints-window_size)) +
  scale_fill_manual(values=pal) + 
  facet_grid(query_chr ~ ., scales = "free") +
  geom_bar(position="stack", stat="identity") + 
  theme_classic() + 
  xlab("Chromosome position (Mb)") + ylab("BUSCO count (n)") + 
  theme(panel.border = element_blank(), text = element_text(size=10), strip.text.y = element_text(angle = 0))

ggsave(paste(args[1], "_buscopainter.pdf", sep = ""), plot = p, width = 20, height = 24, units = "cm", device = "pdf")
ggsave(paste(args[1], "_buscopainter.png", sep = ""), plot = p, width = 20, height = 24, units = "cm", device = "png")





