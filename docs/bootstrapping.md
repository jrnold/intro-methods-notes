
# Bootstrapping

The central analogy of bootstrapping is

> The population is to the sample as the sample is to the bootstrap samples [@Fox2008a, p. 590]

To calculate standard errors to use in confidence intervals we need to know sampling distribution of the statistic of interest.

In the case of a mean, we can appeal to the central limit theorem if the sample size is large enough.

Bootstrapping takes a different approach. 
We use the sample as an estimator of the sampling distribution. 
E.g. bootstrap claims
$$
\text{sample distribution} \approx \text{population distribution}
$$
and then proceeds to *plug-in* the sample distribution for the population distribution, and then draw new samples to generate a sampling distribution.

The bootstrap relies upon the **plug-in principle**.
The plug-in principle is that when something is unknown, use an estimate of it.
An example is the use of the *sample standard deviation* in place of the *population standard deviation*, when calculating the standard error of the mean,
$$
\SE(\bar{x}) = \frac{\sigma}{\sqrt{n}} \approx \frac{\hat{\sigma}}{\sqrt{n}}
$$
Bootstrap is the plug-in principal on 'roids.
It uses the empirical distribution  as a plug-in for the unknown population distribution.
See Figures 4 and 5 of @Hesterberg2015a. 

Bootstrap principles

1.  The substitution of the empirical distribution for the population works.
1.  Sample with replacement.

-   The bootstrap is for inference not better estimates. It can estimate uncertainty, not improve $\bar{x}$. It is not generating new data out of nowhere. However, see the section on bagging for how bootstrap aggregation can be used.

## Non-parametric bootstrap

The non-parametric bootstrap resamples the data with replacement $B$ times and calculates the statistic on each resample.

## Standard Errors

The bootstrap is primarily a means to calculate standard errors.

The bootstrap standard error is

Suppose there are $r$ bootstrap replicates.
Let $\hat{\theta}^{*}_1, \dots, \hat{\theta}^{*}_r$ be statistics calculated on each bootstrap samples.
$$
\SE^{*}\left(\hat{\theta}^{*}\right) = \sqrt{\frac{\sum_{b = 1}^r {(\hat{\theta}^{*}_b - \bar{\theta}^{*})}^2}{r - 1}}
$$
where $\bar{\theta}^{*}$ is the mean of bootstrap statistics,
$$
\bar{\theta}^{*} = \frac{\sum_{b = 1}^r}{r} .
$$

## Confidence Intervals

There are multiple ways to calculate confidence intervals from bootstrap.

-   Normal-Theory Intervals
-   Percentile Intervals
-   ABC Intervals

## Alternative methods

### Parametric Bootstrap

The parametric bootstrap draws samples from the estimated model.

For example, in linear regression, we can start from the model,
$$
y_i = \Vec{x}_i \Vec{\beta} + \epsilon_i
$$

1.  Estimate the regression model to get $\hat{\beta}$ and $\hat{\sigma}$

1.  For $1, \dots, r$ bootstrap replicates:

    1.  Generate bootstrap sample $(\Vec{y}^{*}, \Mat{X})$, where $\Mat{X}$ are 
        those from the original sample, and the values of $\Vec{y}^{*}$ are generated
        by sampling from the residual distribution,
        $$
        y_i^{*}_b = \Vec{x}_i \Vec{\hat{\beta}} + \epsilon^{*}_{i,b}
        $$
        where $\epsilon^{*}_{i,b} \sim \mathrm{Normal}(0, \hat{\sigma})$.

    1.  Re-estimate a regression on  $(\Vec{y}^{*}, \Mat{X})$ to estimate
        $\hat{\beta}^{*}$.

    1.  Calculate any statistics of the regression results.

Alternatively, we could have drawn the values of $\Vec{\epsilon}^*_b$ from the
empirical distribution of residuals or the [Wild Bootstrap](https://www.math.kth.se/matstat/gru/sf2930/papers/wild.bootstrap.pdf).

See the the discussion in the `boot::boot()` function, for `sim = "parametric"`.

### Clustered bootstrap

We can incorporate complex sampling methods into the bootstrap [@Fox2008a, Sec 21.5].
In particular, by resampling clusters instead of individual observations, we get the clustered bootstrap.[@EsareyMenger2017a]

### Time series bootstrap

Since data are not independent in time-series, variations of the bootstrap have to be used.
See the references in the documentation for `boot::tsboot`.

### How to sample?

Draw the bootstrap sample in the same way it was drawn from the population (if possible) [@Hesterberg2015a, p. 19]

The are a few exceptions:

-   Condition on the observed information. We should fix known quantities, e.g. observed sample sizes of sub-samples [@Hesterberg2015a]
-   For hypothesis testing, the sampling distribution needs to be modified to represent the null distribution [@Hesterberg2015a]

### Caveats

-   Bootstrapping does not work well for the median or other quantities that depend on the small number of observations out of larger sample.[@Hesterberg2015a]
-   Uncertainty in the bootstrap estimator is due to both (1) Monte Carlo sampling (taking a finite number of samples), and (2) the sample itself. The former can be decreased by increasing the number of bootstrap samples. The latter is irreducible without a new sample.
-   The bootstrap distribution will reflect the data. If the sample was "unusual", then the bootstrap distribution will also be so.[@Hesterberg2015a]
-   In small samples there is a narrowness bias. [@Hesterberg2015a, p. 24]. As always, small samples is problematic.

### Why use bootstrapping?

-   The common practice of relying on asymmetric results may understate variability by ignoring dependencies or heteroskedasticity. These can be incorporated into bootstrapping.[@Fox2008a, p. 602]
-   it is general purpose algorithm that can generate standard errors and confidence intervals in cases where an analytic solution does not exist.
-   however, it may require programming to implement and computational power to execute

## Bagging

Note that in all the previous discussion, the original point estimate is used.
Bootstrapping is only used to generate (1) standard errors and confidence intervals (2).

Bootstrap aggregating or [bagging](https://en.wikipedia.org/wiki/Bootstrap_aggregating) is a meta-algorithm that constructs a point estimate by averaging the point-estimates from bootstrap samples.
Bagging can reduce the variance of some estimators, so can be thought of as a sort of regularization method.

## Hypothesis Testing

Hypothesis testing with bootstrap is more complicated.

## How many samples? 

There is no fixed rule of thumb (it will depend on the statistic you are calculating and the population distribution), but if you want a single number, 1,000 is good lower bound.

-   Higher levels of confidence require more samples

-   Note that the results of the percentile method will be more variable than the normal-approximation method.
    The ABC confidence intervals will be even better.

One ad-hoc recipe suggested [here](https://www.stata.com/support/faqs/statistics/bootstrapped-samples-guidelines/) is:

1.  Choose a $B$
1.  Run the bootstrap
1.  Run the bootstrap again (ensure there is a different random number seed)
1.  If results differ, increase the size.

@DavidsonMacKinnon2000a suggest the following:

-   5%: 399
-   1%: 1499

Though it also suggests a pre-test method.

@Hesterberg2015a suggests far a larger bootstrap sample size: 10,000 for routine use.
It notes that for a t-test, 15,000 samples for the a 95% probability that the one-sided levels fall within 10% of the true values, for 95% intervals and 5% tests.

## References

See @Fox2008a [Ch. 21].

@Hesterberg2015a is for "teachers of statistics" but is a great overview of bootstrapping.
I found it more useful than the treatment of bootstrapping in many textbooks.

For some Monte Carlo results on the accuracy of the bootstrap see @Hesterberg2015a, p. 21.

R packages. For general purpose bootstrapping and cross-validation I suggest the **[rsample](https://cran.r-project.org/package=rsample)** package, which works well with the tidyverse and seems to be
useful going forward.

The **[boot](https://cran.r-project.org/package=boot)** package included in the recommended R packages is a classic package that implements many bootstrapping and resampling methods. Most of them
are parallelized. However, its interface is not as nice as rsample.

-   <https://www.statmethods.net/advstats/bootstrapping.html>
-   <http://avesbiodiv.mncn.csic.es/estadistica/boot1.pdf>

See [this spreadsheet](https://docs.google.com/spreadsheets/d/1MNOCwOo7oPKrDB1FMwDzsYzvLoK-IBqoxhKrOsN1M2A/edit#gid=0) for some Monte Carlo simulations on Bootstrap vs. t-statistic.
