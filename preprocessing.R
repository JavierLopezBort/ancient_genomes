library("tidyverse")

# Load stat_table
raw_table <- read_csv(file = "raw_table.csv")
# Make it a dataframe

# Show the first ten simulations
head(raw_table, n = 10)

table <- raw_table |>
  mutate(Damage = case_when(
           Damage == "dnone" ~ "none",
           Damage == "dsingle" ~ "single",
           Damage == "ddmid" ~ "mid",
           Damage == "ddhigh" ~ "high"),
         Length = as.numeric(str_sub(Length, 2)),
         Rate = as.numeric(str_sub(Rate, 2)))

table$Rate <- format(table$Rate, scientific = FALSE)
table$Rate <- sub("\\.?0*$", "", table$Rate)
table$Gen <- factor(table$Gen)
table$Length <- factor(table$Length)
table$Damage <- factor(table$Damage, levels = c("none", "single", "mid", "high"))
table$Rate <- factor(table$Rate)

table <- table |>
  mutate(Precision = Mapped_mt_corr / Mapped,
         Sensitivity = Mapped_mt_corr / Mt,
         Specificity = Unmapped_nuc / Nuc) |>
  select(Precision, Sensitivity, Specificity, Gen, Length, Damage, Rate, Aligner)

write.csv(table, file = "table.csv", row.names = FALSE)
