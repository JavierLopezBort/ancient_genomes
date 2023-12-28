library("tidyverse")

# Load stat_table
table <- read_csv(file = "table.csv")

# Preprocessing step
table$Rate <- format(table$Rate, scientific = FALSE)
table$Rate <- sub("\\.?0*$", "", table$Rate)
table$Gen <- factor(table$Gen)
table$Length <- factor(table$Length)
table$Damage <- factor(table$Damage, levels = c("none", "single", "mid", "high"))
table$Rate <- factor(table$Rate)

# Aligner

transformed_data <- table |>
  select(-Gen, -Length, -Damage, -Rate) |>
  group_by(Aligner) |>
  nest(Precision, Sensitivity, Specificity) |>
  mutate(Precision = map(data, ~mean(.x$Precision, na.rm = TRUE)),
         Sensitivity = map(data, ~mean(.x$Sensitivity, na.rm = TRUE)),
         Specificity = map(data, ~mean(.x$Specificity, na.rm = TRUE))) |>
  pivot_longer(cols = c(Precision, Sensitivity, Specificity), names_to = "metric", values_to = "mean") |>
  select(-data)

transformed_data$mean <- as.numeric(transformed_data$mean)
transformed_data$metric <- factor(transformed_data$metric, levels = c("Precision", "Sensitivity", "Specificity"))

# Creating a single plot with facets for each iteration
p <- transformed_data |>
  ggplot(aes(x = Aligner, y = mean, color = Aligner)) +
  geom_point() +
  facet_wrap(metric ~ ., scales = "free_y", labeller = labeller(metric = c(Precision = "Precision", Sensitivity = "Sensitivity", Specificity = "Specificity"))) +  # Use facet_grid if you prefer a grid layout
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 8),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "white"),
        axis.line = element_line(colour = "black"),
        plot.subtitle = element_text(size = 10),
        legend.position = "bottom") +
  labs(x = "Aligner", y = "Metric value", color = "Aligner")

p

ggsave("Aligner.jpg", p, width = 6, height = 6)

# Generation

transformed_data <- table |>
  select(-Length, -Damage, -Rate) |>
  group_by(Aligner, Gen) |>
  nest(Precision, Sensitivity, Specificity) |>
  mutate(Precision = map(data, ~mean(.x$Precision, na.rm = TRUE)),
         Sensitivity = map(data, ~mean(.x$Sensitivity, na.rm = TRUE)),
         Specificity = map(data, ~mean(.x$Specificity, na.rm = TRUE))) |>
  pivot_longer(cols = c(Precision, Sensitivity, Specificity), names_to = "metric", values_to = "mean") |>
  select(-data)

transformed_data$mean <- as.numeric(transformed_data$mean)
transformed_data$metric <- factor(transformed_data$metric, levels = c("Precision", "Sensitivity","Specificity"))

# Creating a single plot with facets for each iteration
p <- transformed_data |>
  ggplot(aes(x = Gen, y = mean, color = Aligner)) +
  geom_point() +
  facet_wrap(metric ~ ., scales = "free_y", labeller = labeller(metric = c(Precision = "Precision", Sensitivity = "Sensitivity", Specificity = "Specificity"))) +  # Use facet_grid if you prefer a grid layout
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 7),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "white"),
        axis.line = element_line(colour = "black"),
        plot.subtitle = element_text(size = 10),
        legend.position = "bottom") +
  labs(x = "Generation", y = "Metric value", color = "Aligner")

p

ggsave("Gen.jpg", p, width = 6, height = 6)

# Length

transformed_data <- table |>
  select(-Gen, -Damage, -Rate) |>
  group_by(Aligner, Length) |>
  nest(Precision, Sensitivity, Specificity) |>
  mutate(Precision = map(data, ~mean(.x$Precision, na.rm = TRUE)),
         Sensitivity = map(data, ~mean(.x$Sensitivity, na.rm = TRUE)),
         Specificity = map(data, ~mean(.x$Specificity, na.rm = TRUE))) |>
  pivot_longer(cols = c(Precision, Sensitivity, Specificity), names_to = "metric", values_to = "mean") |>
  select(-data)

transformed_data$mean <- as.numeric(transformed_data$mean)
transformed_data$metric <- factor(transformed_data$metric, levels = c("Precision", "Sensitivity", "Specificity"))

# Creating a single plot with facets for each iteration
p <- transformed_data |>
  ggplot(aes(x = Length, y = mean, color = Aligner)) +
  geom_point() +
  facet_wrap(metric ~ ., scales = "free_y", labeller = labeller(metric = c(Precision = "Precision", Sensitivity = "Sensitivity", Specificity = "Specificity"))) +  # Use facet_grid if you prefer a grid layout
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 6.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "white"),
        axis.line = element_line(colour = "black"),
        plot.subtitle = element_text(size = 10),
        legend.position = "bottom") +
  labs(x = "Length", y = "Metric value", color = "Aligner")

p

ggsave("Length.jpg", p, width = 6, height = 6)

# Damage

transformed_data <- table |>
  select(-Gen, -Length, -Rate) |>
  group_by(Aligner, Damage) |>
  nest(Precision, Sensitivity, Specificity) |>
  mutate(Precision = map(data, ~mean(.x$Precision, na.rm = TRUE)),
         Sensitivity = map(data, ~mean(.x$Sensitivity, na.rm = TRUE)),
         Specificity = map(data, ~mean(.x$Specificity, na.rm = TRUE))) |>
  pivot_longer(cols = c(Precision, Sensitivity, Specificity), names_to = "metric", values_to = "mean") |>
  select(-data)

transformed_data$mean <- as.numeric(transformed_data$mean)
transformed_data$metric <- factor(transformed_data$metric, levels = c("Precision", "Sensitivity","Specificity"))

# Creating a single plot with facets for each iteration
p <- transformed_data |>
  ggplot(aes(x = Damage, y = mean, color = Aligner)) +
  geom_point() +
  facet_wrap(metric ~ ., scales = "free_y", labeller = labeller(metric = c(Precision = "Precision", Sensitivity = "Sensitivity", Specificity = "Specificity"))) +  # Use facet_grid if you prefer a grid layout
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 8),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "white"),
        axis.line = element_line(colour = "black"),
        plot.subtitle = element_text(size = 10),
        legend.position = "bottom") +
  labs(x = "Damage", y = "Metric value", color = "Aligner")

p

ggsave("Damage.jpg", p, width = 6, height = 6)

# Rate

transformed_data <- table |>
  select(-Gen, -Damage, -Length) |>
  group_by(Aligner, Rate) |>
  nest(Precision, Sensitivity, Specificity) |>
  mutate(Precision = map(data, ~mean(.x$Precision, na.rm = TRUE)),
         Sensitivity = map(data, ~mean(.x$Sensitivity, na.rm = TRUE)),
         Specificity = map(data, ~mean(.x$Specificity, na.rm = TRUE))) |>
  pivot_longer(cols = c(Precision, Sensitivity, Specificity), names_to = "metric", values_to = "mean") |>
  select(-data)

transformed_data$mean <- as.numeric(transformed_data$mean)
transformed_data$metric <- factor(transformed_data$metric, levels = c("Precision", "Sensitivity", "Specificity"))

# Creating a single plot with facets for each iteration
p <- transformed_data |>
  ggplot(aes(x = Rate, y = mean, color = Aligner)) +
  geom_point() +
  facet_wrap(metric ~ ., scales = "free_y", labeller = labeller(metric = c(Precision = "Precision", Sensitivity = "Sensitivity", Specificity = "Specificity"))) +  # Use facet_grid if you prefer a grid layout
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 3),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "white"),
        axis.line = element_line(colour = "black"),
        plot.subtitle = element_text(size = 10),
        legend.position = "bottom") +
  labs(x = "Rate", y = "Metric value", color = "Aligner")

p

ggsave("Rate.jpg", p, width = 6, height = 6)
