library("tidyverse")
library("broom")

sim_reg_nothing <- function(n, k, sigma = 1, .id = NULL) {
  # X simulated from standard normal distributions
  X <- matrix(rnorm(n * k), nrow = n, ncol = k)
  # y simulated from normal distribution
  # does not depend on X
  y <- rnorm(n, sd = sigma)
  mod <- lm(y ~ X)
  df <- tidy(mod)
  df[[".id"]] <- .id
  df
}

n <- 100
k <- 19
number_sims <- 1000
sims <- map_df(seq_len(number_sims),
               function(i) {
                 sim_reg_nothing(n, k, .id = i)
               })

# number significant in each regression
sims %>%
  group_by(.id) %>%
  summarise(num_sig = sum(p.value < 0.05)) %>%
  count(num_sig) %>%
  ungroup() %>%
  mutate(p = n / sum(n))

# Proportion significant overall in the number_sims * k * n tests
sims %>%
  summarise(num_sig = sum(p.value < 0.05), n = n()) %>%
  ungroup() %>%
  mutate(p = num_sig / n)

# Probability that at least 1 of k coefficients is significant
# if they are all false
p <- .05
# Probability that all k + 1 are inignificant
(1 - p) ^ (k + 1)
# Probablity that none is significant
(1 - (1 - p) ^ (k + 1))


# One test of multiple hypotheses

# The F-test

# What is the distribution of the sum of squares for k normal distributions
sim_ss <- function(n, k, .id = NULL) {
  # X simulated from standard normal distributions
  X <- matrix(rnorm(n * k), nrow = n, ncol = k)
  # y simulated from normal distribution
  # does not depend on X
  y <- rnorm(n)
  mod <- lm(y ~ X)
  # Save the sum of squared errors
  df <- tibble(sse = sum((y - fitted(mod)) ^ 2),
               sst = sum((y - mean(y)) ^ 2))
  df[[".id"]] <- .id
  df
}

# n <- 100
# k <- 19
# number_sims <- 1000
# sims <- map_df(seq_len(number_sims),
#                function(i) {
#                  sim_ss(n, k, .id = i)
#                })
#
# ggplot(gather(sims, variable, value, -.id),
#        aes(x = value)) +
#   geom_density() +
#   facet_grid(. ~ variable, scales = "free")
#
#
# # What is the distribution of the ratio
# # ((sst - sse) / ((n - k - 1) - (n - 1))) / (sse / (n - k - 1))
#
# mutate(sims,
#        F_stat = ((sst - sse) / k) / (sse / n - k - 1),
#        F_dist = df(F_stat, k, n - k - 1)) %>%
#   ggplot() +
#   geom_density(aes(x = F_stat)) +
#   geom_line(aes(x = F_stat, y = F_dist), colour = "red")


