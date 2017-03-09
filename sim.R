#' ----
#' title: Example of p-values and Multiple Hypothesis Testing
#' author: Jeffrey Arnold
#' date: 2017-03-07
#' ---
#'

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
sim_reg_nothing(n, k)


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



