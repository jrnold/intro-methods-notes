
# Regression

Two views of regression:

1.  Linear regression is a model of the data generating process:

    $$
    \begin{aligned}
    Y &= X \beta + \epsilon \\
    \epsilon &\sim \mathsf{Normal}(0, \sigma^2)
    $$

    -   Gauss-Markov assumptions mean BLUE
    -   $\hat{beta}$ unbiased $\epsilon$ uncorrelated with $y$, $\beta$ are unbiased even if assumptions about errors are wrong.
    -   If errors uncorrelated and homoskedastic, if sample size large, the classic standard errors are correct even if errors aren't normal.

1.  Conditional expectation function

    -   OLS is also a model of $E(y| X)$, which is what we are interested
    -   Even if the functional form is **wrong** (not-linear), OLS produces the best *linear approximation to the conditional expectation function (CEF)*.

Agnostic justifications for

1.  When is a CEF Linear?

    1.  *Saturated model*
    1.  Outcome and covariates are *multivariate normal*

1.  OLS produces the best linear predictor (mean squared error) of $y_i$

Asymptotic OLS Inference

$$
\hat{\beta}_{OLS} = (X'X)X'y \approx E(Y | X)
$$

Heteroskedasticity

When will it occur?

1.  CEF is linear, but $\sigma^(x) = \Var(Y_i | X = x)$ is not linear
1.  $E(Y_i | X_i)$ is not linear, but use a linear regression to approximate it.

How to estimate the variance covariance matrix of $\beta$?

## Observational Studies

Identification assumptions

1.  Positivity: All observations can receive the treatment
    $$
    0 < \Pr(D_i = 1|X, Y(1), Y(0)) < 1
    $$

1.  No unmeasured confounding
    $$
    \Pr(D_i = 1 | X, Y(1), Y(0)) = \Pr(D_i = 1 | X)
    $$
    or
    $$
    D_i \perp (Y_i(0), Y_i(1) | X_i
    $$
    This can be called unconfoundedness, ignorability, selection on observables,
    no omitted variables, exogenous, conditional exchangeable.

## Regression and Causality

-   What does it mean for the $\hat{\beta}$ to be biased?
-   OVB Doesn't make sense without a causal question?
-   Regression is causal if the CEF is causal
-   When is the CEF is causal?

## Treatment Effects

-   Potential outcomes $Y_i(1)$ and $Y_i(0)$.

-   ATE (Average Treatment Effect)
    $$
    \tau = E(Y_i(1) - Y_i(0))
    $$

-   ATT (Average Treatment Effect on the Treated)
    $$
    \tau_{ATT} = E(Y_i(1) - Y_i(0) | D_i = 1)
    $$

## OLS

Suppose there is a constant treatment effect, $\tau$:
$$
\begin{aligned}
Y_i(0) &= \alpha + X'_i \beta + u_i \\
Y_i(1) &= \alpha + \tau + X'_i \beta + u_i
\end{aligned}
$$
This means that
$$
Y_i(1) - Y_i(0) = \tau
$$
for all observations.

The usual regression formula is,
$$
\begin{aligned}[t]
Y_i &= \underbrace{Y_i(1) D_i}_{\text{received treatment} } + \underbrace{Y_i(0) (1 - D_i)}_{\text{didn't receive treatment}} \\
&= \color{orange}{Y_i(0)} + \color{blue}{(Y_i(1) - Y_i(0)) D_i} \\
&= \color{orange}{\alpha} + \color{blue}{\tau D_i} + \color{orange}{x'_i \beta} + \color{orange}{u_i}
\end{aligned}
$$

Remember regression anatomy?

Estimate residuals of regression of the treatment and outcome on the covariates
$$
\begin{aligned}
\tilde{Y}_i = Y_i - E(Y_i | X_i)  \\
\tilde{D}_i = D_i - E(D_i | X_i)
\end{aligned}
$$

Then running a regression of $\tilde{Y}_i$ on $\tilde{D}_i$ is equivalent to controlling for $X_i$.
$$
\begin{aligned}
\tilde{Y}_i &= \alpha + \tau D_i + x'_i \beta + u_i \\
\tilde{Y}_i &= \alpha + \tau \tilde{D}_i + \tilde{u}_i
\end{aligned}
$$

What does OLS estimate?
$$
\hat{\tau}_{OLS} = \tau + \frac{\Cov(\tilde{D}_i, \tilde{u}_i)}{\Var(\tilde{D}_i)}
$$

The key identification assumption is
$$
\Cov(\tilde{D}_i, \tilde{u}_i) = 0
$$
I.e. conditional on $X$, there is no relationship between $D_i$ and $u_i$.

So $u_i$ is a function of $X_i$ and $Y_i(d)$:

-   $u_i = Y_i(0) - \alpha - X'_i \beta$ when $D_i = 0$
-   $u_i = Y_i(1) - \alpha - \tau - X'_i \beta$ when $D_i = 1$
-   Given $X_i$, only variation in $u_i$ comes from $Y_i(d)$

No unmeasured confounding implies this:
$$
D_i \perp (Y_i(1), Y_i(0)) | X_i \to D_i \perp u_i | X_i \to \Cov(\tilde{D}_i, \tilde{u}_i) = 0
$$

What if it is violated?

Suppose there is an omitted variable $Z_i$ (residualized from $X_i$),
$$
\tilde{u}_i = \gamma \tilde{Z}_i + \omega_i
$$

$$
\hat{\tau}_{OLS} = \tau + \gamma \frac{\Cov(\tilde{D}_i, \tilde{Z}_i)}{\Var(\tilde{D}_i)}
$$

What is the bias in OLS?

1.  Coefficient of $Z$ on $y$ ($\gamma$)
1.  Correlation between $\tilde{D}_i$ and $\tilde{Z}_i$

## Heterogeneous Effects and Regression

When does $\tau = \tau_R$?

-   Constant treatment effects: $\tau(x) = \tau = \tau_{R}$
-   Constant probability of treatment: $e(x) = P(D_i = 1|X_i = x) = e$
-   Incorrect model (linearity) in $X$ leads to more bias

## Balance and Imbalance

See Gelman and Hill (p. 202)

Overlap: the extent to which the range of data is the same across treatment groups

Balance: the extent to which the distribution of data is the same across treatment groups

Imbalance and lack of overlap mean more reliance on the model.

How to evaluate overlap ... see below. But plotting the averages of groups for a binary variable (Gelman and Hill, p. 202), or the standardized coefficients of regressions for continuous variables is one way.

Convex hull

King and Zheng: The bias comes from four sources:
$$
\text{Bias} = \hat{\tau}_{OLS} - \tau = \Delta_o + \Delta_p + \Delta_{e} + \Delta_{i}
$$
where

-   $\Delta_o$: Omitted variable bias
-   $\Delta_p$: Post-treatment bias
-   $\Delta_e$: Extrapolation bias---wrong functional form outside the available data
-   $\Delta_i$: Interpolation bias---wrong functional form inside the available data

One way to address this:

The problem: lack of overlap and balance can lead to higher $\Delta_i$ and $\Delta_e$.

What can we do about it?

-   check for balance and overlap
-   use matching instead of regression
-   matching before regression. Sometimes called doubly robust.

## Key Things

1.  Agnostic view of regression: CEF and robust standard errors
1.  How to evaluate OVB?
1.  Model dependence
1.  Pre-treatment vs. post-treatment variables
1.  Regression vs. matching

## Limited Dependent Variables

-   Usual advice: use logit/probit for binary, Poisson for counts

-   OLS (with robust SE) is correct when:

    -   binary treatment and no covariates (difference in means)
    -   binary treatment, discrete covariates, saturated models (stratified diff-in-means)

-   In unsaturated models, OLS is not bad

    -   Want estimate of the Average Marginal Effect ($\int_X p(X) E(y | X) dX$).

    -   OLS "line" is not a good estimator of any individual marginal effect,
        but may be fine for overall AME.

    -   Logit/probit/Poisson:

        -   try to get model of CEF
        -   then calculate AME from estimated CEF

    -   Logit/probit/Poisson impose additional distributional assumptions to
        get CEF. Can help if good. Can hurt if wrong. May not be necessary if
        only care about AME.

    -   More common in econ than political science. Many marginally
        methodological political scientists will look at using OLS for LDVs
        weirdly. Do whatever the reviewer wants even if they are wrong on this
        front. The entire point is that OLS vs. these models probably won't be
        that different for AME (but if they are ... you probably have to think
        very carefully about your model).

## Assessing Selection on Observables

It's not testable, because it places no restrictions on the observed data.
It requires that the distribution of $Y_i(0)$ is the same for the treatment and non-treatment groups,
$$
\underbrace{p( Y_i(0) | D_i = 1, X_i )}_{\text{unobserved}} = \underbrace{p(Y_i(0) | D_i = 0, X_i)}_{\text{observed}}
$$
But that requires observing the *counterfactual*, which isn't known.

Can use DAGs to use find variables to control for via the *backdoor criterion*, but the DAG must be correct.

What can we do?

1.  Placebo tests: Test a different $D_i$ (placebo) that should have no effect.
1.  Balancing tests:  Test that the observed covariate distributions are the same for the treated and untreated groups.
1.  Sensitivity/Coefficient stability tests: Test that the treatment effect is insensitive to the addition of new control variables.
1.  Control for as much pre-treatment variables as possible and use principled variable selection methods to optimally trade-off bias and variance.

But the general problem is that this assumption is fundamentally untestable.
This is why there is a preference for experiments and methods that try to rely on plausibly exogenous variation in the assignment of $D_i$:

-   instrumental variables (randomization + exclusion restriction)
-   over-time-variation (diff-in-diff, fixed effects)
-   arbitrary thresholds for treatment assignment (RDD)

## Omitted Variable Tests

The long equation, where we are interested in the estimate of $\beta$:
$$
y_i = \alpha + \beta x_i + \gamma z_i + \epsilon
$$
If we estimate
$$
y_i = \alpha^{(s)} + \beta^{(s)} x_i + \epsilon^{(s)}
$$
the omitted variable bias formula is,
$$
\beta^{(s)} - \beta = \gamma \delta
$$
where $\delta$ is the coefficient of the *balancing equation* (regression of $x_i$ on $z_i$):
$$
z_i = \delta_0 + \delta x_i + u_i .
$$

How to assess omitted variable bias?

**Balancing tests:** Test the null hypothesis that $x$ and $z$ are uncorrelated.
$$
H_0: \delta = 0
$$

**Coefficient comparison** (sensitivity) test,
$$
H_0: \beta^{(s)} - \beta = 0
$$

Note that the coefficient comparison test is equivalent to
$$
H_0: \beta^{(s)} - \beta = 0 \leftrightarrow \delta = 0 \text{ or } \gamma = 0
$$

How to implement these? More difficult for multiple controls.

*Balancing test*: Regress $z$ on $x$. Hard with multiple controls. See Sec 5.4.

*Covariate comparison*: Basically the assumption/intuition in these tests is that going from no-controls to observed controls gives the researcher some insight into how problematic unobserved controls could be.

-   Informally compare coefficients. Add variables and see if $\hat{\beta}$ changes substantively.

-   Hausmann test and Chow tests proposed in Hausmann. Pischke and Pei.

-   Altonji, Elder, and Taber (2005) propose and Nunn and Wantchekon (2011)
    use a slightly different method assess potential bias. Let $\hat{\beta}$ be
    the OLS estimate of $\beta$ from the full regression (all covariates),
    and $\hat{\beta}^{(s)}$ be the OLS estimate from a regression with no
    (or few) controls. Calculate
    $$
    B = \frac{\hat{\beta}}{\hat{\beta}^{(s)} - \hat{\beta}} .
    $$
    The smaller $\hat{\beta}^{(s)} - \hat{\beta}$, the less the regression is selected by selection on observables.
    This should be greater than one. The interpretation of $B$ is that it is the multiplier that unobserved covariates would have to have in order to make the estimated effect equal to zero.

This coefficient stability argument makes some sense. If we think of observed covariates as a sample from the population of possible covariates, they provide information about the distribution of other unobserved covariates. But this sample isn't random, and that can have perverse incentives:

-   If the researcher does a good job controlling for confounders, then the
    effect of future confounders may appear large.

-   If the researcher does a poor job controlling for confounders, then the
    effect of future confounders will appear minimal.

-   This depends on a pre-existing "good" model, but there's no way to assess
    that.  Oster (2016) adjusts this method to account for the $R^2$ of the
    regression. If it explains a lot, there is less for omitted variables to
    do. However, the solution is complicated.

## My Advice

-   Focus on one variable at a time (no all causes regression)

-   Control for as many pre-treatment covariates as you can

-   Check that you aren't controlling for post-treatment variables

-   If you are only interested in the AME of the treatment, you can include
    it as a linear term.

-   It is more important to be flexible as the controls (while trading off
    bias and variance). You shouldn't worry about discretizing continuous
    controls. It isn't *wrong* because they are continuous. It may or may not
    be useful for improving balance.

-   Formally or informally check the balance and overlap of your regression.

-   Use regression anatomy to understand how many effective number of
    observations you have ... which observations have the most variation in
    the treatment after conditioning on the controls. These are the cases which
    are providing all the information about your inferences.

-   Use either a principled model selection method with regularization, and/or the OVB tests

-   Use a placebo test if possible

-   Use heteroskedasticity consistent (robust) standard errors; possible with autocorrelation or clustering adjustment.

-   Take the OLS model "seriously but not literally".
    It is an approximation of the CEF, and under some
    assumptions it is a type of weighted average treatment effect.
    It does not "assume" or "require" that the effect is linear or homogeneous
    (though it works better in those situations).
