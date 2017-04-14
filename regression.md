
# (PART) Linear Models

# What is Regression?

While this section will generally cover linear regression, it is not the only form of **regression**. So let's start with a definition of regression.

Most generally, a regression represents a function of a variable, $Y$ as a function of another variable or variables, $X$, and and error.
$$
g(Y_i) = f(X_i) + \text{error}_i
$$

The **conditional expectation function** (CEF) or **regression function** of $Y$ given $X$ is denoted,
$$
\mu(x) = \E\left[Y | X = x\right]
$$

But if regression represents $Y$ as a function of $X$, what's the alternative? 
Instead of modeling $Y$ as a function of $X$, we could jointly model both $Y$ and $X$. 
A regression model of $Y$ and $X$ would be multivariate function, $f(Y, X)$.
In machine learning these approaches are sometimes called **descriminative** (regression) and **generative** (joint models) models.


# Bivariate Regression Model

Given two vectors, $\vec{y} = (y_1, y_2, ..., y_n)$, and $\vec{x} = (x_1, x_2, ..., x_n)$, the **regression line** is,
$$
\E(y | y) = \hat{y_i} = \hat\beta_0 + \hat{\beta} x_i
$$
where $\hat{y_i}$ is called the **fitted value**,
and the residual is
$$
\hat{\epsilon}_i = y_i - \hat{y}_i
$$

The OLS estimator for $\hat{\vec{\beta}}$ finds the values of $\hat{\beta}_0$ and $\hat{\beta}_1$ that minimize the sum of squared residuals of the regression line,
$$
\hat{\beta}_0, \hat{\beta}_1 = \argmin_{b_0, b_1}\sum_{i = 1}^n {( y_i - b_0 - b_1 x_i )}^2 = \argmin_{b_0, b_1}\sum_{i = 1}^n \hat{\epsilon}_i^2
$$

Terminology

- **esitmated coefficients:** $\hat\beta_0$, $\hat\beta_1$
- **estimated intercept:** $\hat\beta_0$
- **estimated slope:** $\hat\beta_1$
- **predicted values, fitted values:** $\hat\y_i$
- **residuals, prediction errors:** $\hat\epsilon_i = y_i - \hat{y}_i$


The solution to that minimization problem is the following closed-form solution[^closedform],
$$
\begin{aligned}
\hat{\beta}_0 &= \bar{y} - \hat{\beta}_1 \bar{x} \\
\hat{\beta}_1 &= \frac{\sum_{i = 1}^N (x_i - \bar{x})^2 (y_i - \bar{y})^2}{\sum_{i = 1}^n (x_i - \bar{x})^2} 
\end{aligned}
$$

[^closedform]: A closed form solution is one that can be expressed in terms of simple functions.
  Many other statistical estimators do not have closed-form solutions and must be solved numerically.

Properties of OLS

1. The regression line goes through the means of $X$ and $Y$, $(\hat{y}, \hat{x})$.
2. The sum (and mean) of the errors are zero,
    $$
    0 = \sum_{i =1}^n \hat\epsilon_i = \sum_{i =1}^n (y_i - \hat\beta_0 - \hat\beta_1 x_i)
    $$
    This is a mechanical property and a direct consequence of finding the minimum sum of squared errors.
3.  The slope coefficient is the ratio of the covariance of $X$ and $Y$ to the variance of $X$,
    $$
    \begin{aligned}[t]
    \hat{\beta}_1 &= \frac{\sum_{i = 1}^N (x_i - \bar{x})^2 (y_i - \bar{y})^2}{\sum_{i = 1}^n (x_i - \bar{x})^2} \\
     &= \frac{\Cov(x_i, y_i)}{\Var(x_i)}
    \end{aligned}
    $$
4. The slope coefficient is the scaled correlation betweee $X$ and $Y$,
    $$
    \begin{aligned}[t]
    \hat{\beta}_1 &= \frac{\Cov(x_i, y_i)}{\Var(x_i)} \\
    &= \frac{\sd_x \sd_y \Cor(x, y)}{\Var(x_i)} \\
    &= \frac{\sd_y}{\sd_x} \Cor(x, y)
    \end{aligned}
    $$

### OLS is the weighted sum of outcomes

In OLS, the coefficients are weighted averages of the dependent variables,
$$
\hat{\beta}_1 = \sum_{i = 1}^n \frac{(x_i - \bar{x})}{{(x_i - \bar{x})}^2} = \sum_{i = 1}^{n} w_i y_i
$$
where the weights are,
$$
w_i = \frac{x_i - \bar{x}}{\sum_{i = 1}^n (x_i - \bar{x})^2}
$$

Alternatively, we can rewrite the estimation error (difference between the parameter, $\beta$, and the esimtate, $\hat{\beta}$) as a weighted sum of the errors,
$$
\hat\beta_1 - \beta_1  = \sum_{i = 1}^n w_i \epsilon_i
$$

**note** Linear regression is **linear** not because $y = b_0 + b_2$, but because the predictions can be represented as weighted sums of outcome, $\hat{y} = w_i y_i$. If we were to estimate $\hat{\beta}_0$ or $\hat{\beta}_1$ with a different objective function, then it would not longer be linear.

# Covariance and Correlation

Plot of covariance and correlation

The population covariance for random variables $X$ and $Y$ is,
$$
\Cov(X, Y) = \E[(X - \mu_x)(Y - \mu_y)]
$$

The sample covariance for vectors $\vec{x}$ and $\vec{y}$ is,
$$
\Cov(x_i, y_i) = \frac{1}{n} \sum_{i = 1}^n (x_i - \bar{x})(y_i - \bar{y})
$$

Some properties of covariance are:

- $\Cov(X, X) = \Var(X, X)$. Why?
- $\Cov(X, Y)$ has a domain of $(-\infty, \infty)$. What would a covariance of $-\infty$ look like? of $\infty$? of 0?

Like variance is defined on the scale of the squared variable ($X^2$), the covariance is defined on the scale of the product of the variables ($X Y$), which makes it difficult to interpret.

However unlike taking the square root of the variables, in correlation is standardized to a domain of $[-1, 1]$.
$$
\Cor(X, Y) = \frac{\E[(X - \mu_x)(Y - \mu_y)]}{\sigma_x \sigma_y}
$$
$$
\Cor(x_i, y_i) = \frac{\sum_{i = 1}^n (x_i - \bar{x})(y_i - \bar{y})}{s_x s_y}
$$

# Goodness of Fit

What measures do we have for how well a line fits the data?

## Root Mean Squared Error and Standard Error

The first is the mean squared error,
$$
MSE = \frac{1}{n} \sum_{i = 1}^n \hat\epsilon_i
$$
or root mean squared error,
$$
RMSE = \sqrt{\frac{1}{n} \sum_{i = 1}^n \hat\epsilon_i}
$$

The standard error, $\hat\sigma$ is similar, but is an estimator of the standard deviation of the population errors, $\epsilon_i \sim N(0, \sigma)$
$$
\hat\sigma = MSE = \sqrt{\frac{1}{n - k - 1} \sum_{i = 1}^n \hat\epsilon_i}
$$
where $k + 1$ is the number of coefficients (including the intercept) in the regression. 
In the simple (bivariate) regression model $k = 1$, since there is one variable in addition to the intercept.

The only difference between the $RMSE$ and $\sigma\hat$ is the denominator; $\sigma\hat$ adjusts for the degrees of freedom. As the sample size gets large relative to the number of variables,  $n - k \to \infty$, the standard error of the regression approaches the MSE, since $1 / (n - k - 1) \to 1 / n$.


## R squared



The coefficient of determination, $R^2$, 



- If $R^2 = 1$, then $SSE = 0$, and all points of $y_i$  fall on a straight line.
    However, if all values of $y_i$ are equal ($SSE = SST = 0$), then the $R^2$ is undefined.
- If $R^2 = 0$, then there is no relationshiop. $SSE = SST$, meaning that including $x_i$ does not
    reduce the residuals any more than using the mean of $\vec{y}$.
- In the bivariate regression case,
    $$
    R^2 = \cor(x, y)^2 ,
    $$
    hence its name (since $r$ is the letter usually used to indicate correlation).
- In the more general case, $R^2$ is the squared correlation between the outcome and the fitted values of the regression, 
    $$
    R^2 = \cor(\vec{y}, \hat{\vec{y}}).
    $$

The common interpreation of $R^2$ is "the fraction of variation in $y_i$ that is explained by the regression ($x_i$)."
In this context, "explained" should **not** be interpreted a "caused."

Consider the 
$$
Y = a X + \epsilon
$$
The variance of $Y$ is $a^2 \Var(X) + \Var(\epsilon)$ (supposing $\cor(X, \epsilon) = 0$ ).
The "variance explained" by the regression is simply $a^2 \var(x)$, and 
$$
R^2 = \frac{a^2 \var(X)}{a^2 \var(X) + \var(\epsilon)}
$$
As the variation in $X$ gets large, $\var(X) \to \infty$, then the regression "explains" everything, $R^2 \to 1$, and as the variance in $X$ gets small, $\var(X)  \to 0$, then the regression explains nothing, $R^2 \to 0$.


## Maximum Likelihood

The OLS estimator of linear regresion finds $\beta_0$ and $\beta_1$ by minimizing the squared error. 
One nice property of this estimator is that it agrees with the maximum likelihood estimator of the  coefficients.[^mle-sigma]
[Maximum likelihood estimation (MLE)](https://en.wikipedia.org/wiki/Maximum_likelihood_estimation) is a general statistical estimator.
It finds parameters by doing what its name says, maximizing a likelihood function.
A likelihood function, $f(\vec{y} | \vec{\theta})$, is the probability of observing the data, $\vec{x}$, *given* parameter valaues, $\vec{y}$.
The MLE value of the parameters, $\hat{\vec{\theta}}$, is the value of the parameters that maximizes the probability of observing the data.
While no distributional assumptions were needed to calculate the OLS estimator (though some are needed for inference in small samples), the MLE requires specifying distributions for the data.
In linear regression, we assume the following model,
$$
\begin{aligned}[t]
Y_i &= \beta_0 + \beta_1 X_i + \epsilon_i
\end{aligned}
$$
where $\epsilon_i \sim N(0, \sigma^2)$. That must assume the errors are distributed normally in order to calculate the estimates of $\vec{\beta}$ is different than OLS.
Then the MLE function is,
$$
\begin{aligned}[t]
\hat\beta_0^{(MLE)}, \hat\beta_1^{(MLE)}, \hat\sigma^{(MLE)} &= \argmax_{\beta_0, \beta_1, \sigma} \sum_{i = 1}^n \frac{1}{\sqrt{2 \sigma^2 \pi}} \exp \left( - \frac{1}{2 \sigma^2} (y_i - \beta_0 - \beta_1 x_i)^2 \right) \\
&= \argmax_{\beta_0, \beta_1, \sigma} \sum_{i = 1}^n \frac{1}{\sqrt{2 \sigma^2 \pi}} \exp \left( - \frac{1}{2 \sigma^2} \cdot \epsilon^2 \right)
\end{aligned}
$$
For numerical reasons [^ll], in practice, the log-likelihood maximized instead of the likelihood,
$$
\begin{aligned}[t]
\hat\beta_0^{(MLE)}, \hat\beta_1^{(MLE)}, \hat\sigma^{(MLE)} &= \argmax_{\beta_0, \beta_1, \sigma} -\frac{n}{2} \log \sigma^2 - \sum_{i = 1}^n \left( - \frac{1}{2 \sigma^2} (y_i - \beta_0 - \beta_1 x_i)^2 \right) , \\
&= \argmax_{\beta_0, \beta_1, \sigma} -\frac{n}{2} \log \sigma^2 - \sum_{i = 1}^n \left( - \frac{1}{2 s^2} \cdot \epsilon^2 \right) .
\end{aligned}
$$

Even though the estimators are different, both MLE and OLS will produce the same linear regression esimates for $\beta_0$ and $\beta_1$,
$$
\hat\beta_0^{(MLE)} =  \hat\beta_0^{(OLS)} \text{ and } \hat\beta_1^{(MLE)} =  \hat\beta_1^{(OLS)} .
$$

Some intuition as to why the OLS and MLE estimates agree can be gained from noticing that the likelihood function of the normal distribution includes the negative sum of squared errors, so maximizing the likelihood, minimizes the squared errors.

That is all that will be said about MLE for now, since it is not necessary for most of the material on linear models.
But MLE is perhaps the most commonly used to estimator and will reappear many times, notably with generalized linear models, e.g. logit, probit, binomial, Poisson models.

[^ll]: Probabilities can get quite small, so multiplying them together can result in numbers too small to represent as different than zero. Adding the logarithms of probabilities can represent much smaller floating point numbers.

[^mle-sigma]: However, the MLE estimator of the regression standard error is not the same as the OLS estimator, $\hat\sigma_{MLE} \neq \hat\sigma_{OLS}$.

# Anscombe quartet


```r
anscombe_tidy <-
  anscombe %>%
  mutate(obs = row_number()) %>%
  gather(variable_dataset, value, -obs) %>%
  separate(variable_dataset, c("variable", "dataset"), sep = c(1)) %>%
  spread(variable, value) %>%
  arrange(dataset, obs)
```

What are summary statistics of the four anscombe datasets?

```r
ggplot(anscombe_tidy, aes(x = x, y = y)) +
  geom_point() + 
  geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(~ dataset, ncol = 2)
```

![](regression_files/figure-latex/unnamed-chunk-3-1.pdf)<!-- --> 

What are the mean, standard deviation, correlation coefficient, and regression
coefficients of each line? 

```r
anscombe_summ <-
  anscombe_tidy %>%
  group_by(dataset) %>%
  summarise(
    mean_x = mean(x),
    mean_y = mean(y),
    sd_x = sd(x),
    sd_y = sd(y),
    cov = cov(x, y),
    cor = cor(x, y),
    coefs = list(coef(lm(y ~ x, data = .)))
  ) %>%
  mutate(
    intercept = map_dbl(coefs, "(Intercept)"),
    slope = map_dbl(coefs, "x")
  ) %>%
  select(-coefs)
```

WUT? They are the same? But they look so different. Of course that was the point ...

Since this all revolves around covariance, lets calculate the values of $x_i - \bar{x}$,
$y_i - \bar{y}$, and $(x_i - \bar{x}) (y_i - \bar{y})$ for each obs for each variable.

```r
anscombe_tidy <-
  anscombe_tidy %>%
  group_by(dataset) %>%
  mutate(mean_x = mean(x),
         diff_mean_x = x - mean_x,
         mean_y = mean(y),
         diff_mean_y = y - mean_y,
         diff_mean_xy = diff_mean_x * diff_mean_y,
         quadrant = 
           if_else(
             diff_mean_x > 0, 
             if_else(diff_mean_y > 0, 1, 2),
             if_else(diff_mean_y > 0, 4, 3),
           ))
```



```r
ggplot(anscombe_tidy, aes(x = x, y = y,
                          size = abs(diff_mean_xy),
                          colour = factor(sign(diff_mean_xy)))) +
  geom_point() +
  geom_hline(data = anscombe_summ,
             aes(yintercept = mean_y)) +
  geom_vline(data = anscombe_summ,
             aes(xintercept = mean_x)) +  
  facet_wrap(~ dataset, ncol = 2)
```

![](regression_files/figure-latex/unnamed-chunk-6-1.pdf)<!-- --> 


```r
ggplot(anscombe_tidy, aes(x = x, y = y, colour = factor(sign(diff_mean_xy)))) +
  geom_point() +
  geom_segment(mapping = aes(xend = mean_x, yend = mean_y)) +
  geom_hline(data = anscombe_summ,
             aes(yintercept = mean_y)) +
  geom_vline(data = anscombe_summ,
             aes(xintercept = mean_x)) + 
  facet_wrap(~ dataset, ncol = 2)
```

![](regression_files/figure-latex/unnamed-chunk-7-1.pdf)<!-- --> 


```r
ggplot(anscombe_tidy, aes(x = x, y = y, colour = factor(sign(diff_mean_xy)))) +
  geom_point() +
  geom_segment(mapping = aes(xend = x, yend = mean_y)) +
  geom_segment(mapping = aes(xend = mean_x, yend = y)) +  
  geom_hline(data = anscombe_summ,
             aes(yintercept = mean_y)) +
  geom_vline(data = anscombe_summ,
             aes(xintercept = mean_x)) +  
  facet_wrap(~ dataset, ncol = 2)
```

![](regression_files/figure-latex/unnamed-chunk-8-1.pdf)<!-- --> 

<a title="By DenisBoigelot, original uploader was Imagecreator (Own work, original uploader was Imagecreator) [CC0], via Wikimedia Commons" href="https://commons.wikimedia.org/wiki/File%3ACorrelation_examples2.svg"><img width="256" alt="Correlation examples2" src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Correlation_examples2.svg/256px-Correlation_examples2.svg.png"/></a>


