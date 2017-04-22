
# Bootstrapping


```r
library("tidyverse")
library("broom")
library("modelr")
```

```
## 
## Attaching package: 'modelr'
```

```
## The following object is masked from 'package:broom':
## 
##     bootstrap
```


Non-parametric bootstrapping estimates standard errors and confidence intervals by resampling the observations in the data.

The [modelr](https://www.rdocumentation.org/packages/modelr/topics/bootstrap) function in **[modelr](https://cran.r-project.org/package=modelr)** implements simple non-parametric bootstrapping.[^bootstrap]
It generates `n` bootstrap replicates. 

```r
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
## <resample [45 x 4]> 13, 34, 35, 20, 11, 10, 6, 7, 39, 32, ...
```
Since the `data` object hasn't changed it doesn't take up any additional memory until subsets are created, allowing for the creation of `lazy` subsamples of a dataset.
A `resample` object can be turned into a data frame with `as.data.frame`:

```r
as.data.frame(bsdata[["strap"]][[1]])
```

```
##                    type income education prestige
## physician          prof     76        97       97
## taxi.driver          bc      9        19       10
## truck.driver         bc     21        15       13
## banker             prof     78        82       92
## undertaker         prof     42        74       57
## engineer           prof     72        86       88
## minister           prof     21        84       87
## professor          prof     64        93       93
## shoe.shiner          bc      9        17        3
## coal.miner           bc      7         7       15
## machine.operator     bc     21        20       24
## physician.1        prof     76        97       97
## coal.miner.1         bc      7         7       15
## truck.driver.1       bc     21        15       13
## dentist            prof     80       100       90
## streetcar.motorman   bc     42        26       19
## bartender            bc     16        28        7
## factory.owner      prof     60        56       81
## banker.1           prof     78        82       92
## coal.miner.2         bc      7         7       15
## welfare.worker     prof     41        84       59
## accountant         prof     62        86       82
## factory.owner.1    prof     60        56       81
## insurance.agent      wc     55        71       41
## waiter               bc      8        32       10
## RR.engineer          bc     81        28       67
## electrician          bc     47        39       53
## RR.engineer.1        bc     81        28       67
## minister.1         prof     21        84       87
## author             prof     55        90       76
## plumber              bc     44        25       29
## physician.2        prof     76        97       97
## RR.engineer.2        bc     81        28       67
## welfare.worker.1   prof     41        84       59
## carpenter            bc     21        23       33
## truck.driver.2       bc     21        15       13
## dentist.1          prof     80       100       90
## lawyer             prof     76        98       89
## engineer.1         prof     72        86       88
## waiter.1             bc      8        32       10
## conductor            wc     76        34       38
## accountant.1       prof     62        86       82
## physician.3        prof     76        97       97
## cook                 bc     14        22       16
## shoe.shiner.1        bc      9        17        3
```

[^bootstrap]: The **broom** package also provides a `bootstrap` function.

To generate standard errors for a statistic, estimate it on each bootstrap replicate.

Suppose, we'd like to calculate robust standard errors for the regression coefficients in this regresion:

```r
mod <- lm(prestige ~ type + income + education, data = car::Duncan)
mod
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
## 1 (Intercept)   3.3880286
## 2    typeprof  27.2634521
## 3      typewc -13.2084788
## 4      income   0.5971872
## 5   education   0.1943750
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
## 1 (Intercept)   0.03240667  -0.1850278  -0.4024623
## 2   education   0.35311336   0.3453193   0.3375253
## 3      income   0.60631732   0.5975465   0.5887757
## 4    typeprof  17.19855410  16.6575134  16.1164727
## 5      typewc -14.25928277 -14.6611334 -15.0629840
```

```r
select(bs_est_ci1, term, std.error, std.error_ols)
```

```
## # A tibble: 5 × 3
##          term std.error std.error_ols
##         <chr>     <dbl>         <dbl>
## 1 (Intercept) 3.4457925     3.7137705
## 2   education 0.1235159     0.1136089
## 3      income 0.1389956     0.0893553
## 4    typeprof 8.5741408     6.9930065
## 5      typewc 6.3683260     6.1087737
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
