
# Panel Data: Fixed Effects and Difference-in-Difference

Another source of variation is repeated measures of the same unit over time.
This can allow for identification with different identifying assumptions.
There are two identification approaches we will focus on

1.  Fixed Effects
1.  Different-in-Difference

See @AngristPischke2014a [Ch. 5] and @AngristPischke2009a [Ch 5] on fixed effects
and difference-in-difference approaches.

## Panel (Longitudinal) Data

In these methods there are repeated measurements of the same unit over time.
This requires different methods and also has implications for causal inference.
While simply having panel data does not identify an effect, it allows the researcher to claim identification using different assumptions than simply selection on observables (as in the cross-sectional case).

## Terminology

There are several closely related concepts and terminology to cover.

Panel (longitudinal) data

:    small $T$, large $N$. Examples: longitudinal surveys with a few rounds.

Time series cross-section data

:    large $T$, medium $N$. Examples: most country-year panels in CPE/IPE with several decades of data.

For the purposes of causal inference, identification relies on the same assumptions.
However, different estimators work differently under different data types.
Some estimators work well as $N \to \infty$, some as $T \to \infty$, and usually these are not the same.
Additionally, longer time series may require and/or have enough data for the researcher to estimate serial correlation in the errors.

There are some additional related concepts that should also be mentioned at this time, hopefully to spare the reader future confusion (and not to add to it):

Hierarchical Models

:    units nested within groups. E.g. children in schools, districts within states

Time-series Models

:    large $T$, usually $N = 1$, or the different units modeled separately.

Terminology can be confusing and varies across fields and literatures.
In particular, fixed effects and random effects are used differently and often estimated differently in statistics and econometrics.
This is easily seen by comparing the **lme4** and **plm** packages in R which both estimate fixed and random effects models.
Hierarchical models will often used fixed and random effects even though there is no *time* component, and thus they are not longitudinal models.
The reason that I bring up this terminology is that if you search for fixed and random effects you can quickly be confused when it seems that people are talking about seemingly different concepts; they more of less may be.

By panel data we will mean repeated measures for a unit, $i \in 1, \dots, N$, over time, $t \in 1, \dots, T$.

-   same individuals in multiple surveys over time
-   countries or districts over years
-   individuals over time

There are many different terms for repeated measurement data, including longitudinal, panel, and time-series cross-sectional data.
Generally,

The issues of causality are mostly the same, for these two types of data.
However, the estimation methods are different. Estimation methods often rely on asymptotic assumptions about observations going to infinity.
In repeated measurements there are two dimensions: number of units, and number of periods.
Different estimators will work better for small $T$ vs. large $T$, and small $N$ vs. large $N$.

## Fixed Effects

Suppose that there are $i \in 1, \dots n$ unit, and $t \in 1, \dots, T$ time periods.
The key assumption is that the treatment is independent of time, observed covariates,
*and the identity of the observation.
$$
\E[Y_{it}(0) | U_i, X_{it}, t, D_{it}] = \E[Y_{it}(0) | U_i, X_{it}, t]
$$
This is effectively a control for an unobserved factors for a unit.

We need to make a few assumptions.
Assume that time and linear effects are constant,
$$
\E[Y_{it}(0) | U_i, X_{it}, t] = \alpha + U_i' \gamma + X'_{it} \beta .
$$

Assume that the causal effect is constant, and has a linear functional form:
$$
\E[Y_{it}(1) | U_i, X_{it}, t] =  \E[Y_{it}(0) | U_i, X_{it}, t] + \tau
$$

Together this implies
$$
\E[Y_{it} | U_i, X_{it}, t, D_{it}] = \alpha + \tau D_{it} + \delta_{t} + U_i' \gamma + X' \beta .
$$
This implies,
$$
Y_{it} = \alpha_i + \delta_t + \tau D_{it} + X'_{it} \beta + \epsilon_{it}
$$
where
$$
\epsilon_{it} = Y_{it}(0) - \E[Y_{it}(0) | U_i, X_{it}, t] .
$$
This implies that the fixed effects regression will be a CEF if $\epsilon_{it}$ has an expected value of 0.

Fixed effects allows us to identify causal effects within units, and it is constant within the unit.
You can think of this as a special kind of control.

This requires some more stringent functional forms assumptions than regression, but it also can handle a specific form of unobserved confounders.

### Estimators

Given this model, there are several different estimators that are used.

#### Within Estimator

First calculate the unit-level averages,
$$
\bar{Y}_i = \alpha_i + \bar{\delta} + \tau \bar{D}_{i} + \bar{X}_{it}' \beta + \bar{\epsilon}_{i} .
$$
The within estimator subtracts these unit-level means from the response, treatment, and all the controls:
$$
Y_{it} - \bar{Y}_i = (\delta_t - \bar{\delta}) + (X_{it} - \bar{X}_i)' \beta + \tau (D_{it} - \bar{D}_i) + (\epsilon_{it} - \bar{\epsilon}_{i})
$$
Also note that since $\bar{Y}_i$ are unit averages,
and the unobserved effect is constant over time, subtracting off the mean also subtracts that unobserved effect.

Implications are:

-   Cannot use fixed effects to estimate causal effects of treatments that are constant within a unit.
-   We do not need to include any time-constant controls.
-   Only removes time-constant unobserved effects in a unit. See difference-in-difference for a method to remove some types of time-varying unobserved values.

#### Least Squares Dummy Variable (LSDV)

Dummy variable regression is an alternative way to estimate fixed effects models.
Called the least squared dummy variable (LSDV) estimator.
Include a matrix of indicator variables ($W_i$) for each observation.
$$
Y_{it} = \tau D_{it} + w_i' \gamma + x'_{it} \beta + \epsilon_{it}
$$

-   Within vs. LSDV are equivalent algebraically.

-   LSDV is more computationally demanding.  With $p$ covariates and $G$ groups,
    within estimator's design matrix has only $p$ columns, whereas the LSDV design matrix has $p + G$ columns.

-   If the within estimator is manually estimated by demeaning variables and then using OLS, the standard errors will be incorrect.
    They need to account for the degrees of freedom due to calculating the group means.

-   In LSDV, the fixed effects themselves are not consistent if $T$ fixed and $N \to \infty$.
    However, the other coefficients are consistent, and those are the ones we care about. [@AngristPischke2009a p. 224]

#### First-differences estimation

Given that $U_i$ is constant over time,  first difference model is an alternative to mean-differences.
The model is,
$$
\begin{aligned}[t]
Y_{it} - Y_{i,t-1} &=  (x'_{it} - x'_{i,t-1}) \beta + \tau (D_{it} - D_{i,t-1}) + (\epsilon_{it} - \epsilon_{i,t-1}) \\
\Delta Y_{it} &= \Delta x'_{it} \beta + \tau \Delta D_{it} + \Delta \epsilon_{it}
\end{aligned}
$$

-   If $U_i$ are time-fixed, then first-differences are an alternative to mean-differences
-   If the difference in errors, $\Delta \epsilon_{it}$ are homoskedastic, OLS standard errors work fine.
-   But implies that original errors must have had serial correlation: $\epsilon_{it} = \epsilon_{i,t-1} + \Delta \epsilon_{it}$.
-   If serial correlation, then more efficient than FE.
-   Robust/sandwich SEs can be used.

See @AngristPischke2009a [Ch 5.3] for a discussion of the difference between lagged dependent variables and fixed effects.

-   LDV and FE estimators bound the causal effect of
    interest [@AngristPischke2009a, p. 246].

-   If lagged dependent variable and fixed effect are both included then there is
    bias. Though this bias is not too bad and declines with the amount of data (CITE?).
    Instrumental variable approaches can be used, which are unbiased but very high
    variance, and thus OLS is often as good (same CITE)

### Issues with Fixed Effects

-   The only use within unit variation. This does not address changes over time.

-   Susceptible to measurement error. There may be little variation within each unit.
    This will make it harder to estimate effects, which is okay, because the lack of within-unit variation tells us that this is a poor identification strategy.
    IV could be used [@AngristPischke2014a, p. 226]

-   Fixed effects only identifies **contemporaneous effects**.
    See @Blackwell2013a for an approach to dynamic panel data .

-   Since a fixed effect approach can usually be turned into a
    difference-in-difference approach by including period level dummies,
    there is often little reason not to do a DiD.

## Difference-in-Difference

The difference-in-difference estimator is similar to the fixed effect model, but relies on different assumptions.

### Basic differences-in-differences model

|        | Treatment                 | Control                  |
|--------|---------------------------|--------------------------|
| Pre    | $E(Y_{i1}(0) | D_i = 1)$  | $E(Y_{i1}(0) | D_i = 0)$ |
| Post   | $E(Y_{i2}(1) | D_i = 1)$  | $E(Y_{i2}(0) | D_i = 0)$ |

The difference-in-difference (DiD) estimator is
$$
DiD = \underbrace{(\E(Y_{i2}(1) | D_i = 1) -  \E(Y_{i1}(0) | D_i = 1))}_{\text{Treatment Difference}} -
\underbrace{(\E(Y_{i2}(0) | D_i = 0) - E(Y_{i1}(0) | D_i =  0))}_{\text{Control treatment}} .
$$

For the general case of multiple time periods $t = 1, \dots, T$, for observations $i = 1, \dots, N$ in $g = 1, \dots, G$ groups, the DiD regression is,
$$
y_{itg} = \alpha +
\underbrace{\sum_{t = 1}^T \beta_{t} I(t = \tau)}_{\text{time dummies}} +
\underbrace{\sum_{k = 1}^G \gamma_{g} I(k = g)}_{\text{group dummies}} + \underbrace{\delta D_{tg}}_{\text{treatment}} + \epsilon_{it}
$$

Identification comes from inter-temporal variation *between* groups.

### Potential Outcomes Approach to DiD

#### Constant Effects Linear DiD Model

Causal effects are constant across individuals and time,
$$
\E[Y_{it}(1) - Y_{it}(0)] = \tau .
$$
The effects of time $\delta_t$ and individuals $\alpha_g$ are linearly separable,
$$
\E[Y_{it}(0)] = \delta_t + \alpha_{g} .
$$
Then the model is,
$$
Y_{igt} = \delta_{t}
$$

### Threats to identification

-   Treatment independent of idiosyncratic shocks, so variation in outcome is the same for treated and control groups.
-   Example: Ashenfelter's Dip is an empirical phenomena in which people who enroll in job training programs see their earnings decline .
-   It may be possible to condition on covariates (control) in order to make treatment and shocks independent.

### Robustness Checks

-   Lags and Leads

    -   If $D_{igt}$ causes $Y_{igt}$, then current and lagged values should have an effect on $Y_{igt}$, but future values of $D_{igt}$ should not.

-   Placebo permutation test. Randomly assign the intervention(s) to create the sampling distribution of the null hypothesis.

-   Use different comparison groups. Different groups should
    have the same affect.

-   Use an outcome variable that you know is not affected by the intervention.
    If DiD estimates not zero, then there is some other difference between groups.

-   Time Trends

    -   If more than two time periods, add unit specific linear trends to regression DiD model.
        $$
        Y_{igt} = \delta_{t} + \tau G_{i} + \alpha_{0g} + \alpha_{1g} \times t + \epsilon_{igt} ,
        $$
        where $\alpha_{0g}$ are group fixed effects,  $\delta_t$ is the overall (not necessarily linear) time trend,
        and $\alpha_{1g}$ is the group linear time trend.

    -   Helps detect if varying trends when estimated from pre-treatment data.

### Extensions

The general DiD model relies on linear-separability and constant treatment effects.

The **parallel trends** assumption is the important assumption:
$$
\E[ Y_{i1}(0) - Y_{i0} | X_i, G_i = 1] = \E[ Y_{i1}(0) - Y_{i0} | X_i, G_i = 0].
$$
It says that the potential trend under control is the same for the control and treated groups, conditional on covariates.

With the parallel trends assumption unconditional ATT is,
$$
\E[Y_{i1}(1) - Y_{i1}(0) | G_i = 1] = \E_{X}[\E[Y_{i1}(1) - Y_{i1}(0) | G_i = 1]] =
, 𝐺𝑖 = 1]].
$$
What we need is an estimator of each CEF.
This doesn't need to be linear or parametric.

However, cannot estimate ATE because $\E(Y_{i1}(1) | X_i, G_i = 0)$ could be anything.

With covariates we can estimate conditional DiD in several ways.

-   Regression DiD
-   Match on $X_i$ and then use regular DiD
-   Weighting approaches Abadie (2005)

Regression DiD includes $X_i$ in a linear, additive manner,
$$
Y_{it} = \mu + x'_i \beta_t + \delta I(t = 1) + \tau(I(t = 1) \times G_i) + \epsilon_{it}
$$
If there are repeated observations, take difference between $t = 0$ and $t = 1$,
$$
Y_{i1} - Y_{i0} = \delta + x'_i \beta + \tau G_i +
(\epsilon_{i1} - \epsilon_{i0})
$$
Have $\beta = \beta_1 - \beta_0$.
Because everyone is untreated in first period, $D_{i1} - D_{i0} = D_{i1}$.

For panel data, regress changes on treatment.

Depends on constant effects and linearity in $X_i$.
Matching could reduce model dependence.

### Standard Error Issues

#### Serial Correlation

A major issue with errors in difference-in-difference models is serial correlation [@BertrandDufloMullainathan2004a].
Consider the DiD model,
$$
Y_{igt} = \mu_g + \delta_t + \tau (I_{it} \times G_i) + \nu_{gt} + \epsilon_{igt} .
$$
The problem is that $\nu_{gt}$ can be serially correlated
$$
Cor(\nu_{gt}, \nu_{gs}) \neq 0 \text{ for } s \neq t .
$$
An example called $AR(1)$ serial correlation is when each $\nu_t$ is a function of its lag,
$$
\nu_t = \rho \nu_{t - 1} + \eta_t \text{ where } \rho \in (0, 1).
$$
Since errors are usually positively correlated, the outcomes are correlated over time and effectively there are fewer independent observations in the sample; it's almost as if the same observation was simply copy and pasted over time with a little error added.
This will mean that the standard errors will likely be too optimistic (too narrow).
See @BertrandDufloMullainathan2004a for a longer discussion of this.
here are a couple of solutions:

-   Clustered standard errors at the **group** level
-   Clustered bootstrap (re-sample groups, not individual observations)
-   Aggregated to $g$ units with two time periods each: pre- and post-intervention. Since correlation makes the panel data closer to simply a two-period DiD, this takes that all the way.

All these solutions depend on larger numbers of groups.
Do not use the off-the-shelf clustered standard errors unless the number of groups is large.
See @EsareyMenger2018a for an extensive discussion of this.
Also see the associated **clusterSE** package and **clubSandwich** for implementations of
cluster robust standard errors that work with smaller numbers of clusters.

### Other DiD Approaches

Changes-in-changes [@AtheyImbens2006a] generalizes DiD to allow for different changes in the distribution of $Y_{it}$, not just the mean.
This allows for estimating ATT or any changes in distribution (quantiles, variance, etc.).
Unfortunately requires more data than estimating the mean.

Synthetic controls is used when there is one treated group, but many controls. (See Abadie and Gardeazabel and the paper on the Seattle minimum wage).

The basic idea is to compare the time series of the outcome in the treated group to a control.

-   But what if there are many control group?
-   What if they aren't comparable to the treated?

Synthetic control uses a weighted average of different controls.

## Lagged Dependent Variables

This is a different thing ...

See @Dafoe2018a for advice on when to use LDV.

A different model is to assume a lagged dependent variable,
$$
Y_{i,t} = \rho Y'_{i,t-1} + X'_{i,t} \beta + \varepsilon_{i,t}
$$
This captures some of the unit-specific aspects that the fixed effects capture.
However, the LDV model is making a different assumption than fixed effects.
The FE model assumes that each unit has a separate effect that is constant over time, while the LDV model assumes that anything specific about a unit is captured through the value of the dependent variable in the previous period.

Beck and Katz recommendation of LDV with PCSE.

The LDV and Fixed Effects models make different assumptions, and they are not nested.
So why not combine them into a single model?
$$
Y_{i,t} = \rho Y'_{i,t-1} + X'_{i,t} \beta + \alpha_i + \varepsilon_{i,t} .
$$
There is a problem with this approach. OLS is biased. The fixed effect estimator includes demeaned values of the outcome variable and covariates. S
 the FE model with a LDV will use $Y_{i,t - 1} - \bar{Y}_{i,t-1}$. This average includes $Y_{i,t}$ and $Y_{i,t} = ... + \varepsilon_{i,t}$. T
us by construction, $Y_{i,t} - \bar{Y}_{i,t-1}$ is correlated with the errors.

So what can we do about this? There are two options.

1.  Ignore it. The bias is proportional to $1/T$. In panels with 20 or more periods, the bias may be small.
    Moreover, the bias is generally largest in the coefficient of the lagged dependent variable itself,
    which may not be of primary interest. Accept the bias.

1.  Use both LDV and FE models. The LDV and FE methods can bound the effects of the coefficient of interest. See @AngristPischke2009a.

1.  Use IV methods to instrument the lagged dependent variable. See Arrellano-Bond methods.

This is a case where the difference between panel and TSCS is important.
In many TSCS settings with larger $T$ it is probably fine to estimate fixed effects with LDV.
However, if you have panel data model with few $T$, then you should use either method 2 or 3.

## Random Effects

Consider the panel data model,
$$
Y_{i,t} = \alpha + X'_{i,t} \beta + u_i + \varepsilon_{i,t}
$$
In fixed effect, the errors are assumed to be uncorrelated with both the unit effects and the covariates,
$$
\E(\varepsilon_{i,t} | X_{i}, u_i) = 0 .
$$
With random effects we make an additional assumption, the unit effects are uncorrelated with the covariates,
$$
\E(u_i | X_i) = \E(u_i) = 0 .
$$

What this means that under the assumptions of random effects, omitting $u_i$ would not bias $\beta$ since they are assumed to be uncorrelated with $X$. Thus, there's no omitted variable bias.

So why use random effects? To fix standard errors.
$$
Y_{i,t} = X'_{i,t} \beta + \nu_i
$$
where $\nu_i = u_i + \varepsilon_{i,t}$.
However, this means that
$$
\Cov(Y_{i,1}, Y_{i,2} | X_{i,t}) = \sigma^2_u .
$$
This violates the OLS assumption of non-autocorrelation.
Using random effects gets consistent standard errors.

### How to estimate random effects?

There are a variety of methods, but the econometric method is to use **quasi-demeaning** or **partial pooling**,
$$
(Y_{i,t} - \theta \bar{Y}_i) = (X_{i,t} - \bar{X}_i)' \beta + (\nu_{i,t} - \theta \Var{\nu}_i)
$$
where $\theta \in [0, 1]$ where $\theta = 0$ is OLS, and $\theta = 1$ is fixed effects.
Some math (TM) shows,
$$
\theta = 1 - \left( \sigma_u^2 / (\sigma^2_u + T \sigma^2_epsilon) \right)^{1/2} .
$$
The **random effects estimator** runs pooled OLS on this model, but replaces $\theta$ with the estimate $\hat{\theta}$.

See the R package **plm**.

The R package **lme4** and Bayesian methods, e.g. Gelman and Hill, take a different approach to estimating random effects.
