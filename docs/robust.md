
# Robust Regression

Consider a more general formulation of linear regression estimation,
$$
\hat{\vec{\beta}} = \argmin_{b} \sum_i f(y_i - \vec{x}_i\T \vec{b}) = \argmin_{b} \sum_i f(\hat{\epsilon}_i)
$$
where $f$ is some function of the errors to be minimized.
OLS minimizes the squared errors,
$$
f(\hat{\epsilon}_i) = \hat{\epsilon}_i^2
$$
However, other objective functions could be used.
Some of these are less influenced by outliers, and these are called robust or resistent methods (these are slightly different properties of the estimator).
One example is least median squares, which minimizes the absolute 
$$
f(\hat{\epsilon}_i) = |\hat{\epsilon}|
$$


## Prerequites

Many forms of robust regression are available through the **MASS* library:

```r
library("MASS")
library("tidyverse")
library("modelr")
```


## Examples

Methods of dealing with outliers include [robust](https://en.wikipedia.org/wiki/Robust_regression) and resistant regression methods.
These methods will weigh observations far from the regression line less, which makes them less influential on the regression line.

The functions `lqs` (least quantile squares) and `rls` (robust least squares) in **[MASS](https://cran.r-project.org/package=MASS)** implement several roubst and resistant methods.

These include least median squares:

```r
models <- list()
models[["lms"]] <- lqs(prestige ~ type + income + education, data = car::Duncan, method = "lms")
models[["lms"]]
```

```
## Call:
## lqs.formula(formula = prestige ~ type + income + education, data = car::Duncan, 
##     method = "lms")
## 
## Coefficients:
## (Intercept)     typeprof       typewc       income    education  
##     -3.8565      -3.2120     -27.2139       0.7298       0.4953  
## 
## Scale estimates 4.678 6.263
```
least trimmed squares,

```r
models[["lqs"]] <- lqs(prestige ~ type + income + education, data = car::Duncan, method = "lts")
models[["lqs"]]
```

```
## Call:
## lqs.formula(formula = prestige ~ type + income + education, data = car::Duncan, 
##     method = "lts")
## 
## Coefficients:
## (Intercept)     typeprof       typewc       income    education  
##     -8.4158      -0.2083     -22.8542       0.7292       0.5000  
## 
## Scale estimates 6.20 6.78
```
M-method with Huber weighting,

```r
models[["m_huber"]] <- rlm(prestige ~ type + income + education, data = car::Duncan,
                         method = "M", scale.est = "Huber")
models[["m_huber"]]
```

```
## Call:
## rlm(formula = prestige ~ type + income + education, data = car::Duncan, 
##     scale.est = "Huber", method = "M")
## Converged in 8 iterations
## 
## Coefficients:
## (Intercept)    typeprof      typewc      income   education 
##  -1.2114545  15.8670992 -14.7744856   0.6663791   0.3024461 
## 
## Degrees of freedom: 45 total; 40 residual
## Scale estimate: 9.03
```
MM-methods with Huber weighting,

```r
models[["mm_huber"]] <- rlm(prestige ~ type + income + education, data = car::Duncan, method = "MM", scale.est = "Huber")
models[["mm_huber"]]
```

```
## Call:
## rlm(formula = prestige ~ type + income + education, data = car::Duncan, 
##     scale.est = "Huber", method = "MM")
## Converged in 7 iterations
## 
## Coefficients:
## (Intercept)    typeprof      typewc      income   education 
##  -2.0191196  14.3261207 -15.6664693   0.7196171   0.2803928 
## 
## Degrees of freedom: 45 total; 40 residual
## Scale estimate: 8.21
```

## Notes

- See the @Fox2016a chapter on Robust Regression
- See @Western1995a for discussion of robust regression in the context of political science
- See the **MASS** package for implementations of many of these methods.
