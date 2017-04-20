
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
It ranges from $\inf$ when $x_j$ is completely "explained" (is a linear function of) the other predictors ($R_j^2 = 1$), to $0$, when $x_j$ is uncorrelated with the other variables ($R_j^2 = 0$)
The term $\hat{\sigma}^2$ is the standard error of the regression, $\hat{\sigma}^2 = \sum_i \hat{\epsilon}^2 / (n - k - 1)$.

The variance-covariance matrix of the regression coefficients is [@Fox2008a, p. 199]
$$
\widehat{\Cov}(\hat{\vec{\beta}}) = \hat{\sigma}^2 (\mat{X}\T \mat{X})^{-1} .
$$

## Single Coefficient

Consider these hypothesis about a single $\beta_k$ coefficient:
$$
\begin{aligned}[t]
H_0:& \beta_k = \beta_0 \\
H_a:& \beta_k \neq \beta_0 \\
\end{aligned}
$$
The test statistic is,
$$
t = \frac{\hat{\beta}_k - \beta_0}{\widehat{\se}(\hat{\beta}_k)}
$$
which is distributed $t_{n - (k + 1)}$.
The $p$ value $p = \Pr(T < t) + \Pr(T > t)$ where $t$ is the test statistic, and $T$ is a random variable distributed Student's t.

The most common null hypothesis, and the default null hypothesis reported in regression tables and regression software output is that the coefficient is zero, i.e. $\beta_0 = 0$.
This simplifies the test statistic to 0,
$$
t = \frac{\hat\beta_k}{\widehat{\se}(\hat{\beta_k})}
$$
Since the critical value for a two-sided p-value with a normal distribution is 1.96, this yields the rule of thumb that $\hat\beta$ is significant at the 5% level if $t < 2$.

For a one sided hypothesis, such as 
$$
\begin{aligned}[t]
H_0:& \beta_k < \beta_0 \\
H_a:& \beta_k \neq \beta_0 \\
\end{aligned}
$$
use the same test statistic as above, but halve the $p$-value since $p = \Pr(T < t)$.


### Confidence Intervals

The $1 - \alpha$ confidence interval for a single regression coefficient is
$$
CI(\hat\beta_k, \alpha) = \hat\beta_k \pm t^*_{\alpha / 2} \hat{se}(\hat\beta)
$$
where $t^*_{\alpha / 2}$ is the quantile of the Student's $t$ distribution with $n - k - 1$ degrees of freedom, $t^*_{\alpha/2} = t s.t. \Pr(t < T) = 1 - (1 - \alpha / 2)$.



## Multiple Coefficients

We can consider several common confidence intervals and NHST for multiple coefficients.


### F-test

Consider a multiple regression model:
$$
Y_i = \beta_0 + \beta_1 X_1 + \beta_2 X_2 + \beta_3 X_3
$$

Consider the null hypothesis is that all the coefficients are equal to zero, and the alternative that at least one coefficient is not zero:
$$
\begin{aligned}[t]
H_0 :& \text{$\beta_1 = 0$ and $\beta_2 = 0$} \\
H_a :& \text{$\beta_1 \neq 0$ or $\beta_2 \neq 0$} 
\end{aligned}
$$

To test this hypothesis, compare the fit (residuals) of the model under the null and alternative hypthesis.

Note that these hypothesese are really about a model comparison. Does the model with variables $\beta_1$ and $\beta_2$ fit better than the model without them.
The model without those predictors is called the *restricted model* and the model with those predictors is the *unrestricted model*.

*Unrestricted model (Long model)*: The model if $H_a$ is true:
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


*Restricted model (short model)*: The model if the null is true, $\beta_2 = \beta_3 = 0$
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

Note that the variance of the errors in the unrestricted model has to be smaller than the variances in the restricted model, $SSR_r \leq SSR_u$. 
This is because the unrestricted model has all the variables in the restricted model plus some more, so it can't fit any worse than the restricted model.
Remember that variables to a linear model cannot worsen its in-sample fit.

If the null is true, then we would expect that $SSR_r = SSR_u$ apart from sampling variation.
The bigger the difference $SSR_r - SSR_u$, the less plausible the null hypothesis is.

*F-statistic:* The F-statistic is 
$$
F = \frac{(SSR_r - SSR_u) / q}{SSR_u / (n - k - 1)} ,
$$
where,

- $SSR_r - SSR_u$: increase in variation explationed (decrease in in-sample fit) when the new variables are removed
- $q$ : number of restrictions (number of variables hypothesized to be equal to 0 in the null hypothesis)
- $n - k - 1$: denominator/unrestricted degrees of freedom.
- Intuition
  $$
  \frac{\text{increase in prediction error}}{\text{original prediction error}}
  $$
  where each of these prediction errors is scaled by its degrees of freedom.

The sampling distribution of the test statistic, $F$ is the unsurprisingly named $F$-distribution.  
The [F-distribution](https://en.wikipedia.org/wiki/F-distribution) is the ratio of two $\chi^2$ ([Chi-squared](https://en.wikipedia.org/wiki/Chi-squared_distribution)) distributions.

$$
F = \frac{(SSR_r - SSR_u) / q}{SSR_u / (n - k - 1)} \sim F_{}
$$

*Connection to t-test* But isn't the $t$-test a special case of a multiple hypothesis test in which only the null hypothesis only has one coefficient set to 0. Yes, yes, it is.
The F-statitic for a single restriction is a square of the t-statistic:
$$
F = t^2 = {\left( \frac{\hat{\beta}_1}{\widehat{\se}(\hat{\beta}_1)} \right)}^2
$$

*TODO* Simulate this test to show its sampling distribution


### Confidence Regions

A *confidence ellipses* is the multivariate generalization of a confidence interval.
A $1 - \alpha$% Confidence intervals computed on repeated i.i.d. samples will contain the
vector of true parameter values in $1 - \alpha$ of those samples.

See @Fox2016a for the derivation of the OLS confidence ellipse. 

The joint confidence region for the $q$ parameters $\beta^*$ is the region where the $F$ test of a joint hypothesis given them is not rejected at the $1 - \alpha$ level of significance.
It is given by
$$
(\hat\beta^* - \beta^*)' \widehat\Cov(\hat\beta^*) (\hat\beta^* - \beta^*) \leq q \hat\sigma^2 F_{\alpha, q, n - k - 1}
$$
where $F_{\alpha, q, n - k - 1}$ is the quantile of the $F$ distribution with $q$ and $n - k - 1$ degrees of freedom where $\Pr(x > X) = \alpha$, and $\hat\beta^*$ is the 

The diagrams in @Fox2016a are particularly useful.

The **[car](https://cran.r-project.org/package=car)** function [car](https://www.rdocumentation.org/packages/car/topics/confidenceEllipse) calculates the confidence ellipse.
See its help page for examples.


### Linear Hypothesis Tests


The null hypothesis in a general linear hypothesis is
$$
H_0: \underbrace{\mat{L}}_{q \times k + 1} \underbrace{\vec\beta}_{k +1 \times 1} = \underbrace{\vec{c}}_{q \times 1}
$$
where $\mat{L}$ and $\vec{c}$ are constants that are specified in the hypothesis.

*Example:* For $H_0: \beta_1 = \beta_2 = 0$,
$$
\begin{aligned}
\mat{L} &= \begin{bmatrix}
0 & 1 & 0 \\
0 & 0 & 1
\end{bmatrix} & 
\vec{c} &= \begin{bmatrix}
0 \\ 0
\end{bmatrix}
\end{aligned}
$$
*Example:* For $H_0: \beta_1 = \beta_2$ or $H_0: \beta_1 - \beta_2 = 0$,
$$
\begin{aligned}
\mat{L} &= \begin{bmatrix}
0 & 1 & -1 \\
\end{bmatrix} & 
\vec{c} &= \begin{bmatrix}
0
\end{bmatrix}
\end{aligned}
$$

The test statistic for this is distributed $F$ under the null hypothesis. See @Fox2016a for a discussion. See [car](https://www.rdocumentation.org/packages/car/topics/LinearHypothesis) function for an implementation.


## Linear and Non-Linear Confidence Intervals

For a single coefficient, a confidence interval for a linear function of $\hat\beta$,
$$
CI(a + c \hat\beta_k) = a + c CI(\hat\beta_k)
$$

For non-linear confidence intervals the easiest way to calculate the confidence intervals is using a bootstrap (see [Bootstrapping]) or simulation [@KingTomzWittenberg2000a].

Non-linear confidence intervals are easiest to construct with [bootstrapping][Bootstrapping].

However, the Delta method can also be used (see [car](https://www.rdocumentation.org/packages/car/topics/deltaMethod).



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
## 1           X7 -0.078653549 -2.42975650 0.01528771
## 2           X3  0.074319930  2.31981338 0.02055568
## 3           X2  0.073479210  2.26682346 0.02361823
## 4          X18  0.060116549  1.91166357 0.05621077
## 5          X15 -0.063182860 -1.90934736 0.05650909
## 6           X4  0.055228170  1.70043102 0.08936716
## 7          X16  0.037261288  1.17882830 0.23875268
## 8          X12 -0.031195077 -1.02930126 0.30359210
## 9           X6 -0.030642570 -0.98608544 0.32433457
## 10         X11 -0.031623879 -0.96449749 0.33503450
## 11          X5 -0.027538547 -0.85419387 0.39320633
## 12          X9 -0.017672658 -0.55548574 0.57868924
## 13          X1 -0.016570940 -0.50298851 0.61508537
## 14         X17 -0.013440731 -0.42137369 0.67357463
## 15 (Intercept) -0.011582072 -0.36791210 0.71301823
## 16         X10  0.008910153  0.27966163 0.77979613
## 17          X8  0.008178612  0.26544095 0.79072562
## 18         X13 -0.004758974 -0.14797090 0.88239617
## 19         X19  0.003901157  0.12131962 0.90346275
## 20         X14  0.001949713  0.06442449 0.94864537
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
## 1     988 20480 0.04824219
```


What about the distribution of statistically significant coefficients in each regression?

```r
ggplot(n_sig, aes(x = num_sig, y = p)) +
  geom_bar(stat = "identity") +
  scale_x_continuous("Number of significant coefs",
                     breaks = unique(n_sig$num_sig)) +
  labs(y = "Pr(reg has k signif coef)")
```

<img src="regression-inference_files/figure-html/unnamed-chunk-9-1.svg" width="672" />

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
##        r2_1      r2_2  pvalue_1   pvalue_2   sig_1   sig_2
##       <dbl>     <dbl>     <dbl>      <dbl>   <dbl>   <dbl>
## 1 0.5022612 0.1605037 0.5094306 0.03952331 2.47168 2.46802
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
