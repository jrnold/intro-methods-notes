
# Weighted Regression

## Weighted Least Squares (WLS)

Ordinary least squares estimates coefficients by finding the coefficients that minimize the sum of squared errors,
$$
\hat{\vec\beta}_{OLS} = \argmin_{\vec{b}} \sum_{i = 1}^N (y_i - \vec{x}\T \vec{b})^2 .
$$
In the objective function, it treats the errors of all observations equally. 
However, there may be situations where we are more concerned about minimizing some errors more than others.
For example, suppose we know that some $y_i$ have more measurement error than others, then we may care more about minimizing errors for those $y_i$ which we are more certain about.

In weighted least squares (WLS) we estimate the coefficients by finding the values that minimize the *weighted* sum of squared errors,
$$
\begin{aligned}[t]
\hat{\vec\beta}_{WLS} = \argmin_{\vec{b}} \sum_{i = 1}^N w_i (y_i - \vec{x}\T \vec{b})^2
\end{aligned}
$$
where $w_i$ are the weights for each observation.
Note that OLS is a special case of WLS where $w_i = 1$ for all the observations.
In order to minimize the errors, WLS will have to fit the line closer to observations with higher weights



## When should you use WLS?

The previous section showed what WLS is, but when should you use weighted regression?
Well, it depends on the purpose of your analysis:

1. If you are estimating population descriptive statistics, 
  then weighting is needed to ensure that the sample is representative of the population.
2. If you are concerned with causal inference, then weighting is more nuanced. 
  You may or may not need to weight, and it will often be unclear which is better.

There are three reasons for weighting in causal inference [@SolonHaiderWooldridge2015a]:

1. To correct standard errors for heteroskedasticity
2. Get consistent estimates by correcting for endogenous sampling
3. Identify average partial effects when there is unmodeled heterogeneity in the effects.

*Heteroskedasticity:* Estimate OLS and WLS. If the model is misspecified or there is endogenous selection, then  OLS and WLS have different probability limits. The constrast between OLS and WLS estimatates is a diagnostic for model misspecification or endogenous sampling.  Always use robust standard errors.

*Endogenous sampling:* If the sample weights vary exogenously instead of endogenously, then weighting may be harmful for precision. The OLS still specifies the conditional mean. Sampling is exogenous if the sampling probabilities are independent of the error - e.g. if they are only functions of the explanatory variables. If the probabilities are a function of the dependent variable, then they are endogenous. 

- if sampling rate is endogenous, weight by inverse selection.
- use robust standard errors. 
- if the sampling rate is exogenous, then OLS and WLS are consistent. 
    Use OLS and WLS as test of model mispecification.

*Heterogeneous effects:* Identifying average partial effects. WLS estimates the linear regression of the population, but this is not the same as the average partial effects. But that is because OLS does not estimate the average partial effect, but weights according to the variance in X.


## Sampling Weights

Using sampling weights is most important for univariate statistics which are estimates of population parameters. 
However, whether to use them when estimating a regression is less clear.

- if sample weights are a function of $X$ only, estimates are unbiased and more efficient without weighting
- if the sample weights are a function of $Y | X$, then use the weights

With fixed $X$, regression does not require random sampling, so the sampling weights of the 
$X$ are irrelevants.

If the original unweighted data are homoskedastic, then sampling weights induces heteroskedasticity.
Suppose the true model is,
$$
Y_i = \vec{x}\T \vec{\beta} + \varepsilon_i
$$
where $\varepsilon_i \sim N(0, \sigma^2)$.
Then the weighted model is,
$$
\sqrt{w_i} Y_i = \sqrt{w_i} \vec{x}\T \vec{\beta} + \sqrt{w_i} \varepsilon_i
$$
and now $\sqrt{w_i} \varepsilon_i \sim N(0, w_i \sigma^2)$.

If the sampling weights are only a function of the $X$, then controlling for $X$ is sufficient.
In fact, OLS is preferred to WLS, and will produce unbiased and efficient estimates.
The choice between OLS and WLS is a choice between different distributions of $\mat{X}$.
However, if the model is specified correctly the coefficients should be the same, regardless
of the distribution of $\mat{X}$.
Thus, if the estimates of OLS and WLS differ, then it is evidence that the model is misspecified.

@WinshipRadbill1994a suggest using the method of @DumouchelDuncan1983a to test whether the OLS and WLS are difference.

1. Estimate $E(Y) = \mat{X} \beta$
2. Estimate $E(Y) = \mat{X} \beta + \delta \vec{w} + \vec{\gamma} \vec{w} \mat{X}$,
    where all $X$
3. Test regression 1 vs. regression 2 using an F test.
4. If the F-test is significant, then the weights are not simply a function of $X$. Either try to respecify the model or use WLS with robust standard errors. 
    If the F-test is insignificant, then the weights are simply a function of $X$. Use OLS.

Modern survey often use complex multi-stage sampling designs.
Like clustering generally, this will affect the standard errors of these regressions.
Clustering by primary sampling units is a good approximation of the standard errors from multistage sampling.


## References

The WLS derivation can be found in @Fox2016a, p. 304--306

Textbook discussions: @AngristPischke2009a, p.d 91--94, @AngristPischke2014a, p. 202--203, 

@SolonHaiderWooldridge2015a is a good (and recent) overview with practical advice of when to weight and when not-to weight linear regressions. Also see the advice from the [World Bank blog](http://blogs.worldbank.org/impactevaluations/tools-of-the-trade-when-to-use-those-sample-weights).
See also @Deaton1997a, @DumouchelDuncan1983a, and @Wissoker1999a.

@Gelman2007a, in the context of post-stratification, proposes controlling for variables related to selection into the sample instead of using survey weights; also see the responses [@BellCohen2007a; @BreidtOpsomer2007a; @Little2007a; @Pfeffermann2007a], and rejoinder [@Gelman2007b] and [blog post](http://andrewgelman.com/2015/07/14/survey-weighting-and-regression-modeling/).
Gelman's approach is similar to that earlier suggested by @WinshipRadbill1994a.

For survey weighting, see the R package **[survey](https://cran.r-project.org/package=survey)**.
