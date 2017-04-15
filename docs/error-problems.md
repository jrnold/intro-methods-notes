
# Problems with Errors


## Prerequisites

In addition to tidyverse pacakges, this chaper uses the **[sandwich](https://cran.r-project.org/package=sandwich)** and **[lmtest](https://cran.r-project.org/package=lmtest)** packages which provide robust standard errors and tests that use robust standard errors.


```r
library("sandwich")
library("lmtest")
library("tidyverse")
library("broom")
library("modelr")
```


## Heteroskedasticity

$$
\hat{\beta} = (\mat{X}\T \mat{X})^{-1} \mat{X}\T \vec{y}
$$
and 
$$
\Var(\vec{\epsilon}) = \mat{\Sigma}
$$
is the variance-covariance matrix of the errors.

Assumptions 1-4 give the expression for the sampling variance,
$$
\Var(\hat{\beta}) = (\mat{X}'\mat{X})^{-1} \mat{X}\T \mat{\Sigma} \mat{X} (\mat{X}\T \mat{X})^{-1}
$$
under homoskedasticity, 
$$
\mat{\Sigma} = \sigma^2 \mat{I},
$$
so the the variance-covariance matrix simplifies to
$$
\Var(\hat{\beta} | X) = \sigma^2 (\mat{X}\T \mat{X})^{-1}
$$

Homoskedastic:
$$
\Var(\vec{\epsilon} | \mat{X}) = \sigma^2 I = 
\begin{bmatrix}
\sigma^2 & 0        & 0      & \cdots & 0 \\
0        & \sigma^2 & 0      & \cdots & 0 \\
\vdots   & \vdots   & \vdots & \ddots & \vdots \\
\sigma^2 & 0        & 0      & \cdots & \sigma^2 
\end{bmatrix}
$$

Heteroskedastic
$$
\Var(\vec{\epsilon} | \mat{X}) = \sigma^2 I = 
\begin{bmatrix}
\sigma_1^2 & 0        & 0      & \cdots & 0 \\
0        & \sigma_2^2 & 0      & \cdots & 0 \\
\vdots   & \vdots   & \vdots & \ddots & \vdots \\
\sigma^2 & 0        & 0      & \cdots & \sigma_n^2 
\end{bmatrix}
$$
- independent, since the only non-zero values are on the diagonal, meaning that there are no correlated errors between observations
- non-identical, since the values on the diagonal are not equal, e.g. $\sigma_1^2 \neq \sigma_2^2$.
- $\Cov(\epsilon_i, \epsilon_j | \mat{X}) = 0$
- $\Var(\epsilon_i | \vec{x}_i) = \sigma^2_i$


```r
tibble(
  x = runif(100, 0, 3),
  `Homoskedastic` = rnorm(length(x), mean = 0, sd = 1),
  `Heteroskedasticity` = rnorm(length(x), mean = 0, sd = x)
) %>%
  gather(type, `error`, -x) %>%
  ggplot(aes(x = x, y = error)) +
  geom_hline(yintercept = 0, colour = "white", size = 2) +
  geom_point() +
  facet_wrap(~ type, nrow = 1)
```

<img src="error-problems_files/figure-html/unnamed-chunk-3-1.svg" width="672" />

Consequences

- $\hat{\vec{\beta}}$ are still unbiased and consistent estimators of $\vec{\beta}$
- Standard error estimates are **biased**, likely downward, meaning that the estimated standard errors will be smaller than the true standard errors (too optimistic).
- Test statstics won't be distributed $t$ or $F$
- $\alpha$-level tests will have Type I errors $\neq \alpha$
- Coverage of confidence intervals will not be correct.
- OLS is not BLUE

Visual diagnostics

- Plot residuals vs. fitted values
- Spread-location plot.
  - y: square root of absolute value of residuals
  - x: fitted values
  - loess trend curve
  
Dealing with NCV

- Transform the dependent variable
- Model the heteroskedasticity using WLS
- Use an estimator of $\Var(\hat{\beta} | \mat{X})$ that is **robust** to heteroskedasticity
- Admit we are using the **wrong model** and use a different model


The standard way to "fix" robust heteroskedasticity is to use so-called "robust" standard errors, more formally called Heteroskedasticity Consistent (HC), and heteroskedasticity and Autocorrelation Consistent standard errors.
HC and HAC errors are implemented in the R package **[sandwich](https://cran.r-project.org/package=sandwich)**.
See @Zeileis2006a and Zeileis2004a for succint discussion of the estimators themselves and examples of their usage.

With robust standard errors, the coefficients of the model are estimated using `lm()`. 
Then a HC or HAC variance-covariance matrix is computed which corrects for heteroskedasticity (and autocorrelation).


### Example: Duncan's Occupation Data



```r
mod <- lm(prestige ~ income + education + type, data = car::Duncan)
```
The classic OLS variance covariance matrix is,

```r
vcov(mod)
```

```
##             (Intercept)       income    education   typeprof     typewc
## (Intercept)  13.7920916 -0.115636760 -0.257485549 14.0946963  7.9021988
## income       -0.1156368  0.007984369 -0.002924489 -0.1260105 -0.1090485
## education    -0.2574855 -0.002924489  0.012906986 -0.6166508 -0.3881200
## typeprof     14.0946963 -0.126010517 -0.616650831 48.9021401 30.2138627
## typewc        7.9021988 -0.109048528 -0.388119979 30.2138627 37.3171167
```
and the standard errors are the diagonal of this matrix

```r
sqrt(diag(vcov(mod)))
```

```
## (Intercept)      income   education    typeprof      typewc 
##   3.7137705   0.0893553   0.1136089   6.9930065   6.1087737
```

Now, use `vcovHC` to estimate the "robust" variance covariance matrix

```r
vcovHC(mod)
```

```
##             (Intercept)       income    education   typeprof     typewc
## (Intercept)  15.2419440 -0.233347755 -0.255838779 25.6093353 12.4984902
## income       -0.2333478  0.023224098 -0.009806392 -0.6101496 -0.4039528
## education    -0.2558388 -0.009806392  0.019805541 -0.7730126 -0.4128297
## typeprof     25.6093353 -0.610149584 -0.773012579 90.8056216 52.2164675
## typewc       12.4984902 -0.403952792 -0.412829731 52.2164675 42.2001856
```
and the robust standard errors are the diagonal of the matrix

```r
sqrt(diag(vcovHC(mod)))
```

```
## (Intercept)      income   education    typeprof      typewc 
##   3.9040932   0.1523945   0.1407322   9.5291984   6.4961670
```
Note that the robust standard errors are **larger** than the classic standard errors; this is almost always the case.

If you need to use the robust standard errors to calculate t-statistics or p-values.

```r
coeftest(mod, vcovHC(mod))
```

```
## 
## t test of coefficients:
## 
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  -0.18503    3.90409 -0.0474 0.962436    
## income        0.59755    0.15239  3.9210 0.000337 ***
## education     0.34532    0.14073  2.4537 0.018589 *  
## typeprof     16.65751    9.52920  1.7480 0.088128 .  
## typewc      -14.66113    6.49617 -2.2569 0.029547 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```


**TODO** An example that uses `vcovHAC()` to calculate heteroskedasticity and autocorrelation consistent standard errors.

#### WLS vs. White's esimator

WLS:

- different estimator for $\beta$: $\hat{\beta}_{WLS} \neq \hat{\beta}_{OLS}$
- With known weights:
    - efficient
    - $\hat{\se}(\hat{\beta}_{WLS})$ are consistent
- If weights aren't known ... then biased for both $\hat{\beta}$ and standard errors.

White's esimator (heteroskedasticity consistent standard errors):

- uses OLS estimator for $\beta$
- consistent for $\Var(\hat{\beta})$ for any form of heteroskedasticity
- relies on consistency and large samples, and for small samples the performance may be poor.



### Notes

An additional use of robust standard errors is to diagnose potential model fit problems.
The OLS line is still the minimum squared error of the population regression, but large differences may suggest that it is a poor approximation.
@KingRoberts2015a suggest a formal test for this using the variance-covariance matrix.

- Note that there are other functions that have options to input variance-covariance matrices along with the `lm` object in order to use robust standard errors with that test or routine.
- Heteroskedastic consistent standard errors can be used with MLE models [@White1982a]. However, this is 
- More generally, robust standard errors can be controversial: @KingRoberts2015a suggest using them to diagnose model fit problems.


## Correlated Errors

**TODO**

## Non-normal Errors

This really isn't an issue. Normal errors only affect the standard errors, and only if the sample size is small. Once there is a reasonably large residual degrees of freedom (observations minus parameters), the CLT kicks in and it doesn't matter. 

If you are concerned about non-normal error it may be worth asking:

- Is the functional form, especially the form of the outcome varaible, correct?
- Is the conditional expected value ($Y | X$) really the best estimand? That's what the regression is giving you, but the conditional median or other quantile may be more appropriate for your purposes.

To diagnose use a qq-plot of the residuals against a normal distribution.

## Bootstrapping

Non-parametric bootstrapping estimates standard errors and confidence intervals by resampling the observations in the data.

The [modelr](https://www.rdocumentation.org/packages/modelr/topics/bootstrap) function in **[modelr](https://cran.r-project.org/package=modelr)** implements simple non-parametric bootstrapping.[^bootstrap]
It generates `n` bootstrap replicates. 

```r
library("modelr")
bsdata <- modelr::bootstrap(car::Duncan, n = 1024)
glimpse(bsdata)
```

```
## Observations: 1,024
## Variables: 2
## $ strap <list> [<2, 2, 2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 3, 2, 2,...
## $ .id   <chr> "0001", "0002", "0003", "0004", "0005", "0006", "0007", ...
```
It returns a data frame with two columns an id, and list column, `strap` containing [modelr](https://www.rdocumentation.org/packages/modelr/topics/resample) objects.
The `resample` objects consist of two elements: `data`, the data frame; `idx`, the indexes of the data in the sample.

```r
bsdata[["strap"]][[1]]
```

```
## <resample [45 x 4]> 2, 13, 26, 6, 22, 13, 4, 15, 20, 22, ...
```
Since the `data` object hasn't changed it doesn't take up any additional memory until subsets are created, allowing for the creation of `lazy` subsamples of a dataset.
A `resample` object can be turned into a data frame with `as.data.frame`:

```r
as.data.frame(bsdata[["strap"]][[1]])
```

```
##                     type income education prestige
## pilot               prof     72        76       83
## physician           prof     76        97       97
## electrician           bc     47        39       53
## minister            prof     21        84       87
## mail.carrier          wc     48        55       34
## physician.1         prof     76        97       97
## author              prof     55        90       76
## teacher             prof     48        91       73
## banker              prof     78        82       92
## mail.carrier.1        wc     48        55       34
## store.clerk           wc     29        50       16
## store.clerk.1         wc     29        50       16
## watchman              bc     17        25       11
## undertaker          prof     42        74       57
## lawyer              prof     76        98       89
## undertaker.1        prof     42        74       57
## banker.1            prof     78        82       92
## mail.carrier.2        wc     48        55       34
## janitor               bc      7        20        8
## RR.engineer           bc     81        28       67
## RR.engineer.1         bc     81        28       67
## mail.carrier.3        wc     48        55       34
## undertaker.2        prof     42        74       57
## janitor.1             bc      7        20        8
## gas.stn.attendant     bc     15        29       10
## cook                  bc     14        22       16
## auto.repairman        bc     22        22       26
## RR.engineer.2         bc     81        28       67
## reporter              wc     67        87       52
## factory.owner       prof     60        56       81
## waiter                bc      8        32       10
## dentist             prof     80       100       90
## gas.stn.attendant.1   bc     15        29       10
## professor           prof     64        93       93
## truck.driver          bc     21        15       13
## welfare.worker      prof     41        84       59
## waiter.1              bc      8        32       10
## coal.miner            bc      7         7       15
## machine.operator      bc     21        20       24
## engineer            prof     72        86       88
## physician.2         prof     76        97       97
## coal.miner.1          bc      7         7       15
## undertaker.3        prof     42        74       57
## chemist             prof     64        86       90
## physician.3         prof     76        97       97
```

[^bootstrap]: The **broom** package also provides a `bootstrap` function.

To generate standard errors for a statistic, estimate it on each bootstrap replicate.

Suppose, we'd like to calculate robust standard errors for the regression coefficients in this regresion:

```r
lm(prestige ~ type + income + education, data = car::Duncan)
```

```
## 
## Call:
## lm(formula = prestige ~ type + income + education, data = car::Duncan)
## 
## Coefficients:
## (Intercept)     typeprof       typewc       income    education  
##     -0.1850      16.6575     -14.6611       0.5975       0.3453
```

Since we are interested in the coefficients, we need to re-run the regression with `lm`, extract the coefficients to a data frame using `tidy`, and return it all as a large data frame.
For one bootstrap replicate this looks like,

```r
lm(prestige ~ type + income + education, data = as.data.frame(bsdata$strap[[1]])) %>%
  tidy() %>%
  select(term, estimate)
```

```
##          term    estimate
## 1 (Intercept)   1.0038364
## 2    typeprof  18.9921030
## 3      typewc -14.0803920
## 4      income   0.7198451
## 5   education   0.2047788
```
Note that the coefficients on this regression are slightly different than those in the original regression.


```r
bs_coef <- map_df(bsdata$strap, function(dat) {
  lm(prestige ~ type + income + education, data = dat) %>%
    tidy() %>%
    select(term, estimate)
})
```

There are multiple methods to estimate standard errors and confidence intervals using the bootstrap replicate estimates.
Two simple ones are are

1. Use the standard deviation of the boostrap estimates as $\hat{se}(\hat{\beta})$ instead of those produces by OLS. The confidence intervals are generated using the OLS coefficient estimate and the bootstrap standard errors, $\hat{\beta}_{OLS} \pm t_{df,\alpha/2}^* \hat{se}_{boot}(\hat{\beta})$
2. Use the quantiles of the bootstrap estimates as the endpoints of the confidence interval. E.g. the 95% confidence interval uses the 2.5th and 97.5th quantiles of the bootstrap estimates.

The first (standard error) method requires less bootstrap replicates. The quantile method allows for
asymmetric confidence intervals, but is noisier (the 5th and 95th quantiles vary more by samples) and requires more bootstrap replicates to get an accurate estimate. 

The bootstrap standard error confidence intervals:

```r
alpha <- 0.95
tstar <- qt(1 - (1 - alpha / 2), df = mod$df.residual)
bs_est_ci1 <- 
  bs_coef %>%
  group_by(term) %>%
  summarise(std.error = sd(estimate)) %>%
  left_join(select(tidy(mod),
                   term, estimate,
                   std.error_ols = std.error),
            by = "term") %>%
  mutate(
   conf.low = estimate - tstar * std.error,
   conf.high = estimate + tstar * std.error    
  )
select(bs_est_ci1, term, conf.low, estimate, conf.high)
```

```
## # A tibble: 5 × 4
##          term     conf.low    estimate   conf.high
##         <chr>        <dbl>       <dbl>       <dbl>
## 1 (Intercept)   0.03071912  -0.1850278  -0.4007748
## 2   education   0.35309998   0.3453193   0.3375387
## 3      income   0.60628354   0.5975465   0.5888094
## 4    typeprof  17.19124717  16.6575134  16.1237796
## 5      typewc -14.26095890 -14.6611334 -15.0613078
```

```r
select(bs_est_ci1, term, std.error, std.error_ols)
```

```
## # A tibble: 5 × 3
##          term std.error std.error_ols
##         <chr>     <dbl>         <dbl>
## 1 (Intercept) 3.4190490     3.7137705
## 2   education 0.1233038     0.1136089
## 3      income 0.1384604     0.0893553
## 4    typeprof 8.4583441     6.9930065
## 5      typewc 6.3417634     6.1087737
```
The quantile confidence intervals:

```r
alpha <- 0.95
bs_coef %>%
  group_by(term) %>%
  summarise(
   conf.low = quantile(estimate, (1 - alpha) / 2),
   conf.high = quantile(estimate, 1 - (1 - alpha) / 2)
  ) %>%
  left_join(select(tidy(mod),
                   term, estimate),
            by = "term") %>%
  select(term, estimate)
```

```
## # A tibble: 5 × 2
##          term    estimate
##         <chr>       <dbl>
## 1 (Intercept)  -0.1850278
## 2   education   0.3453193
## 3      income   0.5975465
## 4    typeprof  16.6575134
## 5      typewc -14.6611334
```


See the **boot** package (and other cites TODO) for more sophisticated methods of generating standard errors and quantiles.

The package [resamplr](https://github.com/jrnold/resamplr) includes more methods using `resampler` objects.
The package **[boot](https://cran.r-project.org/package=boot)** implements many more bootstrap methods [@Canty2002a].


