
# Regression Inference

## Prerequisites


```r
library("tidyverse")
library("broom")
library("stringr")
library("magrittr")
```

## Sampling Distribution and Standard Errors of Coefficients

The standard error of a single regression coefficient is [@Fox2008a, p. 107]
$$
\widehat{\se}(\hat{\beta}_j) = \frac{1}{\sqrt{1 - R_j^2}} \times \frac{\hat{\sigma}^2}{\sum_i (x_{ij} - \bar{x}_j)^2} ,
$$
where $R_j^2$ is the $R^2$ of the linear regression of $x_j$ on all the other predictors except $x_j$.

The first term, $1 / \sqrt{1 - R_j}$, is named the **variance inflation factor** (VIF) for variable $j$.
It ranges from $\Inf$ when $x_j$ is completely "explained" (is a linear function of) the other predictors ($R_j^2 = 1$), to $0$, when $x_j$ is uncorrelated with the other variables ($R_j^2 = 0$)
The term $\hat{\sigma}^2$ is the standard error of the regression, $\hat{\sigma}^2 = \sum_i \hat{\epsilon}^2 / (n - k - 1)$.

The variance-covariance matrix of the regression coefficients is [@Fox2008a, p. 199]
$$
\widehat{\cov}(\hat{\vec{\beta}}}) = \hat{\sigma}^2 (\mat{X}\T \mat{X})^{-1} .
$$

# Single Coefficient

The  coefficient $\beta_k$ in a linear regresssion is equal to 0.

Hypotheses:
$$
\begin{aligned}[t]
H_0: \beta_k = 0 \\
H_a: \beta_k \neq 0 \\
\end{aligned}
$$

Test statistic,
$$
t = \frac{\hat{\beta}_k}{\widehat{se}(\hat{\beta}_k)}
$$

The test statistic is distributed $t_{n - (k + 1)}$ under assumptions $1-6$ when the errors are conditionally normal, and approaches $N(0, 1)$ when the sample size is large.

## Multiple Coefficients

Consider a multiple regression model:
$$
Y_i = \beta_0 + \beta_1 X_1 + \beta_2 X_2 + \beta_3 X_3
$$

Insted of only testing whether one variable is equal to zero, how can we test that multiple variables are equal to zero:
$$
\begin{aligned}[t]
H_0 :& \text{$\beta_1 = 0$ and $\beta_2 = 0$} \\
H_a :& \text{$\beta_1 \neq 0$ or $\beta_2 \neq 0$} 
\end{aligned}
$$

To test this hypothesis, compare the fit (residuals) of the model under the null and alternative hypthesis

*Restricted vs. unrestricted models*

**Unrestricted model** (alternative is true)
$$
Y_i = \beta_0 + \beta_1 X_1 + \beta_2 X_2 + \beta_3 X_3
$$
with estimates
$$
\hat{Y}_i = \beta_0 + \hat\beta_1 X_1 + \hat\beta_2 X_2 + \hat\beta_3 X_3
$$
and sum of squared residuals,
$$
SSR_u = \sum_{i = 1}^n (Y_i - \hat{Y}_i)^2
$$


**Restricted model** (null is true, so $\beta_2 = \beta_3 = 0$)
$$
Y_i = \beta_0 + \beta_1 X_1
$$
with estimates,
$$
\tilde{Y}_i = \tilde\beta_0 + \tilde\beta_1 X_1
$$
and sum of squared residuals,
$$
SSR_r = \sum_{i = 1}^n (Y_i - \tilde{Y}_i)^2
$$

Note that $SSR_r \geq SSR_u$ because the unrestricted model has all the variables in the restricted model plus some more.
And adding variables to a linear model cannot worsen its insample fit.

If the null is true, then $SSR_r$ and $SSR_u$ should be the same, and only differ due to the sampling variation.
The bigger the difference between $SSR_r$ and $SSR_u$ the less plausible the null hypothesis is.

**F-statistic** The F-statistic is 
$$
F = \frac{(SSR_r - SSR_u) / q}{SSR_u / (n - k - 1)}
$$

- $SSR_r - SSR_u$: increase in variation explationed (decrease in in-sample fit) when the new variables are removed
- $q$ : number of restrictions (number of variables hypothesized to be equal to 0 in the null hypothesis)
- $n - k - 1$: denominator/unrestricted degrees of freedom.
- Intuition
  $$
  \frac{\text{increase in prediction error}}{\text{original prediction error}}
  $$
  where each of these prediction errors is scaled by its degrees of freedom.

The sampling distribution of the test statistic, $F$ is an $F$-distribution.  
The [F-distribution](https://en.wikipedia.org/wiki/F-distribution) is the ratio of two $\chi^2$ ([Chi-squared](https://en.wikipedia.org/wiki/Chi-squared_distribution)) distributions.

$$
F = \frac{(SSR_r - SSR_u) / q}{SSR_u / (n - k - 1)} \sim F_{}
$$

**Connection to t-test** But isn't the $t$-test a special case of a multiple hypothesis test in which only the null hypothesis only has one coefficient set to 0. Yes, it is.

The F-statitic for a single restriction is a square of the t-statistic:
$$
F = t^2 = {\left( \frac{\hat{\beta}_1}{\widehat{\se}(\hat{\beta}_1)} \right)}^2
$$

*TODO* Simulate to show how this is different

## General Linear and Non-linear tests of Coefficients

**TODO**

See @Fox2016a for a discussion. See [car](https://www.rdocumentation.org/packages/car/topics/LinearHypothesis) function for an implementation
of linear hypothesis testing in R.

Non-linear tests are easiest done with bootstrapping. However, the Delta method can also be used (see [car](https://www.rdocumentation.org/packages/car/topics/deltaMethod).


# Multiple Testing






## Multiple Testing

What happens if we run multiple regressions? What do p-values mean in that context?

Simulate data where $Y$ and $X$ are all simulated from i.i.d. standard normal distributions,
$Y_i \sim N(0, 1)$ and $X_{i,j} \sim N(0, 1)$.
This means that $Y$ and $X$ are not associated.

```r
sim_reg_nothing <- function(n, k, sigma = 1, .id = NULL) {
  .data <- rnorm(n * k, mean = 0, sd = 1) %>%
    matrix(nrow = n, ncol = k) %>%
    set_colnames(str_c("X", seq_len(k))) %>%
    as_tibble()
  .data$y <- rnorm(n, mean = 0, sd = 1)
  # Run first regression
  .formula1 <- as.formula(str_c("y", "~", str_c("X", seq_len(k), collapse = "+")))
  mod <- lm(.formula1, data = .data, model = FALSE)
  df <- tidy(mod)
  df[[".id"]] <- .id
  df
}
```

Here is an example with of running one regression:

```r
n <- 1000
k <- 19
results_sim <- sim_reg_nothing(n, k)
```

How many coefficients are significant at the 5% level?

```r
alpha <- 0.05
arrange(results_sim, p.value) %>%
  select(term, estimate, statistic, p.value) %>%
  head(n = 20)
```

```
##           term     estimate   statistic    p.value
## 1  (Intercept) -0.057671023 -1.76761794 0.07743594
## 2          X11 -0.048028515 -1.50903711 0.13161162
## 3          X14  0.048992567  1.48746690 0.13721321
## 4          X16  0.046164679  1.41286413 0.15801318
## 5          X10 -0.044591056 -1.39512286 0.16329487
## 6           X6 -0.034591848 -1.10784039 0.26820258
## 7          X17  0.033580690  1.06105001 0.28892859
## 8           X3  0.027898979  0.85598092 0.39221757
## 9           X7  0.026048269  0.79321403 0.42784513
## 10          X1 -0.021855838 -0.68917119 0.49087868
## 11          X2 -0.021550954 -0.64034712 0.52209664
## 12         X18 -0.020022613 -0.63555967 0.52521184
## 13         X13  0.016805579  0.52445681 0.60007946
## 14          X8 -0.015532376 -0.48393610 0.62853934
## 15          X4  0.013266040  0.41097637 0.68117971
## 16         X19  0.010020257  0.31736246 0.75103619
## 17         X12 -0.010034560 -0.31199476 0.75511087
## 18          X9 -0.009682185 -0.29624723 0.76710405
## 19         X15  0.009669889  0.29186436 0.77045210
## 20          X5 -0.002942765 -0.09249518 0.92632353
```
Is this surprising? No. Since the null hypothesis is true for all coefficients ($\beta_j = 0$),
a $p$-value of 5% means that 5% of the tests will be false positives (Type I error).

Let's confirm that with a larger number of simulations and also use it to calculate some other values. Run 1,024 simulations and save the results to a data frame.

```r
number_sims <- 1024
sims <- map_df(seq_len(number_sims),
               function(i) {
                 sim_reg_nothing(n, k, .id = i)
               })
```

Calculate the number significant at the 5% level in each regression.

```r
n_sig <-
  sims %>%
  group_by(.id) %>%
  summarise(num_sig = sum(p.value < alpha)) %>%
  count(num_sig) %>%
  ungroup() %>%
  mutate(p = n / sum(n))
```
Overall, we expect 5% to be significant at the 5 percent level.

```r
sims %>%
  summarise(num_sig = sum(p.value < alpha), n = n()) %>%
  ungroup() %>%
  mutate(p = num_sig / n)
```

```
##   num_sig     n          p
## 1    1015 20480 0.04956055
```


What about the distribution of statistically significant coefficients in each regression?

```r
ggplot(n_sig, aes(x = num_sig, y = p)) +
  geom_bar(stat = "identity") +
  scale_x_continuous("Number of significant coefs",
                     breaks = unique(n_sig$num_sig)) +
  labs(y = "Pr(reg has k signif coef)")
```

<img src="regression-inference_files/figure-html/unnamed-chunk-10-1.svg" width="672" />

What's the probability that a regression will have no significant coefficients, $1 - (1 - \alpha) ^ {k - 1}$,

```r
(1 - (1 - alpha) ^ (k + 1))
```

```
## [1] 0.6415141
```

What's the take-away? Don't be too impressed by statistical significance when many tests are run.
Note that multiple hypothesis tests occur both within papers and within literatures.

**TODO**

- Familywise Error Rate
- Familywise Discovery Rate
- R function [stats](https://www.rdocumentation.org/packages/stats/topics/p.adj) will adjust p-values for multiple testing: Bonferroni, Holm, Hochberg, etc.


## Data snooping

A not-uncommon practice is to run a regression, filter out variables with "insignificant" coefficients,  and then run and report a regression with only the smaller number of "significant" variables.
Most explicitly, this occurs with [stepwise regression](https://en.wikipedia.org/wiki/Stepwise_regression), the problems of which are well known (when used for inference).
However, this can even occur in cases where the hypotheses are not specified in advance and there is no explicit stepwise function used.


To see the issues with this method, let's consider the worst case scenario, when there is no relationship between $Y$ and $X$.
Suppose $Y_i$ is sampled from a i.i.d. standard normal distributions,  $Y_i \sim N(0, 1)$.
Suppose that the design matrix, $\mat{X}$, consists of 50 variables, each sampled from i.i.d. standard normal distributions, $X_{i,k} \sim N(0, 1)$ for $i \in 1:100$, $k \in 1:50$.
Given this, the $R^2$ for these regressions should be approximately 0.50.
As shown in the previous section, it will not be uncommon to have several "statistically" significant coefficients at the 5 percent level.
The `sim_datasnoop` function simulates data, and runs two regressions:

1. Regress $Y$ on $X$
2. Keep all variables in $X$ with $p < .25$.
3. Regress $Y$ on the subset of $X$, keeping only those variables that were significant in step 2.


```r
sim_datasnoop <- function(n = 100, k = 50, p = 0.10) {
  .data <- rnorm(n * k, mean = 0, sd = 1) %>%
    matrix(nrow = n, ncol = k) %>%
    set_colnames(str_c("X", seq_len(k))) %>%
    as_tibble()
  .data$y <- rnorm(n, mean = 0, sd = 1)
  # Run first regression
  .formula1 <- as.formula(str_c("y", "~", str_c("X", seq_len(k), collapse = "+")))
  mod1 <- lm(.formula1, data = .data, model = FALSE)
  
  # Select model with only significant values (ignoring intercept)
  signif_x <-
    tidy(mod1) %>%
    filter(p.value < p, 
           term != "(Intercept)") %>%
    `[[`("term")
  if (length(signif_x > 0)) {
    .formula2 <- str_c(str_c("y", "~", str_c(signif_x, collapse = "+")))
    mod2 <- lm(.formula2, data = .data, model = FALSE)
  } else {
    mod2 <- NULL
  }
  tibble(mod1 = list(mod1), mod2 = list(mod2))
}
```
Now repeat this simulation 1,024 times, calculate the $R^2$ and number of statistically significant
coefficients at $\alpha = .05$.

```r
n_sims <- 1024
alpha <- 0.05
sims <- rerun(n_sims, sim_datasnoop()) %>%
  bind_rows() %>%
  mutate(
    r2_1 = map_dbl(mod1, ~ glance(.x)$r.squared),
    r2_2 = map_dbl(mod2, function(x) if (is.null(x)) NA_real_ else glance(x)$r.squared),
    pvalue_1 = map_dbl(mod1, ~ glance(.x)$p.value),
    pvalue_2 = map_dbl(mod2, function(x) if (is.null(x)) NA_real_ else glance(x)$p.value),
    sig_1 = map_dbl(mod1,
                      ~ nrow(filter(tidy(.x), term != "(Intercept)", p.value < alpha))),
    sig_2 = map_dbl(mod2,
                      function(x) {
                        if (is.null(x)) NA_real_
                        else nrow(filter(tidy(x), term != "(Intercept)", p.value < alpha))
                      })
    )
select(sims, r2_1, r2_2, pvalue_1, pvalue_2, sig_1, sig_2) %>%
  summarise_all(funs(mean(., na.rm = TRUE)))
```

```
## # A tibble: 1 × 6
##        r2_1      r2_2  pvalue_1   pvalue_2    sig_1   sig_2
##       <dbl>     <dbl>     <dbl>      <dbl>    <dbl>   <dbl>
## 1 0.5036307 0.1622974 0.5070183 0.03709078 2.523438 2.51002
```

While the average $R$ squared of the second stage regressions are less, the average $p$-values of the F-test that all coefficients are zero are much less.
The number of statistically significant coefficients in the first and second regressions are approximately the same, which the second regression being slightly 

- What happens if the number of obs, number of variables, and filtering significance level are adjusted?

So why are the significance levels of the overall $F$ test incorrect? For a p-value to be correct,
it has to have the correct sampling distribution of the observed data. 
Even though in this simulation we are sampling the data in the first stage from a model that
satisfies the assumptions of the F-test, the second stage does not account for the original filtering.

This example is known as [Freedman's Paradox](https://en.wikipedia.org/wiki/Freedman%27s_paradox)
[@Freedman1983a].
