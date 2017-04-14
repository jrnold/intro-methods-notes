
# What is Regression?


```r
library("tidyverse")
library("modelr")
library("stringr")
```


## Joint vs. Conditional models

In most problems, the researcher is concerned with *relationships* between multiple variables.
For example, suppose that we want to model the relationship between two variables, $Y$ and $X$. There are two main approaches to modeling this relationship.

1. **joint model:** Jointly model $Y$ and $X$ as $f(Y, X)$. For example, we can model $Y$ and $X$ as coming from a bivariate normal distribution.[^generative]
2. **conditional model:** Model $Y$ as a conditional function of $X$. This means we calculate a function of $Y$ for each value of $X$.[^discriminative] Most often we focus on modeling a conditional statistic of $Y$, and linear regression will focus on modeling the conditional mean of $Y$, $\E(Y | X)$.

regression (conditional) model
:  $p(y | x_1, \dots, x_k) = f(x_1, \dots, x_k)$ and $x_1, \dots, x_k$ are given.
  
joint model
:   $p(y, x_1, \dots, x_k) = f(y, x_1, \dots, x_k)$
  
If we knew the joint model we could calculate the conditional model, 
$$
(y | x_1, \dots, x_k) = \frac{p(y, x_1, \dots, x_k)}{p(x_1, \dots, x_k)} .
$$ 
However, especially when there are specific outcome variables of interest, the *conditional model*, i.e. regression, is easier because the analyst can focus on modeling how  $Y$ varies with respect to $X$, without necessarily having to model the process by which $X$ is generated.
However, that very convenience of not modling the process which generates $X$ will be the problem when regression is used for causal inference on observational data.

[^generative]: In machine learning, these are called [generative models](https://en.wikipedia.org/wiki/Generative_model).

[^discriminative]: In machine learning, these are called [discriminative models](https://en.wikipedia.org/wiki/Discriminative_model).

At its most general, "*regression analysis*, broadly construed, traces the distribution of a response variable (denoted by $Y$)---or some characteristic of this distribution (such as its mean)---as a function of one of more explanatory variables [@Fox2016a, p. 15]." is a procedure that is used to summarize *conditional* relationships. That is, the average value of an outcome variable conditional on different values of one or more explanatory variables.

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

<img src="cef_files/figure-html/unnamed-chunk-4-1.svg" width="672" />

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

<img src="cef_files/figure-html/unnamed-chunk-7-1.svg" width="672" />


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

<img src="cef_files/figure-html/unnamed-chunk-8-1.svg" width="672" />


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

<img src="cef_files/figure-html/unnamed-chunk-9-1.svg" width="672" />

<a title="By DenisBoigelot, original uploader was Imagecreator (Own work, original uploader was Imagecreator) [CC0], via Wikimedia Commons" href="https://commons.wikimedia.org/wiki/File%3ACorrelation_examples2.svg"><img width="256" alt="Correlation examples2" src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Correlation_examples2.svg/256px-Correlation_examples2.svg.png"/></a>

<img src="cef_files/figure-html/unnamed-chunk-10-1.svg" width="672" />





## Conditional expectation function

The conditional expectation function 

### Conditional expectation function with discrete covariates

Before turning to considering continuous variable, it is useful to consider the 
conditional expectation function for a discrete $Y$ and $X$.

Consider the [datasets](https://www.rdocumentation.org/packages/datasets/topics/Titanic) dataset included in the recommended R package **[datasets](https://cran.r-project.org/package=datasets)**.
It is a cross-tabulation of the survival of the 2,201 passengers in the sinking of the [Titanic](https://en.wikipedia.org/wiki/RMS_Titanic) in 1912, as well as characteristics of those
passengers: passenger class, gender, and age.

```r
Titanic <- as_tibble(datasets::Titanic) %>%
  mutate(Survived = (Survived == "Yes"))
```
The proportion of passengers who survived was

```r
summarise(Titanic, prop_survived = sum(n * Survived) / sum(n))
```

```
## # A tibble: 1 × 1
##   prop_survived
##           <dbl>
## 1      0.323035
```

Since `Survived` is a 

A conditional expectation function is a function that calculates the mean of `Y` for different values of `X`. For example, the conditional expectation function for 

Calculate the CEF for `Survived` conditional on `Age`,

```r
Titanic %>% group_by(Age) %>% summarise(prop_survived = sum(n * Survived) / sum(n))
```

```
## # A tibble: 2 × 2
##     Age prop_survived
##   <chr>         <dbl>
## 1 Adult     0.3126195
## 2 Child     0.5229358
```
conditional on `Sex`,

```r
Titanic %>% group_by(Sex) %>% summarise(prop_survived = sum(n * Survived) / sum(n))
```

```
## # A tibble: 2 × 2
##      Sex prop_survived
##    <chr>         <dbl>
## 1 Female     0.7319149
## 2   Male     0.2120162
```
conditional on `Class`,

```r
Titanic %>%
  group_by(Class) %>%
  summarise(prop_survived = sum(n * Survived) / sum(n))
```

```
## # A tibble: 4 × 2
##   Class prop_survived
##   <chr>         <dbl>
## 1   1st     0.6246154
## 2   2nd     0.4140351
## 3   3rd     0.2521246
## 4  Crew     0.2395480
```
finally, conditional on all combinations of the other variables (`Age`, `Sex`, `Class`),

```r
titanic_cef_3 <-
  Titanic %>% 
  group_by(Class, Age, Sex) %>%
  summarise(prop_survived = sum(n * Survived) / sum(n))
titanic_cef_3
```

```
## Source: local data frame [16 x 4]
## Groups: Class, Age [?]
## 
##    Class   Age    Sex prop_survived
##    <chr> <chr>  <chr>         <dbl>
## 1    1st Adult Female    0.97222222
## 2    1st Adult   Male    0.32571429
## 3    1st Child Female    1.00000000
## 4    1st Child   Male    1.00000000
## 5    2nd Adult Female    0.86021505
## 6    2nd Adult   Male    0.08333333
## 7    2nd Child Female    1.00000000
## 8    2nd Child   Male    1.00000000
## 9    3rd Adult Female    0.46060606
## 10   3rd Adult   Male    0.16233766
## 11   3rd Child Female    0.45161290
## 12   3rd Child   Male    0.27083333
## 13  Crew Adult Female    0.86956522
## 14  Crew Adult   Male    0.22273782
## 15  Crew Child Female           NaN
## 16  Crew Child   Male           NaN
```

The CEF can be used to predict outcome variables given $X$ variables. 
What is the predicted probability of surival for each of these characters from the movie *Titanic*?

- Rose (Kate Winslet): 1st class, adult female (survived)
- Rose (Kate Winslet): 1st class, adult female (survived)
- Cal (Billy Zane) : survived, 1st class, adult, male


```r
titanic_chars <- 
  tribble(
    ~ name, ~ Class, ~ Age, ~ Sex, ~ Survived,
    "Rose", "1st", "Adult", "Female", TRUE,
    "Jack", "3rd", "Adult", "Male", FALSE,
    "Cal", "1st", "Adult", "Male", TRUE
  )

left_join(titanic_chars, titanic_cef_3,
          by = c("Class", "Age", "Sex"))
```

```
## # A tibble: 3 × 6
##    name Class   Age    Sex Survived prop_survived
##   <chr> <chr> <chr>  <chr>    <lgl>         <dbl>
## 1  Rose   1st Adult Female     TRUE     0.9722222
## 2  Jack   3rd Adult   Male    FALSE     0.1623377
## 3   Cal   1st Adult   Male     TRUE     0.3257143
```

Rose was predicted to survive 97% of 1st class adult females surved, and she did.
Jack was not predicted to survive (only 16% of 3rd class adult males survived, and he did not.[^jack] 
Cal was not predicted to survive (33% of 1st class adult males surived), but he did, though through less than honorable means in the movie.

[^jack]: However, this CEF does not condition on holding onto a piece of flotsam with enough room for two.

- Note that we haven't made any assumptions about distributions of the variables.
- In this case, the outcome variable in the CEF was a binary variable, and we calculated a proportion. However, the proportion is the expected value (mean) of a binary variable, so the calculation of the CEF wouldn't change. 
- If we continued to condition on more discrete variables, the number of observed cell sizes would get smaller and smaller (and possibly zero), with larger standard errors.

But what happens if the conditioning variables are continuous? 




## Regression to the Mean

@Galton1886a examined the joint distribution of the heights of parents and their children. He was estimating the average height of children conditional upon the height of their parents. He found that this relationship was approximately linear with a slope of 2/3. 

This means that on average taller parents had taller children, but the children of taller parents were on average shorter than they were, and the children of shorter parents were on average taller than they were. In other words, children's height was more average than parent's height. 

This phenomenon was called regression to the mean, and the term regression is now used to describe conditional relationships (Hansen 2010).

His key insight was that if the marginal distributions of two variables are the same, then the linear slope will be less than one. 

He also found that when the variables are standardized, the slope of the regression of $y$ on $x$ and $x$ on $y$ are the same. They are both the correlation between $x$ and $y$, and they both show regression to the mean.


```r
library("HistData")
```



```r
Galton <- as_tibble(Galton)
Galton
```

```
## # A tibble: 928 × 2
##    parent child
##     <dbl> <dbl>
## 1    70.5  61.7
## 2    68.5  61.7
## 3    65.5  61.7
## 4    64.5  61.7
## 5    64.0  61.7
## 6    67.5  62.2
## 7    67.5  62.2
## 8    67.5  62.2
## 9    66.5  62.2
## 10   66.5  62.2
## # ... with 918 more rows
```

1. Calculate the regression of children's heights on parents. Interpret the regression.

```r
child_reg <- lm(child ~ parent, data=Galton)
child_reg
```

```
## 
## Call:
## lm(formula = child ~ parent, data = Galton)
## 
## Coefficients:
## (Intercept)       parent  
##     23.9415       0.6463
```



###Reverse Regression
3. Calculate the regression of parent's heights on children's heights. Interpret the regression.

```r
parent_reg <- lm(parent ~ child, data=Galton)
parent_reg
```

```
## 
## Call:
## lm(formula = parent ~ child, data = Galton)
## 
## Coefficients:
## (Intercept)        child  
##     46.1353       0.3256
```

5. Check the mean and variance of parents' and childrens' height

```r
mean(Galton$parent)
```

```
## [1] 68.30819
```

```r
mean(Galton$child)
```

```
## [1] 68.08847
```

```r
var(Galton$parent)
```

```
## [1] 3.194561
```

```r
var(Galton$child)
```

```
## [1] 6.340029
```

6. Perform both regressions using standardized variables.

```r
parent.std <- (Galton$parent-mean(Galton$parent))/sd(Galton$parent)
child.std <- (Galton$child-mean(Galton$child))/sd(Galton$child)

summary(child.std.reg <- lm(child.std ~ parent.std))
```

```
## 
## Call:
## lm(formula = child.std ~ parent.std)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -3.09976 -0.54256  0.01934  0.64889  2.35368 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 2.990e-15  2.918e-02    0.00        1    
## parent.std  4.588e-01  2.920e-02   15.71   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.889 on 926 degrees of freedom
## Multiple R-squared:  0.2105,	Adjusted R-squared:  0.2096 
## F-statistic: 246.8 on 1 and 926 DF,  p-value: < 2.2e-16
```

```r
summary(parent.std.reg <- lm(parent.std ~ child.std))
```

```
## 
## Call:
## lm(formula = parent.std ~ child.std)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -2.6129 -0.6547 -0.0823  0.6336  2.3903 
## 
## Coefficients:
##               Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -2.327e-15  2.918e-02    0.00        1    
## child.std    4.588e-01  2.920e-02   15.71   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.889 on 926 degrees of freedom
## Multiple R-squared:  0.2105,	Adjusted R-squared:  0.2096 
## F-statistic: 246.8 on 1 and 926 DF,  p-value: < 2.2e-16
```

Regression calculates the conditional expectation function, $f(Y, X) = \E(Y | X) + \epsilon$, but we could instead jointly model $Y$ and $X$.

This is a topic for multivariate statistics (principal components, factor analyis, clustering).
In this case, an alternative would be to model the heights of fathers and sons as a bivariate normal distribution.

```r
ggplot(Galton, aes(y = child, x = parent)) +
  geom_jitter() +
  geom_density2d()
```

<img src="cef_files/figure-html/unnamed-chunk-24-1.svg" width="672" />

```r
# covariance matrix
Galton_mean <- c(mean(Galton$parent), mean(Galton$child))
# variance covariance matrix
Galton_cov <- cov(Galton)
Galton_cov
```

```
##          parent    child
## parent 3.194561 2.064614
## child  2.064614 6.340029
```

```r
var(Galton$parent)
```

```
## [1] 3.194561
```

```r
var(Galton$child)
```

```
## [1] 6.340029
```

```r
cov(Galton$parent, Galton$child)
```

```
## [1] 2.064614
```
Calculate density for a multivariate normal distribution

```r
library("mvtnorm")
Galton_mvnorm <- function(parent, child) {
  # mu and Sigma will use the values calculated earlier
  dmvnorm(cbind(parent, child), mean = Galton_mean,
          sigma = Galton_cov)
}
```


```r
Galton_mvnorm(Galton$parent[1], Galton$child[1])
```

```
## [1] 4.272599e-05
```


```r
Galton_dist <- Galton %>%
  modelr::data_grid(parent = seq_range(parent, 50), child = seq_range(child, 50)) %>%
  mutate(dens = map2_dbl(parent, child, Galton_mvnorm))
```
Why don't I calculate the mean and density using the data grid? 


```r
library("viridis")
ggplot(Galton_dist, aes(x = parent, y = child)) +
  geom_raster(mapping = aes(fill = dens)) +
  #geom_contour(mapping = aes(z = dens), colour = "white", alpha = 0.3) +
  #geom_jitter(data = Galton, colour = "white", alpha = 0.2) +
  scale_fill_viridis() +
  theme_minimal() +
  theme(panel.grid = element_blank()) +
  labs(y = "Parent height (in)", x = "Child height (in)")
```

<img src="cef_files/figure-html/unnamed-chunk-29-1.svg" width="672" />

Using the [plotly](https://plot.ly/r/getting-started/) library
we can make an interactive 3D plot:


```r
x <- unique(Galton_dist$parent)
y <- unique(Galton_dist$child)
z <- Galton_dist %>%
     arrange(child, parent) %>%
     spread(parent, dens) %>%
     select(-child) %>%
     as.matrix()
plotly::plot_ly(z = z, type = "surface")
```

<!--html_preserve--><div id="htmlwidget-98726c7fce9588e42afe" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-98726c7fce9588e42afe">{"x":{"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"showlegend":false,"xaxis":{"domain":[0,1]},"yaxis":{"domain":[0,1]}},"source":"A","config":{"modeBarButtonsToAdd":[{"name":"Collaborate","icon":{"width":1000,"ascent":500,"descent":-50,"path":"M487 375c7-10 9-23 5-36l-79-259c-3-12-11-23-22-31-11-8-22-12-35-12l-263 0c-15 0-29 5-43 15-13 10-23 23-28 37-5 13-5 25-1 37 0 0 0 3 1 7 1 5 1 8 1 11 0 2 0 4-1 6 0 3-1 5-1 6 1 2 2 4 3 6 1 2 2 4 4 6 2 3 4 5 5 7 5 7 9 16 13 26 4 10 7 19 9 26 0 2 0 5 0 9-1 4-1 6 0 8 0 2 2 5 4 8 3 3 5 5 5 7 4 6 8 15 12 26 4 11 7 19 7 26 1 1 0 4 0 9-1 4-1 7 0 8 1 2 3 5 6 8 4 4 6 6 6 7 4 5 8 13 13 24 4 11 7 20 7 28 1 1 0 4 0 7-1 3-1 6-1 7 0 2 1 4 3 6 1 1 3 4 5 6 2 3 3 5 5 6 1 2 3 5 4 9 2 3 3 7 5 10 1 3 2 6 4 10 2 4 4 7 6 9 2 3 4 5 7 7 3 2 7 3 11 3 3 0 8 0 13-1l0-1c7 2 12 2 14 2l218 0c14 0 25-5 32-16 8-10 10-23 6-37l-79-259c-7-22-13-37-20-43-7-7-19-10-37-10l-248 0c-5 0-9-2-11-5-2-3-2-7 0-12 4-13 18-20 41-20l264 0c5 0 10 2 16 5 5 3 8 6 10 11l85 282c2 5 2 10 2 17 7-3 13-7 17-13z m-304 0c-1-3-1-5 0-7 1-1 3-2 6-2l174 0c2 0 4 1 7 2 2 2 4 4 5 7l6 18c0 3 0 5-1 7-1 1-3 2-6 2l-173 0c-3 0-5-1-8-2-2-2-4-4-4-7z m-24-73c-1-3-1-5 0-7 2-2 3-2 6-2l174 0c2 0 5 0 7 2 3 2 4 4 5 7l6 18c1 2 0 5-1 6-1 2-3 3-5 3l-174 0c-3 0-5-1-7-3-3-1-4-4-5-6z"},"click":"function(gd) { \n        // is this being viewed in RStudio?\n        if (location.search == '?viewer_pane=1') {\n          alert('To learn about plotly for collaboration, visit:\\n https://cpsievert.github.io/plotly_book/plot-ly-for-collaboration.html');\n        } else {\n          window.open('https://cpsievert.github.io/plotly_book/plot-ly-for-collaboration.html', '_blank');\n        }\n      }"}],"modeBarButtonsToRemove":["sendDataToCloud"]},"data":[{"colorbar":{"title":"","ticklen":2},"colorscale":[["0","rgba(68,1,84,1)"],["0.000529343603276335","rgba(68,1,84,1)"],["0.00227206992284697","rgba(68,2,85,1)"],["0.00597453388057551","rgba(68,3,86,1)"],["0.0127719448683592","rgba(69,6,88,1)"],["0.0210190402676754","rgba(69,10,91,1)"],["0.0297649875447246","rgba(70,14,93,1)"],["0.0388906971635541","rgba(70,18,96,1)"],["0.0492539175890977","rgba(71,21,100,1)"],["0.0603475012199725","rgba(71,25,103,1)"],["0.0738152000188751","rgba(71,29,108,1)"],["0.0880654163610076","rgba(72,33,112,1)"],["0.106717273508166","rgba(72,39,119,1)"],["0.128831168249898","rgba(71,46,123,1)"],["0.154584143249543","rgba(69,54,127,1)"],["0.186959312183731","rgba(66,64,132,1)"],["0.225774184345671","rgba(62,75,137,1)"],["0.273088436593058","rgba(58,88,139,1)"],["0.326467910425354","rgba(50,102,142,1)"],["0.390195398258206","rgba(45,117,142,1)"],["0.477039978899036","rgba(38,138,141,1)"],["0.569421503753257","rgba(35,161,135,1)"],["0.686151486603094","rgba(66,187,116,1)"],["0.829554905058708","rgba(145,213,71,1)"],["1","rgba(253,231,37,1)"]],"showscale":true,"z":[[0.000595325367697224,0.000695515498229165,0.000801770993559972,0.000911979286069026,0.00102355389115714,0.00113351574891314,0.00123861264352887,0.0013354713169048,0.00142077310060705,0.00149144070837297,0.00154482171347777,0.00157885353148108,0.00159219562439088,0.00158431711849954,0.00155553185393,0.00150697764050464,0.00144054163105956,0.00135873863446109,0.0012645533033652,0.00116125998690797,0.00105223535271552,0.00094077858186655,0.000829952159938087,0.000722453339614983,0.000620522669156327,0.000525892050953003,0.000439771080131696,0.000362867298625864,0.000295433746852055,0.00023733592359653,0.000188129958892227,0.00014714433543756,0.000113558655151565,8.64744958764541e-05,6.49750979065679e-05,4.81722522429366e-05,3.52401758127928e-05,2.54372575134703e-05,1.81173056913932e-05,1.27323346037616e-05,8.82904194077262e-06,6.04101928169322e-06,4.07847654856105e-06,2.71691982282831e-06,1.78585741324519e-06,1.15826476442937e-06,7.41241991664814e-07,4.6806189784236e-07,2.91633674319721e-07,1.79292926266937e-07],[0.000705880183934971,0.000829479420868945,0.000961770267141182,0.00110034324940316,0.00124215595408667,0.00138361471742401,0.0015207062326395,0.00164917439886925,0.00176473276167998,0.0018632984286112,0.00194122999222866,0.00199555027169157,0.00202413492695037,0.00202585030024152,0.00200062801927073,0.00194946951913189,0.00187438006612008,0.00177823834189525,0.00166461340960564,0.00153754527511835,0.00140130781060586,0.00126017331183731,0.00111819647388475,0.00097903239992895,0.000845798900150849,0.000720988392871588,0.000606429801696166,0.00050329649230042,0.000412152916227416,0.000333030459067017,0.000265522079350134,0.000208885565565357,0.000162146405556965,0.000124193059644189,9.38595424803249e-05,6.99923611968535e-05,5.15007984210612e-05,3.73911123122774e-05,2.67863730557625e-05,1.89343563631144e-05,1.32062126431635e-05,9.0886029409254e-06,6.17173230721295e-06,4.13531061607218e-06,2.73401125087242e-06,1.78354291644493e-06,1.14804242151163e-06,7.29160969279354e-07,4.56961905329142e-07,2.825710627883e-07],[0.000826997406395928,0.000977464460156595,0.00113995815412847,0.00131180097272877,0.00148949171968964,0.00166878098825474,0.00184481023307083,0.00201231127260625,0.00216585673821871,0.00230014597468169,0.00241030596817738,0.00249218374530532,0.00254260588330961,0.00255958255473532,0.00254243782385712,0.00249185430282542,0.00240982805542233,0.00229953790097059,0.00216514104613038,0.00201151335408991,0.00184395684312959,0.00166789877666506,0.00148860589112777,0.00131093416520302,0.0011391295979358,0.000976689448484455,0.000826287078010301,0.000689757659179004,0.000568137175367312,0.000461743711307763,0.000370288203211496,0.000293001516975849,0.000228765730458985,0.000176239466843883,0.000133969667431587,0.000100484920603771,7.43680533511915e-05,5.43079036683027e-05,3.9131885114567e-05,2.78220807113992e-05,1.95181902984586e-05,1.35107853807587e-05,9.22810968772213e-06,6.2192212365004e-06,4.13571278036458e-06,2.71366253732225e-06,1.75692172802519e-06,1.12238045149647e-06,7.07487676783315e-07,4.400365699187e-07],[0.000957356876150622,0.00113813267484505,0.00133506689811724,0.00154526963207838,0.0017648045594306,0.00198874943764769,0.00221133544949235,0.00242616476804741,0.00262649791830254,0.00280559472014373,0.00295708573130437,0.00307534612022591,0.00315584156855349,0.00319541661419456,0.00319249988988937,0.00314720765170834,0.00306133609027955,0.00293824313351422,0.00278263058192901,0.00260024627716216,0.00239753258359466,0.00218125107588886,0.00195811369269737,0.00173444788725662,0.00151591800935936,0.00130731810200383,0.00111244344804459,0.000934040517388214,0.000773828275049513,0.000632578720724002,0.000510241370348099,0.00040609520673845,0.000318912222405311,0.000247118676942761,0.000188943119624817,0.000142543592066912,0.00010610978174467,7.79388959093647e-05,5.6486437148644e-05,4.03947776247454e-05,2.85034458501661e-05,1.9845434687864e-05,1.36337388626611e-05,9.24188227802014e-06,6.18154447935055e-06,4.07966657560324e-06,2.65670570070129e-06,1.70707786251047e-06,1.08231659796999e-06,6.77090019749347e-07],[0.00109506558474808,0.00130942721739365,0.00154494741747422,0.00179861059404916,0.00206610170937664,0.00234184071523596,0.00261911225829583,0.00289029372171889,0.00314717542459362,0.00338135702369439,0.00358469501009937,0.0037497688719099,0.00387032908137621,0.00394168933595211,0.00396102877210732,0.00392757699136303,0.00384266498272911,0.0037096372500668,0.00353363323051647,0.00332125791525991,0.00308017108729886,0.00281863073281983,0.00254502839059674,0.00226745243407877,0.00199330999643387,0.00172903032231172,0.00147986289116191,0.00124977391478938,0.00104143588259029,0.000856297594440866,0.000694717143797792,0.000556137799320262,0.000439286561049999,0.000342376955647284,0.000263300837275905,0.00019979796467492,0.000149596345734901,0.000110520289930931,8.05664358804801e-05,5.79505274570844e-05,4.11293399789568e-05,2.88029647406388e-05,1.99027803807668e-05,1.3570048949588e-05,9.12935684997378e-06,6.0602432654722e-06,3.96945641328857e-06,2.56544744886212e-06,1.63601135548947e-06,1.02943898282625e-06],[0.00123766456156017,0.00148856016203689,0.00176652965924127,0.00206855265560439,0.00239002989352834,0.00272477841923719,0.0030651388617247,0.00340220300096795,0.00372615912752862,0.00402674082312631,0.00429375305066797,0.00451763931068424,0.00469004651636964,0.00480434129816147,0.0048560333328804,0.00484306805610693,0.00476596216273056,0.00462776943986323,0.00443388008122516,0.0041916718654971,0.00391004465913441,0.00359887915042961,0.00326846556996277,0.0029289480651234,0.00258982568094039,0.00225954242782583,0.00194518796346913,0.00165231844902639,0.00138489560161072,0.00114533208049229,0.000934623981260366,0.000752546812610242,0.000597889912991826,0.000468705487117968,0.000362551707306666,0.000276713900995572,0.000208392989395474,0.00015485539413225,0.000113543081505856,8.21459432444725e-05,5.86411759069807e-05,4.1305732253404e-05,2.87084064441479e-05,1.96878799396721e-05,1.33223219244277e-05,8.8951238830049e-06,5.86023704455816e-06,3.80951310078033e-06,2.44351418719304e-06,1.54650512608703e-06],[0.00138217278465142,0.00167204505596634,0.00199583539440496,0.00235067489885702,0.00273181650716172,0.00313257577820811,0.00354440019365511,0.00395708175583943,0.00435911573949111,0.00473819448263175,0.005081810551792,0.00537793023576249,0.00561568789742194,0.00578604580572751,0.00588236375951471,0.00590082850121824,0.00584070421887023,0.00570438119936511,0.00549721814901699,0.00522719267945531,0.00490439173254795,0.00454038729633901,0.0041475511775011,0.00373836509254222,0.00332477895878897,0.00291766178785809,0.00252637737377913,0.00215850273970247,0.00181969285898597,0.00151368212648688,0.00124240268226439,0.00100619274902554,0.000804064877045157,0.000634004157419455,0.000493269457179955,0.000378675711465359,0.000286841364934698,0.00021439132891303,0.000158111608772432,0.000115056565088418,8.26133354243367e-05,5.85302008527443e-05,4.09167355941929e-05,2.82236414586498e-05,1.92095070650662e-05,1.29006175457356e-05,8.54861749951295e-06,5.58949247750897e-06,3.60611831904088e-06,2.29561299043273e-06],[0.0015251700729068,0.00185577840291116,0.00222805066851699,0.00263946018489772,0.00308529199938605,0.00355851283166069,0.00404978441640102,0.00454764315460455,0.00503885613208175,0.0055089476296017,0.00594287279439789,0.0063257981584773,0.00664393434340881,0.00688535662054093,0.00704074558557424,0.0071039839165977,0.00707255596955507,0.00694771382951526,0.0067343945405434,0.00644089614057715,0.0060783421318347,0.00565998255234333,0.00520039280483006,0.00471463754662285,0.00421746588038462,0.00372259637882446,0.00324213749486902,0.00278617257136823,0.00236252113105159,0.00197667148055262,0.00163186563351253,0.00132930733771689,0.00106845814261525,0.00084738491732564,0.000663124466322437,0.000512035979969466,0.000390118919088506,0.000293281487752651,0.000217552157515527,0.000159233061100287,0.000114999035775848,8.19494907919017e-05,5.7622145560469e-05,3.99782423643129e-05,2.73683788716871e-05,1.84869623017838e-05,1.2321771289518e-05,8.10348507576328e-06,5.25849705860036e-06,3.36699552764045e-06],[0.00166291774807843,0.00203517056349349,0.00245766090943076,0.00292842574794356,0.00344300439474088,0.00399422056032167,0.00457211993480515,0.00516409580750728,0.0057552219020873,0.00632879401739178,0.00686706177380282,0.00735211095926221,0.00776683818355916,0.00809594532747161,0.00832687378375333,0.00845059916461656,0.00846221642618304,0.00836126253464511,0.00815174708891746,0.00784188807699038,0.00744357703869894,0.00697162214906203,0.00644283634494771,0.00587504861062378,0.00528611898275118,0.0046930319361222,0.00411112981457818,0.00355352992242463,0.00303074828831986,0.00255053252324047,0.00211788789729865,0.00173526647669622,0.00140287989247193,0.0011190923054995,0.000880850964769677,0.000684116498911707,0.000524262507165938,0.000396422815041154,0.000295773722839698,0.000217746729019634,0.000158173890676052,0.000113372848980338,8.01815465589627e-05,5.59539696194745e-05,3.85281789268906e-05,2.61768368991632e-05,1.75487811286273e-05,1.16082794177775e-05,7.57669586408717e-06,4.87958582923652e-06],[0.00179151239853632,0.00220532227788587,0.00267864658012734,0.00321033145612383,0.00379643035455212,0.0044298814660843,0.00510034882485642,0.00579427040622562,0.00649514339897628,0.00718405807030232,0.00784046878296756,0.00844316606504191,0.00897139003236677,0.00940600597652177,0.00973065036565594,0.00993275198008114,0.0100043394722435,0.00994256306060606,0.00974988276849174,0.00943390587724695,0.00900688856383536,0.00848494722890376,0.00788705023838594,0.00723387790225465,0.00654664583376563,0.00584598403097604,0.00515095206286518,0.0044782516758174,0.00384167473546174,0.00325179973549275,0.00271592702611574,0.0022382237904107,0.0018200361910548,0.00146031869716702,0.00115612920754686,0.000903142346120249,0.000696140889735495,0.000529455162985247,0.000397330896232248,0.000294216206469848,0.000214967077224991,0.000154977416650167,0.000110244260431524,7.73810582798231e-05,5.35925531056156e-05,3.66239628241166e-05,2.46954717907598e-05,1.64308649457768e-05,1.07868497604771e-05,6.9874697270886e-06],[0.00190706468436346,0.00236123859351167,0.0028847317042191,0.00347745955617317,0.00413627926897916,0.0048545471593298,0.00562184284380104,0.00642391495765515,0.00724289135011708,0.00805777735903827,0.00884524082779552,0.00958065421281559,0.0102393355461843,0.0107979046978672,0.011235652802698,0.0115358137680902,0.0116866292769867,0.0116821130417231,0.0115224450754261,0.0112139597863702,0.0107687289927989,0.0102037781182942,0.00954000649666098,0.00880090716854249,0.0080111952255637,0.0071954555691979,0.00637691138402433,0.00557639556935207,0.00481158176694413,0.00409650296002294,0.00344135742098571,0.00285257711977044,0.00233311482569604,0.00188289428737667,0.00149936327000473,0.00117809117591945,0.000913360117501799,0.000698708924138565,0.000527401841716756,0.000392805987723754,0.000288672665311396,0.000209326557031982,0.000149773198324046,0.000105738947491327,7.36591949299169e-05,5.06302483861381e-05,3.43387319480353e-05,2.29799751488906e-05,1.51742054988695e-05,9.88674819571645e-06],[0.00200589218126121,0.00249806789171955,0.00306967215386019,0.00372195276560929,0.0044528782975777,0.00525656330729676,0.00612285646142836,0.00703715898797599,0.00798053034174814,0.00893011905142429,0.00985993041016434,0.0107419111613284,0.0115472978559514,0.0122481440610749,0.0128189162100535,0.0132380323261246,0.0134892148259146,0.0135625393297736,0.0134550853035205,0.0131711290764557,0.0127218614552953,0.0121246559250568,0.0114019541371022,0.0105798683117652,0.00968662171330924,0.00875095645947059,0.00780063238528339,0.00686112301332209,0.00595458783073634,0.00509916788195884,0.00430861829568169,0.00359226061963857,0.00295521279812468,0.00239883726012841,0.00192133864669364,0.00151844182037777,0.00118408669147115,0.000911087207601136,0.000691715493264738,0.000518186582046942,0.000383032767633125,0.000279368090495804,0.000201052174997549,0.00014276832277088,0.00010003363370719,6.91594192181669e-05,4.71788918407976e-05,3.17566907221225e-05,2.10918099130166e-05,1.38224033947255e-05],[0.00208471313774773,0.00261135044112232,0.00322756589391161,0.00393619117146621,0.00473661792042497,0.00562408181756812,0.00658909868200057,0.00761713230491486,0.00868856574735119,0.00977903026065174,0.0108601192412089,0.0119004806598303,0.0128672434373284,0.013727695509487,0.0144510985663843,0.0150105012255908,0.0153844023966182,0.0155581220056269,0.0155247573299145,0.0152856381090131,0.0148502386085197,0.0142355547420572,0.0134650033296998,0.012566942848807,0.0115729458321802,0.0105159692190341,0.00942856930127947,0.00834129333894317,0.00728135317508018,0.00627165130734066,0.00533019156362451,0.00446986942165404,0.00369860506820522,0.00301975834497812,0.00243275024644898,0.00193381073084079,0.00151677622254978,0.00117387043180668,0.000896416662397992,0.000675446231570518,0.00050218386054602,0.000368405261832189,0.000266673587498508,0.000190469432508286,0.000134233736024235,9.33445944346956e-05,6.40483246253973e-05,4.33628162570264e-05,2.89679853448495e-05,1.90945843616942e-05],[0.00214082701820032,0.00269725889588685,0.00335316401349338,0.00411318330695913,0.00497843037814654,0.00594563051526198,0.00700639311933278,0.00814670876755639,0.00934675774601867,0.0105811016703236,0.0118193037436952,0.0130269877719528,0.0141673043167698,0.01520272870351,0.0160970752280818,0.0168175801979641,0.0173368881191349,0.017634773711149,0.0176994487846752,0.017528336294395,0.0171282407230286,0.0165148990949611,0.0157119539128358,0.0147494414440035,0.0136619300387727,0.0124864690632103,0.0112605172292893,0.0100200096278796,0.00879769787676763,0.00762186152311273,0.00651544630328166,0.00549564145971408,0.0045738689599076,0.00375612598242309,0.00304360078926108,0.00243347187527811,0.0019198004094951,0.00149443466922194,0.0011478599252433,0.000869945325677857,0.000650558161376002,0.000480033344345588,0.000349500488574521,0.000251081823583878,0.000177981091875622,0.000124486874935845,8.59140848146033e-05,5.85054436739788e-05,3.93114706868032e-05,2.60635405629832e-05],[0.00217226801185825,0.00275281272139094,0.00344215982700853,0.00424694368556099,0.00517026827486702,0.00621070297713139,0.0073613852542983,0.00860933167571809,0.00993505869862193,0.01131260285353,0.0127100058291809,0.0140902942981633,0.0154129398663125,0.0166357356027985,0.0177169777676288,0.0186178006805552,0.0193044849183459,0.0197505487026455,0.0199384419527384,0.0198606920037337,0.0195203967398791,0.0189310197841459,0.018115506617267,0.0171048025052359,0.0159359056466257,0.0146496261129641,0.0132882392044025,0.0118932196401644,0.0105032220455205,0.00915243724697347,0.00786940828702768,0.00667634087242751,0.00558889604456232,0.00461641311908204,0.0037624817921271,0.00302576540276445,0.00240097260098239,0.00187988057750884,0.00145232703947235,0.00110710724005201,0.000832733553490213,0.000618035672355324,0.000452597475278235,0.000327040709769538,0.000233175336295278,0.000164041794836381,0.000113872149456002,7.79958741859769e-05,5.27128924155626e-05,3.5152253347438e-05],[0.0021779193469271,0.00277604981515546,0.0034914338876042,0.00433282846706752,0.00530554832622411,0.00641032662802276,0.00764224837923517,0.00898986652335898,0.0104346153464075,0.0119506286165464,0.0135050489235163,0.0150588802180469,0.0165683897154588,0.0179870122026229,0.0192676550600057,0.0203652526207993,0.0212393805372226,0.0218567203652117,0.0221931654737873,0.0222353828793984,0.0219816899779802,0.0214421658189207,0.0206379866641593,0.0196000468848666,0.0183669903764396,0.01698282725654,0.015494340343487,0.0139484932290106,0.0123900370791111,0.0108594797965633,0.00939153416512706,0.00801410760345906,0.00674784194180186,0.00560616323307573,0.00459576360809544,0.00371741228890729,0.00296698181322181,0.00233657724864643,0.00181566828866951,0.00139214341956238,0.00105322838428366,0.000786234752179888,0.000579125946301074,0.000420905804698534,0.000301847729114608,0.000213590541172039,0.000149130757836766,0.000102740940977733,6.98410819485163e-05,4.68456731344798e-05],[0.00215757914090727,0.00276614154639619,0.00349923548654999,0.0043678030358219,0.0053795262013466,0.00653756641507136,0.00783933648917283,0.00927542042425769,0.0108287669469884,0.0124742807950707,0.0141789192741351,0.0159023698387956,0.0175983388107145,0.0192164254433121,0.0207044949600387,0.0220114059210955,0.0230898988223223,0.0238994211515513,0.0244086545157261,0.0245975246127172,0.024458514292845,0.0239971599988398,0.0232316858871821,0.0221918093324036,0.0209168269408965,0.0194531528641075,0.0178515241307457,0.0161641066997383,0.0144417300022976,0.0127314491423385,0.0110745876118032,0.0095053561191938,0.00805008242317036,0.00672703004172403,0.00554673621570415,0.00451276547186367,0.00362275630033647,0.00286963448321768,0.00224287541215439,0.00172971608061823,0.00131624156598293,0.000988297018839826,0.000732201264810986,0.000535259728718774,0.000386091081718779,0.000274793259691419,0.000192980526610604,0.000133724814456461,9.14327171841108e-05,6.16853955605406e-05],[0.0021119723726239,0.00272344180887148,0.00346528591388895,0.00435061999657063,0.00538957271314205,0.00658792467597147,0.00794573395928796,0.00945606655308685,0.0111039660684932,0.0128658012242438,0.0147091187478602,0.0165931017502909,0.0184696899092536,0.0202853608325544,0.0219835069953068,0.0235072767408722,0.0248026891168254,0.0258217888128014,0.0265255859019922,0.0268865297600537,0.0268902984915893,0.0265367418778245,0.0258398913117539,0.024827035804899,0.0235369488757441,0.0220174268912813,0.0203223565819362,0.0185085619636471,0.016632686146293,0.0147483424585657,0.0129037262124235,0.0111398199506651,0.00948925918267061,0.00797586053860463,0.00661475707929604,0.0054130414596491,0.00437078971675307,0.0034823272177024,0.00273760223910501,0.00212354868906191,0.00162534366956899,0.00122749375321651,0.000914712223479204,0.000672575092756647,0.000487964449973088,0.000349322606199665,0.000246749513794922,0.00017197963583875,0.000118273881562189,8.0258637048713e-05],[0.00204270798594292,0.00264946603777482,0.00339079498729256,0.00428189302940084,0.00533532893786859,0.00655960505778114,0.0079576583520731,0.00952541689855469,0.0112505512137247,0.013111570512221,0.0150774096357172,0.0171076304049183,0.0191533210973761,0.0211587216501164,0.0230635346422848,0.0248058100284776,0.0263252234175551,0.0275665123320651,0.0284828004092175,0.0290385318539007,0.029211760374595,0.0289955872574512,0.0283986172346991,0.0274443901600893,0.0261698408108324,0.0246229272768903,0.0228596401429711,0.0209406521138741,0.0189278863625949,0.0168812710615906,0.0148559104311109,0.0128998454369018,0.0110525082205567,0.00934390236786525,0.00779447453989525,0.00641558848329175,0.00521047433317397,0.00417550615467973,0.00330165811979018,0.00257600190073168,0.00198313081471324,0.00150642547719668,0.00112910686169984,0.000835052050507225,0.000609372922456903,0.000438777009109289,0.000311742260365111,0.000218543856278639,0.000151172442341098,0.000103180531955053],[0.00195218466450952,0.00254680192556205,0.00327838948221601,0.00416406050611431,0.00521872750193728,0.00645361889108671,0.00787468363970408,0.00948099725631813,0.0112633098598277,0.0132028943632561,0.0152708555996431,0.0174280460178642,0.019625698873197,0.0218068366007811,0.0239084440483066,0.0258643198741867,0.0276084431686163,0.0290786257466549,0.0302201728319388,0.0309892535312102,0.0313556921478971,0.031304932675314,0.0308389982169756,0.0299763571914673,0.0287507086548554,0.0272087980939574,0.025407460997079,0.0234101546491231,0.0212832723887942,0.0190925364920732,0.0168997375793945,0.0147600353606758,0.0127199657062711,0.0108162218990621,0.00907520286358595,0.00751325624125756,0.00613749519621494,0.00494703787181571,0.00393450779858254,0.00308764023301679,0.00239085962263117,0.00182672246356932,0.0013771529180754,0.00102443137123434,0.00075192526519012,0.000544574863581136,0.000389163060833334,0.000274407978953994,0.000190920676835184,0.000131069095055858],[0.00184345297221271,0.00241895917204802,0.00313195936737863,0.00400124187602015,0.00504387827549576,0.00627372523562236,0.0076997654714629,0.00932439376550037,0.0111417861611013,0.0131365141559331,0.0152825759500382,0.0175430092712406,0.0198702224204584,0.022207131770191,0.0244891277114128,0.0266468126269304,0.0286093720535108,0.0303083635898528,0.0316816474593243,0.0326771469329668,0.0332561224301981,0.0333956726368257,0.0330902375994392,0.0323519662900283,0.0312099147718107,0.0297081487292364,0.0279029230710593,0.0258591901389955,0.0236467381724076,0.021336278493308,0.0189957832540864,0.0166873296456387,0.0144646387022349,0.0123714168609004,0.0104405264266686,0.00869393639449945,0.00714334499903123,0.0057913244736829,0.00463281839198806,0.00365682148163048,0.0028480876358644,0.00218873933465474,0.00165968566428966,0.00124179168675253,0.000916774994010523,0.000667832999984886,0.000480025266129836,0.00034044849945308,0.000238248325585266,0.000164512686819839],[0.00172004490474632,0.00227017043277076,0.00295643439679534,0.00379899861628389,0.00481682790039914,0.00602620955360541,0.00743906639649326,0.00906115888665138,0.0108903079856185,0.0129147999651537,0.0151121519297606,0.0174484174792669,0.0198781920447323,0.0223454356277911,0.0247851684490712,0.0271260169948045,0.0292935016961355,0.0312138727254983,0.0328182278779019,0.0340465964254882,0.0348516532803523,0.0352017433565871,0.0350829468328983,0.0344999975112322,0.0334759698213141,0.0320507633161978,0.0302785233963451,0.0282242306343455,0.0259597579124129,0.0235597278527197,0.0210975005185184,0.0186415855594973,0.0162527103742035,0.0139816958162566,0.0118682041485969,0.00994034075586462,0.00821502031903505,0.0066989558736209,0.00539009845054026,0.00427934581902943,0.00335234861628769,0.00259126645131457,0.0019763600879442,0.00148734316777544,0.00110445339950284,0.000809235106531151,0.000585050210097978,0.000417352163849245,0.000293767200701923,0.000204030477398119],[0.00158578411533079,0.00210515919727544,0.00275750894478785,0.00356401908850998,0.00454521277245432,0.00571951918251055,0.00710159545391795,0.00870048459298754,0.0105177310495496,0.0125456100842864,0.0147656515514656,0.0171476476409848,0.0196493229954393,0.0222168118935184,0.0247860310671267,0.0272849616034964,0.0296367659004772,0.0317635751035277,0.0335906997940167,0.0350509530199545,0.0360887396659986,0.0366635661791623,0.0367526620433737,0.0363524764813698,0.0354789132614946,0.0341662819670857,0.0324650621196873,0.0304386832401065,0.0281596070127925,0.0257050482589404,0.023152684992951,0.0205766849357409,0.0180443215735905,0.015613375840021,0.0133304305111334,0.0112300746230549,0.00933495469171821,0.00765654593047563,0.00619647462188332,0.00494820363570415,0.00389889516814435,0.00303128421417404,0.00232542781569435,0.00176023306045932,0.00131470583265148,0.00096889811554438,0.000704561224721522,0.000505534117703327,0.00035790956817334,0.000250027197049734],[0.00144459097554895,0.00192889230551476,0.00254133647229507,0.00330375218587334,0.00423783324015039,0.00536378508379378,0.00669869152217061,0.0082546695980404,0.010036921243166,0.0120418286582021,0.0142552709340437,0.0166513563016411,0.0191917623551844,0.021825852012381,0.0244916847445433,0.0271179727793081,0.0296269459925264,0.0319379955929218,0.0339718762129546,0.0356551702667044,0.0369246682399367,0.037731302257479,0.0380432921931912,0.0378482232346318,0.0371538655993539,0.0359876609639508,0.0343949229181923,0.0324359159285453,0.0301820752223892,0.0277116977606037,0.0251054653466443,0.0224421532256199,0.0197948345515206,0.0172278203625585,0.0147944865918145,0.012536045737736,0.010481232211309,0.00864679620402506,0.00703864738758138,0.00565345969578428,0.0044805414271032,0.00350378782686496,0.0027035612131493,0.00205838079124577,0.00154634480300154,0.00114624660737133,0.000838379968109045,0.000605054963596594,0.000430863662360376,0.000302744327628838],[0.00130029618314082,0.00174633506166368,0.00231421638875541,0.00302601768328766,0.00390418208102533,0.00497026759679308,0.00624339172969069,0.00773842367475971,0.00946401734550806,0.0114206193632859,0.0135986217003446,0.0159768527627862,0.0185216075995121,0.0211864030721551,0.0239126048614929,0.0266310107552455,0.0292643928330421,0.0317309073798729,0.0339481857918395,0.0358378341008801,0.0373300046985041,0.0383676712249612,0.0389102427957444,0.0389361984780432,0.0384445037089746,0.0374546787186332,0.0360055126505149,0.0341525414456541,0.0319645180539776,0.0295191875206601,0.026898728072624,0.0241852284849273,0.0214565429467558,0.0187828033375435,0.0162237848321017,0.0138272256379784,0.0116281072131558,0.00964881790507285,0.00790005834651174,0.00638230556090903,0.00508763553654975,0.00400170893572666,0.00310574723611338,0.00237836126550364,0.00179713476086314,0.00133990673887647,0.000985733698334116,0.000715543006416039,0.000512510756327246,0.000362210748125567],[0.00115647496046663,0.00156222550003849,0.0020822952880685,0.00273862151531337,0.00355396233334055,0.00455076837095882,0.00574973391254794,0.00716806389775428,0.00881753302297838,0.010702455409795,0.0128177224943715,0.0151470970495174,0.0176619664997364,0.0203207536473544,0.0230691541195876,0.0258413165188547,0.0285620060070107,0.0311497009936118,0.0335204749696152,0.0355924227214596,0.0372903142524649,0.0385501117404768,0.0393229729620533,0.0395783927269485,0.039306200757046,0.0385172336318561,0.037242618921679,0.0355317374227542,0.0334490494331036,0.0310700693144426,0.0284768383123726,0.0257532724349176,0.0229807490532962,0.0202342468548999,0.0175792771510553,0.0150697513946714,0.0127468321758334,0.0106387242790419,0.00876128775732528,0.00711930241167425,0.00570818504217684,0.00451595650797292,0.00352527144901114,0.00271535416039882,0.00206372348324509,0.00154763176670244,0.00114518294191515,0.000836128853900025,0.000602369059776598,0.000428196593421114],[0.00101631125791446,0.00138088155128631,0.00185130180242074,0.00244900192201008,0.00319662825189853,0.00411705099568707,0.00523204493018019,0.00656066388699401,0.00811736768274896,0.00991000224790636,0.0119377751146724,0.014189403511924,0.0166416349243843,0.0192583443213008,0.0219903939403236,0.0247763984805556,0.0275444719110196,0.0302149464631434,0.0327039577628858,0.0349276931405341,0.0368070149829829,0.0382721093258481,0.0392667813928511,0.0397520304269869,0.039708586988326,0.0391381826489027,0.0380634354735798,0.0365263618434164,0.0345856511000736,0.032312949390166,0.0297884804799497,0.0270963757199229,0.0243200893665302,0.021538241030764,0.0188211607743673,0.0162283244470199,0.0138067691839117,0.0115904834923965,0.0096006833596701,0.00784682280555472,0.00632814832878664,0.00503559229535181,0.00395380800157409,0.00306317421133866,0.00234163350546287,0.00176627066335869,0.00131457900867389,0.000965399870275191,0.000699550199182907,0.000500174605784212],[0.000882498131985922,0.00120605104259924,0.00162633005364664,0.00216392792894097,0.00284097886130543,0.00368030928951979,0.00470426457279237,0.00593321745160732,0.00738379953638973,0.00906693776886313,0.0109858199740756,0.0131339520479193,0.0154934979942417,0.0180341068979657,0.0207124228857609,0.0234724420138627,0.0262468234928327,0.0289591847765314,0.0315273173799115,0.0338671624545163,0.0358972937335959,0.0375435825195269,0.0387436756794173,0.0394509108526286,0.0396373265314987,0.0392954964128232,0.0384390202887755,0.0371016262496353,0.0353349668083562,0.0332053096645597,0.0307894185335097,0.0281699804239484,0.0254309572975794,0.0226532218170297,0.0199107835859131,0.0172678326804907,0.0147767326952407,0.0124769980733942,0.0103952013143555,0.00854568353886147,0.00693189240964216,0.00554814657573668,0.00438162437929993,0.00341439269063494,0.00262532392998006,0.00199178946903656,0.00149105983598307,0.00110138160205777,0.000802734019641593,0.000577293443617002],[0.000757176992743379,0.00104081011805307,0.00141168144768801,0.00188926558931265,0.00249482695232126,0.00325071537535459,0.00417934832921095,0.0053018727277799,0.00663653108358818,0.00819679498734004,0.00998937043931168,0.0120122197789983,0.0142527781787472,0.0166865628326043,0.01927637451975,0.0219722700744814,0.0247124388112368,0.0274250476558828,0.030031033628772,0.0324477266853547,0.0345930914944946,0.036390295427653,0.0377722532340255,0.0386857756966327,0.0390949652702145,0.0389835566599143,0.0383559896351691,0.0372371154516934,0.0356705639393594,0.0337159208065015,0.0314449696713387,0.0289373289196337,0.026275851989456,0.0235421584500285,0.0208126248173641,0.0181550955066534,0.0156264859525885,0.0132713535609212,0.011121419387477,0.00919594410058519,0.00750280281247707,0.00604006827668541,0.00479790084807649,0.00376055370293834,0.00290832828348316,0.00221935187319118,0.00167109064060913,0.00124155211777672,0.000910166839765373,0.000658367172445374],[0.000641915081979812,0.000887511274009506,0.0012107689721837,0.00162982056278968,0.00216475827352487,0.00283707050655388,0.00366878241077682,0.00468128289729962,0.00589384790345248,0.00732190461674246,0.00897512105894933,0.0108554459385559,0.0129552598419426,0.0152558248018747,0.0177262292937048,0.0203230150281116,0.0229906377917561,0.0256628571142576,0.0282650721184644,0.0307175303035999,0.0329392418039999,0.034852345190096,0.0363866036976121,0.0374836729633369,0.0381007798525145,0.038213489308066,0.0378173097849096,0.0369279902473652,0.0355804813570828,0.0338266563576602,0.0317319988010899,0.0293715518009833,0.026825477490356,0.02417459100513,0.0214962109284218,0.0188606128314088,0.0163282932146601,0.0139481589121054,0.0117566635066819,0.00977782804141707,0.00802401640158215,0.00649729111034792,0.00519115443485857,0.00409248105925396,0.00318346817429041,0.00244346122912303,0.00185055287174918,0.00138289322379636,0.00101968705254385,0.000741884447228556],[0.00053771766762463,0.000747778213278331,0.00102608281659892,0.00138925870648534,0.00185598706497391,0.00244657125337455,0.00318223243128499,0.00408410624923402,0.00517193754393784,0.00646250090705276,0.00796781180707879,0.00969323237492048,0.0116356134750127,0.0137816448222081,0.0161066019500179,0.0185736776535538,0.0211340625161215,0.0237278930907265,0.0262861191138178,0.0287332579458513,0.0309909134551111,0.0329818481838284,0.0346343231560201,0.0358863696941787,0.0366896403258619,0.0370125057006306,0.0368421210985558,0.0361852743444509,0.0350679371110965,0.0335335609525325,0.0316402738905749,0.0294572296194122,0.0270604286280007,0.0245283620628246,0.0219378231145419,0.0193601901347548,0.0168584177485011,0.0144848869512511,0.0122801738240114,0.0102727098998707,0.00847923435917506,0.00690588527941833,0.00554974700689808,0.00440066305422849,0.00344313581786892,0.00265816109108238,0.00202488118367717,0.00152197983403494,0.00112878013307384,0.000826039702266995],[0.00044506924897135,0.000622541478670758,0.000859211542250555,0.00117010010306494,0.00157230587855697,0.0020846932692654,0.00272733443420574,0.0035206733490657,0.00448439825831248,0.0056360355417523,0.00698931117884717,0.00855236318811009,0.0103259257983764,0.0123016387608728,0.014460657670125,0.0167727481503507,0.0191960340763719,0.0216775353934832,0.0241545750418309,0.0265570605609366,0.0288105608137019,0.0308400111094537,0.0325738014592839,0.0339479434143059,0.034909979976493,0.0354223063960045,0.035464609022514,0.0350352017641209,0.0341511375979861,0.0328470848535481,0.0311730714787924,0.0291913018551495,0.0269723283358209,0.0245909052883367,0.0221218631821694,0.0196363150924764,0.0171984531696666,0.0148631167599548,0.0126742274388422,0.0106640999904368,0.00885356186414438,0.00725275403719238,0.00586244765740115,0.00467569433629337,0.00367963170274312,0.00285728589361695,0.00218924389697234,0.00165510558343991,0.001234662806026,0.000908787055262292],[0.000363996684074896,0.000512106554096954,0.000710909546692403,0.000973776891215656,0.00131612060139237,0.00175518547361013,0.00230962488423302,0.00299882408122151,0.00384194934721071,0.00485672356875417,0.00605795776784736,0.00745590220388233,0.00905451661336815,0.0108497927479427,0.0128282885585929,0.0149660469663268,0.0172280686118646,0.0195684842511671,0.0219315278141273,0.0242533476643404,0.026464616385293,0.0284938162560803,0.0302709981249051,0.0317317459378041,0.0328210371831271,0.0334966780696454,0.0337320148640046,0.0335176785978383,0.032862203962624,0.0317914654087256,0.0303469823794332,0.0285832484034196,0.0265643234802657,0.0243599864351934,0.0220417681366918,0.0196791765775995,0.0173363841203392,0.015069582656945,0.0129251334066462,0.0109385548593831,0.00913431469000814,0.0075263272082636,0.00611901230756774,0.00490874716556497,0.00388553750892989,0.0030347481371378,0.00233875811120905,0.00177843937600323,0.00133439353619605,0.000987915727084512],[0.000294146592672975,0.000416244905717154,0.000581199385187832,0.000800741738383606,0.00108855629182056,0.00146015992113813,0.00193259592914052,0.00252390382977704,0.00325233782719436,0.00413532458677193,0.00518817554423933,0.00642259928111621,0.00784509299382869,0.00945532521757655,0.0112446502454171,0.0131949132015442,0.0152777088459544,0.0174542433320943,0.0196759145912656,0.0218856745449136,0.0240201685268026,0.0260125704260483,0.0277959545841152,0.0293069769857493,0.0304895881934678,0.0312984765945646,0.0317019477419631,0.0316839848905452,0.0312453040205699,0.0304033064846295,0.0291909336433022,0.0276545285682943,0.025850898265392,0.0238438358414114,0.0217003987044199,0.0194872433658188,0.0172672910729095,0.0150969465157218,0.0130240222199694,0.0110864434474396,0.00931173201823038,0.00771720074221472,0.00631073917961496,0.00509203957995985,0.0040540996139066,0.00318484401009189,0.00246872674377816,0.00188820430341785,0.0014250038899876,0.00106114375409492],[0.000234869580809513,0.000334298235780028,0.000469496654692547,0.000650611933872122,0.000889616139879092,0.00120025738668948,0.0015978544878324,0.00209889721671636,0.00272042164706175,0.00347914378720804,0.00439035500771636,0.00546660892204848,0.00671625965768567,0.00814194296510494,0.00973912049295987,0.0114948293354827,0.0133867891117123,0.0153830135087883,0.0174420499760732,0.0195139297455679,0.0215418527611089,0.0234645632316822,0.0252192984781397,0.0267451251329312,0.0279864215926813,0.0288962320064407,0.0294392108774394,0.0295939011532111,0.0293541411862336,0.0287294719763336,0.0277445071789132,0.0264373238597787,0.0248570206434148,0.0230606614615795,0.0211098697158281,0.0190673549451111,0.0169936416087093,0.0149442307243158,0.0129673662928243,0.0111025081019719,0.00937953966579195,0.00781867309709754,0.00643095827711008,0.00521926603294458,0.00417959577491449,0.00330255633434699,0.00257488177255328,0.00198086763789985,0.00150364296332845,0.0011262248379679],[0.00018530463371266,0.000265286893383192,0.000374745489310622,0.00052233381190479,0.000718374603936417,0.000974865962460919,0.00130535894407224,0.0017246703480907,0.00224839882490643,0.00289222255121072,0.0036709728452673,0.00459750003647853,0.00568137448089622,0.00692749461001338,0.00833470211013292,0.00989452781362701,0.0115902064107916,0.0133960997479222,0.0152776543600699,0.0171919877712956,0.0190891509513189,0.0209140545470035,0.0226089798096865,0.0241165289722209,0.0253828125000017,0.0263606301446435,0.0270123855172063,0.0273124837733618,0.027248999364658,0.0268244623933851,0.026055691299297,0.0249726872997569,0.0236166918786759,0.0220375826130705,0.0202908363738783,0.01843431691971,0.0165251441226625,0.0146168761651297,0.012757188857387,0.0109861748718582,0.00933531841664319,0.00782713581157766,0.00647541651639464,0.00528595733305311,0.0042576573135199,0.00338383251335044,0.0026536162625248,0.00205332874326562,0.00156772526959613,0.00118106156372991],[0.000144458247584101,0.000208014715603489,0.000295554027674443,0.000414353307886817,0.000573186355918239,0.000782369628917414,0.00105370545331542,0.00140028867940222,0.00183614524938304,0.00237567810111389,0.00303290816946057,0.00382051608891941,0.00474871286509351,0.00582399365753727,0.00704785534564054,0.00841558238067374,0.00991522274527908,0.0115268828650328,0.0132224639086301,0.0149659402177481,0.0167142435965835,0.0184187670042206,0.020027442170485,0.0214872840054064,0.0227472377757445,0.0237611204568931,0.0244904220849628,0.0249067309699895,0.0249935700627561,0.0247474790593318,0.0241782431899191,0.0233082476075961,0.0221710167487644,0.0208090715042579,0.0192712950429655,0.0176100343839286,0.015878176048548,0.0141264204198209,0.0124009440228649,0.0107415875482862,0.00918064730447497,0.00774228652565699,0.00644252750538227,0.00528974124739409,0.00428552153076133,0.00342581604896471,0.0027021876406841,0.00210309103665367,0.00161507147601204,0.00122381712825796],[0.000111274323068968,0.000161164312836481,0.000230321195509374,0.000324780567951035,0.000451894726463031,0.000620405465314535,0.000840436803308675,0.00112337722509811,0.00148162150551534,0.00192814653720738,0.00247590459543531,0.00313703150655111,0.0039218859550557,0.00483795858383625,0.00588871366094814,0.00707244915234241,0.00838127973077292,0.00980035806309493,0.011307449483585,0.0128729616258847,0.0144605029547311,0.0160280034751137,0.0175293802851081,0.0189166750286826,0.0201425360196494,0.0211628717582228,0.0219394712654323,0.0224423752235605,0.022651793142442,0.0225593956052419,0.0221688639862077,0.0214956470726313,0.0205659470173959,0.0194150273973844,0.0180849956367252,0.0166222540007902,0.0150748335629811,0.0134898227390289,0.0119110779116112,0.0103773626361391,0.00892101001312236,0.00756714691397409,0.00633346551415246,0.00523048257996611,0.00426219401960488,0.00342701319191811,0.00271887625901026,0.0021284047245773,0.00164403133755382,0.00125301732044283],[8.46923406763221e-05,0.000123378719418959,0.000177348486369797,0.000251539283573109,0.00035202641960991,0.000486111396526258,0.000662349865961817,0.000890492381150203,0.00118131051283186,0.00154628319207075,0.00199712435038708,0.00254514356133224,0.00320044646418478,0.00397100062185208,0.00486161371745434,0.00587289245244381,0.00700026937865594,0.00823319805161028,0.00955462129600174,0.0109408105833288,0.0123616551991649,0.0137814482217627,0.0151601743252459,0.0164552558120156,0.0176236632835197,0.0186242520512519,0.0194201508886056,0.0199810112709075,0.0202849263456582,0.0203198506202424,0.0200843921409146,0.01958790454696,0.0188498705147227,0.0178986332381759,0.0167695910626437,0.0155030154863425,0.0141416796507964,0.012728490848454,0.011304306903108,0.00990608546028126,0.0085654721314148,0.00730788404847864,0.00615209587522702,0.00511029119042496,0.0041885075770453,0.00338738116886236,0.00270308646420037,0.00212836893851103,0.0016535791668967,0.00126763487058199],[6.36927303905473e-05,9.33271904255151e-05,0.000134932827903958,0.00019249442603621,0.000270962880139272,0.000376350542928629,0.000515782258315104,0.000697479355072574,0.000930652226579721,0.001225277869806,0.0015917426897899,0.00204033859083012,0.00258061209955146,0.00322058169366971,0.00396585668793374,0.00481871030736815,0.00577717768784394,0.00683426379380902,0.00797735384612403,0.00918791735031035,0.0104415845379764,0.0117086505269039,0.0129550288276708,0.0141436346473623,0.0152361338867668,0.0161949509456907,0.0169853929631621,0.0175777250252726,0.017949024043658,0.0180846504025414,0.0179792057192614,0.0176368893829683,0.0170712210500532,0.0163041546563305,0.015364664873877,0.0142869328459737,0.0131082893743045,0.0118670874408113,0.0106006713437061,0.00934358849715583,0.00812615575080097,0.00697344991716945,0.00590474756597825,0.00493339729008532,0.00406707284896598,0.00330833071937962,0.00265538189074769,0.00210298495707829,0.00164337413984369,0.0012671494417822],[4.73295258414193e-05,6.9754572483732e-05,0.000101438849412955,0.000145554974717752,0.000206082397092394,0.000287902772342818,0.000396864179718349,0.000539795254920541,0.000724448184845398,0.000959349161103639,0.0012535370571252,0.00161617639569118,0.00205603946972053,0.0025808647202325,0.00319661357818741,0.00390666475319656,0.00471100162564905,0.00560546273113882,0.0065811348574446,0.00762397066405474,0.00871470616038821,0.0098291369357492,0.010938786053318,0.0120119627415364,0.0130151725477736,0.0139148006645202,0.0146789554995948,0.0152793339818696,0.0156929575353502,0.0159036306357783,0.0159029929766739,0.0156910699746555,0.015276271088439,0.0146748361064763,0.0139097802204707,0.0130094333943382,0.0120057031623603,0.0109322090087645,0.00982243936527938,0.00870806961723344,0.00761755386153815,0.00657506848070528,0.00559984663131092,0.00470590429332519,0.00390212478654976,0.00319264273310559,0.00257745206133913,0.00205315613021244,0.00161378049195212,0.00125157837817177],[3.47512952777605e-05,5.15150026992236e-05,7.53507471052094e-05,0.000108750810909627,0.000154870446605912,0.000217618445132851,0.000301726851311471,0.00041278444547611,0.000557216274804408,0.000742190458230052,0.000975434352319257,0.00126494554941347,0.00161858951188472,0.00204358505501436,0.00254589108031277,0.00312952212665138,0.0037958351137518,0.00454284330331449,0.00536462390302359,0.00625089075956473,0.00718680139827825,0.00815305709187914,0.00912633547203887,0.0100800684124255,0.010985545720911,0.0118132908775259,0.0125346226703704,0.0131232903511853,0.013557053685366,0.013819075815849,0.0138990074805494,0.0137936652860392,0.0135072420777944,0.0130510300300684,0.0124426819457964,0.011705078120669,0.010864900128077,0.00995103528192496,0.00899294420695491,0.00801911861606261,0.00705573857781514,0.00612561123700827,0.00524744005007207,0.00443543935907076,0.00369927750703547,0.00304430585618474,0.00247201305445788,0.00198063451156368,0.00156584593744514,0.00122147567617243],[2.5211947587415e-05,3.75916448107087e-05,5.53053782531702e-05,8.02850183296916e-05,0.000114998654805264,0.000162533210899335,0.00022666401398388,0.000311899114092847,0.000423483810775748,0.000567349386055405,0.000749989997769412,0.000978253609878092,0.00125903717168069,0.00159888324329577,0.00200348481512144,0.00247711668611112,0.00302202449278176,0.00363781492516752,0.00432090110511991,0.00506406367721995,0.00585618914166067,0.00668224104221381,0.00752350623866595,0.00835813802742306,0.00916199177943706,0.00990971950996251,0.0105760606339042,0.0111372407395008,0.0115723720623321,0.0118647413327439,0.0120028745278724,0.0119812840225945,0.0118008303294046,0.0114686651904858,0.0109977612675612,0.0104060715385006,0.00971539431498998,0.00895004382590842,0.00813543908359896,0.00729672432411815,0.00645752334831541,0.00563890966313262,0.0048586475328189,0.00413072951295637,0.00346520734298401,0.00286828829043528,0.00234265038293416,0.00188791859566058,0.00150124009348703,0.0011778992639159],[1.80733371677512e-05,2.71047550111211e-05,4.01091748270201e-05,5.85643157905654e-05,8.43749494715509e-05,0.000119945810448193,0.000168247161576479,0.000232863550322938,0.000318014109132602,0.00042853112188958,0.000569782954322341,0.000747528307161788,0.000967691527897332,0.00123605370328035,0.00155786150825927,0.00193736504237888,0.0023773064945776,0.00287839240460445,0.00343879216581494,0.00405371267426767,0.00471510211207877,0.00541153345309561,0.00612830960719761,0.00684781713137878,0.00755013497517939,0.00821388054638616,0.00881725000815338,0.0093391861755592,0.00976058879082534,0.0100654710815493,0.0102419652934156,0.0102830891195923,0.0101872040464031,0.00995812367826266,0.00960486205997919,0.00914104514704806,0.00858403898117244,0.00795387229621339,0.00727204658064278,0.00656033165843256,0.00583963959915425,0.00512905551257304,0.00444508284615453,0.00380113614714523,0.0032072890111129,0.00267026198388836,0.00219361675600905,0.00177811048273214,0.00142215795622566,0.0011223492837132],[1.28016768961632e-05,1.93106192075752e-05,2.87419774020541e-05,4.22112480203759e-05,6.11689248842506e-05,8.74630478813116e-05,0.00012339838419058,0.000171785081001195,0.000235967678853188,0.000319823743631343,0.000427720425295502,0.000564417385836226,0.00073490614932051,0.00094417932268568,0.00119692846295418,0.00149717652674213,0.00184785942671217,0.00225038049836383,0.00270417060063069,0.00320629386213304,0.0037511433918659,0.00433027136969327,0.00493239293243928,0.0055435928436234,0.00614774845868623,0.0067271631300411,0.00726338281753028,0.00773814769876327,0.00813441266901744,0.00843735830499278,0.00863530913492803,0.00872048003116271,0.00868948424040933,0.00854355684416773,0.00828847309857503,0.00793416917911265,0.00749410004399307,0.00698439225116035,0.00642286601799204,0.00582800893539985,0.00521798301047178,0.0046097377402491,0.00401828633712226,0.00345618235700434,0.00293321246950526,0.00245630052882637,0.00202960061757518,0.00165474385305386,0.00133119620868949,0.00105668239805986],[8.95966824132178e-06,1.35938811840206e-05,2.03510169481735e-05,3.00621382505957e-05,4.38172103968314e-05,6.30174300000505e-05,8.9426813456077e-05,0.000125217759706192,0.000173003627180809,0.000235849843943126,0.000317253983077072,0.000421084910529562,0.000551471889644086,0.000712636703524084,0.000908665623951228,0.00114322342811716,0.00141921841872963,0.00173843504076041,0.00210115843562737,0.00250582213099526,0.00294871490735299,0.00342378461222575,0.00392257441685129,0.00443432022772561,0.00494622672398088,0.00544392447896981,0.00591209316915222,0.00633521783678223,0.00669842873709528,0.00698836267586448,0.00719397683691431,0.00730724620255781,0.00732368321735014,0.00724263279593603,0.00706731564361803,0.00680461589667497,0.00646463259897492,0.00606003574497856,0.00560528409841534,0.00511577197196474,0.00460697475656041,0.00409365833226943,0.0035892066009622,0.00310510598713792,0.002650608003062,0.0022325730949166,0.00185548297545558,0.00152159603065836,0.00123121207137084,0.00098300894225388],[6.1960305737622e-06,9.45556088643785e-06,1.4238103460184e-05,2.11547598105067e-05,3.1013812617477e-05,4.4863517779511e-05,6.40357639004554e-05,9.01867986259047e-05,0.000125329830620786,0.000171852969150526,0.000232514870086148,0.000310409876377941,0.000408894655880807,0.000531469619168869,0.000681610949287434,0.000862552976826291,0.00107702579260559,0.00132695909343585,0.00161316975705334,0.0019350567822151,0.00229033210514181,0.00267481847293422,0.00308234518161767,0.00350476849477069,0.00393213577645803,0.00435300113547247,0.00475488656640963,0.00512486756021845,0.00545024766934903,0.00571927441260248,0.00592184092317227,0.00605011520661979,0.00609904247357034,0.00606667565138045,0.00595430395337931,0.0057663676725401,0.00551016704878653,0.00519539181592246,0.00483351367853387,0.00443709475735429,0.00401906990880073,0.00359205950938157,0.00316776233676438,0.00275646678952582,0.00236670453680759,0.00200505563516625,0.00167609996709171,0.00138249800380696,0.00112517536169562,0.000903580853897582],[4.23381357722813e-06,6.49871778112539e-06,9.84271089186397e-06,1.47093298125962e-05,2.16901296662535e-05,3.15589478846497e-05,4.53079058778829e-05,6.4182490993075e-05,8.97119409516015e-05,0.000123730008496092,0.000168380167834123,0.000226098634184228,0.000299568431243159,0.000391638390319847,0.000505202596699644,0.000643038531170514,0.000807605978057154,0.00100081350862128,0.00122376463286671,0.00147650098975645,0.00175776451355484,0.00206480359691361,0.00239324912678827,0.00273708431329444,0.00308872716476595,0.00343923637246695,0.0037786407869494,0.00409638056033298,0.00438183571056618,0.00462490684703037,0.00481660458382056,0.00494960002237526,0.00501868942519026,0.0050211320396524,0.00495683050552904,0.0048283372941303,0.00464068658555929,0.00440106701890694,0.00411836496480006,0.00380261874583701,0.0034644304288085,0.00311438292431099,0.0027625063191208,0.00241782941128705,0.00208804155605564,0.00177927765504024,0.00149602695022477,0.0012411555544159,0.00101602435527946,0.000820678635176024],[2.85855443325664e-06,4.41331183887568e-06,6.72316654024539e-06,1.01058821394889e-05,1.49887595958214e-05,2.19355366880015e-05,3.16753877987313e-05,4.51322226657094e-05,6.34516045791189e-05,8.80216695082068e-05,0.000120483534507317,0.000162725982704437,0.000216858880679868,0.000285160013234596,0.000369990988095033,0.000473679698201262,0.000598369573770794,0.000745839428523623,0.000917301872845545,0.00111319264294886,0.00133296725271858,0.00157492449732431,0.00183607789471823,0.00211209559662515,0.00239732627725779,0.00268492294192838,0.00296706876316476,0.00323529958810934,0.00348090763043224,0.00369540124655601,0.00387098785234104,0.00400104210221124,0.00408052027258244,0.00410628476457878,0.00407730963177577,0.00399474836785066,0.00386185771127864,0.00368378448241625,0.00346723489972047,0.00322005598229351,0.00295076541396297,0.00266806897113301,0.00238040319962863,0.00209553589328792,0.00182024894569894,0.00156011846776489,0.00131939694120906,0.0011009927863147,0.000906535006919634,0.0007365051552544],[1.90703102210662e-06,2.96140707178307e-06,4.5376350718039e-06,6.86044249063201e-06,1.02344803335503e-05,1.50650497074745e-05,2.18809637996818e-05,3.13583665104888e-05,4.43436585366157e-05,6.18729348252297e-05,8.51845859889088e-05,0.000115721065308884,0.000155115406228434,0.000205158044820841,0.000267740009217739,0.000344769708716845,0.000438062457674376,0.000549204483835472,0.000679396364557339,0.000829284347894717,0.000998791468000399,0.00118696328225285,0.0013918449270989,0.00161040652909774,0.00183853245143095,0.00207108623670839,0.00230205751958751,0.00252479001764456,0.00273228163852863,0.00291753965867054,0.00307396684002104,0.00319574923676422,0.00327821410759669,0.00331812728258813,0.00331390361993804,0.00326571146495004,0.00317546151647491,0.00304668112711783,0.00288428556345167,0.00269426689950025,0.0024833279722717,0.00225849249016758,0.00202672267595577,0.00179457291143145,0.00156790229093669,0.00135166163435483,0.00114976235389303,0.000965026607655908,0.000799211264671101,0.000653092972573269]],"type":"surface"}],"base_url":"https://plot.ly"},"evals":["config.modeBarButtonsToAdd.0.click"],"jsHooks":[]}</script><!--/html_preserve-->

But with regression we are calculating only one margin.


```r
Galton_means <- Galton %>%
  group_by(parent) %>%
  summarise(child = mean(child))
ggplot(Galton, aes(x = factor(parent), y = child)) +
  geom_jitter(width = 0) +
  geom_point(data = Galton_means, colour = "red")
```

<img src="cef_files/figure-html/unnamed-chunk-31-1.svg" width="672" />

Note that in this example, it doesn't really matter since a bivariate normal distribution happens to describe the data very well.
This is not true in general, and we are simplifying our analysis by calculating the CEF rather than jointly modeling both.