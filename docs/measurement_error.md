
## Measurement Error

### What's the problem?

It biases coefficients. The way in which it biases coefficients depends on which  variables have measurement error.

1. Variable with measurement error: biases $\beta$ towards zero (**attenuation bias**)
2. Other variables: Biases $\beta$ similarly to omitted variable bias. In other words, when a variable has measurement error it is an imperfect control. You can think of omitted variables as the limit of the effect of measurement error as it increases.


### What to do about it?

There's no easy fix within the OLS framework.

1. If the measurement error is in the variable of interest, then the variable will be biased towards zero, and your estimate is too large.
2. Find better measures with lower measurement errors. If the variable is the variable of interest, then perhaps combine multiple variables into a single index. If the measurement error is in the control variables, then include several measures. That these measure correlate closely increases their standard errors, but the control variables are not the object of the inferential analysis.
3. More complicated methods: errors in variable models, structural equation models, instrumental variable (IV) models, and Bayesian methods.
