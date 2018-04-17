
---
output: html_document
editor_options:
  chunk_output_type: console
---
# Prediction

## Prerequisites {-}


```r
library("tidyverse")
library("broom")
library("jrnoldmisc")
```

You will need to install **jrnoldmisc** with

```r
devtools::install_github("jrnold/jrnoldmisc")
```

## Prediction Questions vs. Causal Questions

Prediction vs. Causal questions can be reduced to: Do you care about $\hat{y}$ or $\hat{beta}$?

Take a standard regression model,
$$
y = X \beta + \epsilon .
$$
We can use regression for prediction or causal inference.
The difference is what we care about.

In a prediction *prediction problem* we are interested in $\hat{y} = X \hat{\beta}$.
The values of $\hat{\beta}$ are not interesting in and of themselves.

In a *causal-inference problem* we are are interested in getting the best estimate of $\beta$, or more generally $\partial y / \partial x$ (the change in the response due to a change in x).

If we had a complete model of the world, then we could use the same model for both these tasks.
However, we don't and never will.
So there are different methods for each of these questions that are tailored to improving our estimates of those.

## Why is prediction important?

Much of the emphasis in social science is on "causal" questions, and "prediction" is often discussed pejoratively.
Apart from the fact that this belief is often due to a deep ignorance of statistics and the philosophy of science and a lack of introspection into their own research, there are a few reasons why understanding prediction questions.

## Many problems are prediction problems

Causal inferential methods are best for estimating the effect of a policy intervention.
Many problems in the political science are discussed as if they are causal, but any plausible research question is predictive since there is no plausible intervention to estimate.
I would place many questions in international relations and comparative politics in this realm.

### Counterfactuals

The fundamental problem of causal inference is a prediction problem.
We do not observe the counterfactuals, so we must predict what would have happened if a different treatment were applied.
The currently developed causal inference methods are adapting methods and insights from machine learning into these causal inference models.

### Controls

The bias-variance trade-off is useful for helping to think about and choose control variables.

### What does overfitting mean

The term overfitting is often informally used.
It has no meaning outside of prediction.

## Prediction vs. Explanation

Consider this regression model,
$$
y = \beta_1 x_1 + \beta_2 x_2 + \epsilon
$$
where $y$ is a $n \times 1$ vector and $\epsilon$ is a $n \times 1$ vector,
$$
\epsilon_i \sim \mathrm{Normal}(0, \sigma^2).
$$

We will estimate two models on this data and compare their predictive performance:

The *true model*,
$$
y = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \epsilon
$$
and the *underspecified model*,
$$
y = \beta_0 + \beta_1 x_1 + \epsilon
$$

We will evaluate their performance by repeatedly sampling from the true distribution and comparing their out of sample performance.

Write a function to simulate from the population.
We will include the sample size, regression standard deviation, correlation between the covariates, and the coefficients as arguments.

-   `size`: sample size
-   `sigma`: the standard deviation of the population errors
-   `rho`: the correlation between $x_1$ and $x_2$
-   `beta`: the coefficients ($\beta_0$, $\beta_1$, $\beta_2$)


```r
sim_data <- function(size = 100, beta = c(0, 1, 1),
                     rho = 0, sigma = 1) {
  # Create a matrix of size 1
  dat <- jrnoldmisc::rmvtnorm_df(size, loc = rep(0, 2), R = equicorr(2, rho))
  # calc mean
  dat$fx <- model.matrix(~ X1 + X2, data = dat) %*% beta %>%
    as.numeric()
  dat$y <- dat$fx + rnorm(size, 0, sigma ^ 2L)
  dat$y_test <- dat$fx + rnorm(size, 0, sigma ^ 2L)
  dat
}
```

The output of `sim_data` is a data frame with `size` rows and columns

-   `X1, X2`: The values of $x_1$ and $x_2$
-   `fx`: The mean function $f(x) = \beta_0 + \beta_1 x_1 + \beta_2 x_2$
-   `y`: The values of $y$ in the sample that will be used to train the model.
-   `y_test`: Another draw of $y$ from the population which will be used to evaluate the trained model.


```r
head(sim_data(100))
```

```
## # A tibble: 6 x 5
##       X1     X2     fx      y  y_test
##    <dbl>  <dbl>  <dbl>  <dbl>   <dbl>
## 1 -0.616  0.721  0.105 -2.19  -0.0293
## 2 -0.728 -1.12  -1.85  -1.84  -2.07  
## 3  1.05   0.793  1.85   0.809 -0.250 
## 4  0.501 -0.931 -0.429 -0.203 -0.947 
## 5  0.944 -0.152  0.792  1.46   1.39  
## 6 -0.509 -0.290 -0.799  0.362 -0.664
```

For each training and test samples we draw we want to

1.  fit the *true model* using `y`
1.  evaluate the prediction accuracy of the *true model* on `y_test`
1.  fit the *underspecified model* using `y`
1.  evaluate the prediction accuracy of the *underspecified model* on `y_test`

The function `sim_predict` does this


```r
sim_predict <- function(f, data) {
  # run regression
  mod <- lm(f, data = data)
  # predict the y_test values
  augdat <- augment(mod, data = data) %>%
    # evaluate and return MSE
    mutate(err_out = (.fitted - y_test) ^ 2,
           err_in = (.fitted - y) ^ 2)
  tibble(r_squared = glance(mod)$r.squared,
         mse_in = mean(augdat$err_in),
         mse_out = mean(augdat$err_out))
}
```

So each simulation is:

```r
data <- sim_data(100, rho = 0.9, sigma = 3)
mod_under <- sim_predict(y ~ X1, data = data)
mod_under
```

```
## # A tibble: 1 x 3
##   r_squared mse_in mse_out
##       <dbl>  <dbl>   <dbl>
## 1    0.0446   85.0    65.2
```

```r
mod_true <- sim_predict(y ~ X1 + X2, data = data)
mod_true
```

```
## # A tibble: 1 x 3
##   r_squared mse_in mse_out
##       <dbl>  <dbl>   <dbl>
## 1    0.0490   84.6    64.6
```

We are estimating the expected error of new data.
Without an analytical solution, we need to simulate this.

The `run_sim` function simulates new test and training samples of `y` and `y_test`, runs both the true and underspecified models on them, and returns the results as a data frame with two rows the columns

-   `r_squared`: In-sample $R^2$
-   `mse_in`: In-sample mean-squared-error.
-   `mse_out`: Out-of-sample mean-squared-error.
-   `model`: Either "true" or "underspecified" to indicate the model.
-   `.iter`: An iteration number, used only for bookkeeping.


```r
run_sim <- function() {
  data <- sim_data(100, rho = 0.9, sigma = 3)
  mod_under <- sim_predict(y ~ X1, data = data) %>%
    mutate(model = "underspecified")
  mod_true <- sim_predict(y ~ X1 + X2, data = data) %>%
    mutate(model = "true")
  bind_rows(mod_under, mod_true)
}
```

Run the simulation `n_sims` times and then calculate the mean $R^2$, in-sample MSE, and out-of-sample MSE:

```r
n_sims <- 512
rerun(n_sims, run_sim()) %>%
  bind_rows() %>%
  group_by(model) %>%
  summarise_all(funs(mean))
```

```
## # A tibble: 2 x 4
##   model          r_squared mse_in mse_out
##   <chr>              <dbl>  <dbl>   <dbl>
## 1 true              0.0637   78.4    83.7
## 2 underspecified    0.0511   79.4    82.9
```

Generally, the underspecified model can yield more accurate predictions when [@Shmueli2010a]:

-   data are very noisy (large $\sigma$). In these cases, increasing the
    complexity of the model will increase variance with little decrease in the
    variance since most of the variation in the sample is simply noise.

-   magnitude of omitted variables are small. In this case, those
    omitted variables don't predict the response well, but could increase the 
    overfitting in samples.

-   predictors are highly correlated. In this case, the information contained 
    in the omitted variables is largely contained in the original variables.

-   sample size is small or the range of left out variables is small.

See @Shmueli2010a for more.

**Exercise**  Try different parameter values for the simulation to confirm this.

The take-away. Prediction doesn't necessarily select the "true model", and knowing the "true model" may not help prediction.

Note that this entire exercise operated in an environment in which we knew the true model and thus does not resemble any realistic situation.
Since "all models are wrong" the question is not whether it is useful to use the "true" model.
What this simulation reveals is our models of the world are contingent on the size and quality of the data.
If the data are noisy or few, then we need to use simpler models.
If the covariates are highly correlated, it may not matter which one one we use in our theory.

## Bias-Variance Tradeoff

Consider the general regression setup,
$$
Y = f(\Vec{X}) + \epsilon,
$$
where
$$
\begin{aligned}[t]
\E[\epsilon] &= 0 & \Var[\epsilon] &= \sigma^2 .
\end{aligned}
$$
When given a random pair $(X, Y)$, we would like to "predict" $Y$ with some function of $X$, say, $f(X)$.
However, in general we do not know $f(X)$.
So given some data consisting of realizations of pairs of $X$ and $Y$, $\mathcal{D} = (x_i, y_i)$, the goal of regression is to estimate function $\hat{f}$ that is a good approximation of the true function $f$.

<!-- this discussion is alternating between discussing predicting f(X) and Y -->

What is a good $\hat{f}$ function? 
A good $\hat{f}$ will have low **expected prediction error** (EPE), which is the
error for predicting a new observation.
$$
\begin{aligned}[t]
EPE(Y, \hat{f}(x)) &= \mathbb{E}\left[(y - \hat{f}(x))^2\right] \\
    &= \underbrace{\left(\mathbb{E}(\hat{f}(x)) - f(x)\right)^{2}}_{\text{bias}} +
    \underbrace{\mathbb{E}\left[\hat{f}(x) - \mathbb{E}(\hat{f}(x))\right]^2}_{\text{variance}} +   \underbrace{\mathbb{E}\left[y - f(x)\right]^{2}}_{\text{irreducible   error}} \\
    &= \underbrace{\mathrm{Bias}^2 + \mathbb{V}[\hat{f}(x)]}_{\text{reducible error}} + \sigma^2
\end{aligned}
$$

In general, there is a bias-variance tradeoff.
The following three plots are three stylized examples of bias variance tradeoffs:
when the variance influence the prediction error more than bias, when neither is 
dominant, and when the bias is more important.

<img src="prediction_files/figure-html/unnamed-chunk-9-1.svg" width="1152" />

As model complexity increases, bias decreases, while variance increases.
There is some some sweet spot in model complexity that minimizes the expected prediction error.
By understanding the tradeoff between bias and variance, we can find a model complexity to predict unseen observations well.

<img src="prediction_files/figure-html/unnamed-chunk-10-1.svg" width="960" />

### Example

Consider the function,
$$
y = x^2 + \epsilon
$$
where $\epsilon \sim \mathrm{Normal}(0, 1)$

Here is an example of some data generated from this model.

```r
regfunc <- function(x) {
  x ^ 2
}
```

```r
sim_data <- function(x) {
  sigma <- 1
  # number of rows
  n <- length(x)
  # proportion in the test set
  p_test <- 0.3
  tibble(x = x,
         fx = regfunc(x),
         y = fx + rnorm(n, 0, sd = sigma),
         test = runif(n) < p_test)
}
```

```r
n <- seq(0, 1, length.out = 30)
sim_data(n) %>%
  ggplot(aes(x = x)) +
  geom_point(aes(y = y, colour = test)) +
  geom_line(aes(y = fx))
```

<img src="prediction_files/figure-html/unnamed-chunk-13-1.svg" width="672" />

We want to consider a 

-   $y_i = \beta_0 + \beta_1 x$
-   $y_i = \beta_0 + \beta_1 x$
-   $y_i = \beta_0 + \beta_1 x + \beta_2 x^2$
-   $y_i = \beta_0 + \beta_1 x + \beta_2 x^2 + \beta_3x^3$
-   $y_i = \beta_0 + \beta_1 x + \beta_2 x^2 + \beta_3 x^3 + \beta_3 x^4$

Estimate a polynomial regression of the data:

```r
est_poly <- function(degree, data, .iter = NULL) {
  if (degree == 0) {
    mod <- lm(y ~ 1, data = filter(data, !test))
  } else {
    mod <- lm(y ~ poly(x, degree), data = filter(data, !test))
  }
  out <- augment(mod, newdata = filter(data, test)) %>%
    mutate(degree = degree) %>%
    select(-.se.fit)
  out[[".iter"]] <- .iter
  out
}
```


```r
x <- seq(-2, 2, length.out = 100)
data <- sim_data(x)
est_poly(2, data)
```

```
##             x         fx           y test    .fitted degree
## 1  -1.9191919 3.68329762  4.13214438 TRUE 3.59113024      2
## 2  -1.7171717 2.94867871  3.09573359 TRUE 2.88649182      2
## 3  -1.6363636 2.67768595  2.36022858 TRUE 2.62628192      2
## 4  -1.5959596 2.54708703  1.88300084 TRUE 2.50081529      2
## 5  -1.5555556 2.41975309  4.33955267 TRUE 2.37844086      2
## 6  -1.3939394 1.94306703  1.06173905 TRUE 1.91986526      2
## 7  -1.2727273 1.61983471  1.16070643 TRUE 1.60840176      2
## 8  -1.0707071 1.14641363  3.22144061 TRUE 1.15114012      2
## 9  -0.8282828 0.68605244  0.05454597 TRUE 0.70446908      2
## 10 -0.7878788 0.62075298  2.43411842 TRUE 0.64084664      2
## 11 -0.3030303 0.09182736  0.29694900 TRUE 0.11856974      2
## 12  0.2222222 0.04938272  1.30869802 TRUE 0.05525384      2
## 13  0.5454545 0.29752066  1.21696625 TRUE 0.27603584      2
## 14  0.8686869 0.75461688 -0.07961000 TRUE 0.69471926      2
## 15  0.9090909 0.82644628 -0.08239676 TRUE 0.76096963      2
## 16  1.0303030 1.06152433  1.63028153 TRUE 0.97827401      2
## 17  1.0707071 1.14641363  0.31690354 TRUE 1.05689322      2
## 18  1.1919192 1.42067136  2.43168172 TRUE 1.31130411      2
## 19  1.2323232 1.51862055  2.86778221 TRUE 1.40229216      2
## 20  1.2727273 1.61983471  2.13399159 TRUE 1.49637242      2
## 21  1.3131313 1.72431385  2.27772607 TRUE 1.59354489      2
## 22  1.3535354 1.83205795  3.76389631 TRUE 1.69380957      2
## 23  1.4747475 2.17488011  1.44950005 TRUE 2.01315687      2
## 24  1.5555556 2.41975309  1.57289550 TRUE 2.24151611      2
## 25  1.6363636 2.67768595  1.38124943 TRUE 2.48224420      2
## 26  1.7979798 3.23273135  2.42694161 TRUE 3.00080689      2
## 27  1.8383838 3.37965514  1.81125078 TRUE 3.13817809      2
```


```r
run_sim <- function(.iter) {
  degrees <- 0:5
  x <- seq(0, 1, length.out = 40)
  data <- sim_data(x)
  # run all models
  map_df(degrees, est_poly, data = data, .iter = .iter)
}
```

Run this model several times,

```r
n_sims <- 1024
all_sims <- map_df(seq_len(n_sims), ~ run_sim(.x))
```


```r
ggplot() +
  geom_line(data = filter(all_sims, .iter < 10),
            mapping = aes(x = x, y = .fitted, group = .iter)) +
  geom_line(data = filter(all_sims, .iter == 1),
            mapping = aes(x = x, y = fx), colour = "red") +
  facet_wrap(~ degree)
```

<img src="prediction_files/figure-html/unnamed-chunk-18-1.svg" width="672" />


```r
poly_estimators <- all_sims %>%
  group_by(degree, x) %>%
  summarise(estimate = mean(.fitted),
            variance = var(.fitted),
            fx = mean(fx))
```


```r
ggplot(poly_estimators, aes(x = x, y = estimate, colour = factor(degree))) +
  geom_line()
```

<img src="prediction_files/figure-html/unnamed-chunk-20-1.svg" width="672" />


```r
poly_estimators %>%
  mutate(bias = estimate - fx) %>%
  group_by(degree) %>%
  summarise(bias = mean(bias ^ 2), variance = mean(variance, na.rm = TRUE))
```

```
## # A tibble: 6 x 3
##   degree     bias variance
##    <int>    <dbl>    <dbl>
## 1      0 0.0997     0.0395
## 2      1 0.00728    0.0803
## 3      2 0.000469   0.133 
## 4      3 0.000560   0.202 
## 5      4 0.000418   0.296 
## 6      5 0.00179    0.437
```

Since $\hat{f}$ varies sample to sample, there is variance in $\hat{f}$.
However, OLS requires zero bias in sample, and thus means that there is no trade-off.

### Overview

We can 

-   low bias, high variance (overfit)

    -   more complex (flexible functions)
    -   estimated function closer to the true function
    -   estimated function varies more, sample to sample
    -   overfit

-   high bias, low variance (underfit)

    -   simple function
    -   simpler estimated function
    -   estimated function varies less, sample to sample
    -   underfit

What to do?

-   low bias, high variance: simplify model
-   high bias, low variance: make model more complex
-   high bias, high variance: more data
-   low bias, low variance: your good

The genera

-   more training data reduces both bias and variance
-   regularization and model selection methods can choose an optimal bias/variance trade-off

## Prediction policy problems

@KleinbergLudwigMullainathanEtAl2015a distinguish two types of policy questions.
Consider two questions related to rain.

1.  In 2011, Governor Rick Perry of Texas [designated days for prayer for rain](https://en.wikipedia.org/wiki/Days_of_Prayer_for_Rain_in_the_State_of_Texas)
    in order to end the Texas drought.

1.  It is cloudy out. Do you bring an umbrella (or rain coat) when leaving the house?

How does the pray-for-rain problem differ from the umbrella problem?

-   Prayer problems are causal questions, because the payoff depends on the causal question as to whether a prayer-day can cause rain.
-   Umbrella questions are prediction problems, because an umbrella does not cause rain. However, the utility of bringing an umbrella depends on the probability of rain.

Many policy problems are a mix of prediction and causation.
The policymaker needs to know whether the intervention has a causal effect, and also the predicted value of some other value which will determine how useful the intervention is.
More formally, let $y$ be an outcome variable which depends on the values of $x$ ($x$ may cause $y$).
Let $u(x, y)$ be the policymaker's payoff function. 
The change in utility with response to a new policy ($\partial u(x, y) / \partial x)$ can be decomposed into two terms,
$$
\frac{\partial u(x, y)}{\partial x} =
\frac{\partial u}{\partial x} \times \underbrace{y}_{\text{prediction}} +
\frac{\partial u}{\partial y} \times
\underbrace{\frac{\partial y}{\partial x}}_{\text{causation}} .
$$
Understanding the payoff of a policy requires understanding the two unknown terms

-   $\frac{\partial u}{\partial x}$: how does $x$ affect the utility. This needs to evaluated at the value of $y$, which needs to be predicted. The utility of carrying an umbrella depends on whether it rains or no. This is predictive.
-   $\frac{\partial y}{\partial x}$: how does $y$ change with changes in $x$? This is causal.

## Freedman's Paradox

Create a matrix with `n` rows and `k` columns (variables).

```r
k <- 51
n <- 100
```

Suppose that all entries in this matrix are uncorrelated, e.g.

```r
X <- rmvtnorm_df(n, loc = rep(0, k))
```


```r
mod1 <- lm(X1 ~ ., data = X)
broom::glance(mod1)
```

```
##   r.squared adj.r.squared     sigma statistic   p.value df    logLik
## 1 0.5089458   0.007870055 0.9826603  1.015706 0.4786342 51 -104.4772
##        AIC      BIC deviance df.residual
## 1 312.9544 448.4232 47.31544          49
```

-   What is the $R^2$ and $p$-value of the $F$-test of this regression?
-   How many significant variables at the 5% level are there?
-   Keep all the variables significant at the 25% level.
-   Rerun the regression using those variables.


```r
thresh <- 0.25
varlist <- filter(tidy(mod1), p.value < thresh,
                  term != "(Intercept)")[["term"]]
f <- as.formula(str_c("X1 ~ ", str_c(varlist, collapse = " + ")))
mod2 <- lm(f, data = X)
```


```r
glance(mod2)
```

```
##   r.squared adj.r.squared     sigma statistic      p.value df    logLik
## 1 0.3572561     0.2600971 0.8486068  3.677027 0.0001227021 14 -117.9368
##        AIC      BIC deviance df.residual
## 1 265.8735 304.9511 61.93148          86
```


```r
tidy(mod2) %>%
  filter(p.value < 0.05)
```

```
##   term   estimate  std.error statistic      p.value
## 1   X8  0.2294665 0.10629374  2.158796 0.0336516521
## 2   X9  0.3269053 0.10405664  3.141609 0.0023045792
## 3  X24 -0.3593608 0.09797524 -3.667873 0.0004230047
## 4  X25  0.1634689 0.07779102  2.101385 0.0385331723
## 5  X36 -0.2809037 0.09118527 -3.080582 0.0027743254
## 6  X39  0.2072314 0.07308993  2.835294 0.0057061373
## 7  X41  0.3386400 0.09280671  3.648874 0.0004509922
```

The takeaway is that model selection can create variables that appear important even when they are not.
Inference (calculating standard errors) after model selection is very difficult to do correctly.
Recall that to be correct, the definition of the sampling distribution (used in confidence intervals and hypothesis testing) would have to include all possible ways in which the data were generated.
The previous analysis omitted that.
If the effect of omitting the model selection stage didn't seem to make much of a difference in the final outcomes, it may not be fine to simplify by ignoring it.
However, this example shows that the effect of omitting this stage is large.

### References

Parts of the bias-variance section are derived from R for Statistical Learning, [Bias-Variance Tradeoff](https://daviddalpiaz.github.io/r4sl/biasvariance-tradeoff.html)

Also see:

-   [Understanding the Bias-Variance Tradeoff](http://scott.fortmann-roe.com/docs/BiasVariance.html)
