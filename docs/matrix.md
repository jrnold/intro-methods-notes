
# OLS in Matrix Form

## Setup {-}

This will use the `Duncan` data in a few examples.

```r
library("tidyverse")
data("Duncan", package = "carData")
```

## Purpose

We can write regression model as,
$$
y_i = \beta_0 + x_{i1} \beta_1 + x_{i2} \beta_2 + \cdots + x_{ik} \beta_k + u_k .
$$
It will be cleaner to write the linear regression as
$$
y_i = \Vec{x}_{i} \Vec{\beta} + u_i
$$
where $\Vec{x}_i$ is a $1 \times (K + 1)$ row vector and $\Vec{\beta}$  is a $(K + 1) \times 1$ column vector for a single observation $i$.

Or we can write it as,
$$
\Vec{y} = \Mat{X} \Vec{\beta} + \Vec{u}
$$
where  $\Vec{y}$ is a $N \times 1$ row vector, $\Mat{X}$ is a $N \times (K + 1)$ matrix,  and $\Vec{\beta}$ is a $(K + 1) \times 1$ column vector for all $N$ observations.

## Matrix Algebra Review

### Vectors

-   A *vector* is a list of numbers or random variables.

-   A $1 \times k$ *row vector* is arranged
    $$
    \Vec{b} = \begin{bmatrix} b_1 & b_2 & b_3 & \dots & b_k \end{bmatrix}
    $$

-   A $1 \times k$ *column vector* is arranged
    $$
    \Vec{a} = \begin{bmatrix} b_1 \\ b_2 \\ b_3\\ \dots \\ b_k \end{bmatrix}
    $$

-   Convention: assume vectors are *column* vectors

-   Convention: use lower-case **bold** Latin letters, e.g. $\Vec{x}$.

Vector Examples

-   Vector of all covariates for a particular unit $i$ as a row vector,
    $$
    \Vec{x}_{i} = \begin{bmatrix}
    x_{i1} & x_{i2} & \dots & x_{ik}
    \end{bmatrix}
    $$

    E.g. in the Duncan data,
    $$
    \Vec{x}_{i} = \begin{bmatrix}
    \mathtt{education}_{i} & \mathtt{income}_{i} & \mathtt{type}_i
    \end{bmatrix}
    $$

-   Vector of the values of covariate $k$ for all observations,
    $$
    x_{.,k} = \begin{bmatrix}
    1 \\ x_{i1} \\ x_{i2} \\ \dots \\ x_{ik}
    \end{bmatrix}
    $$    

    E.g. For the `education` variable in the column vector.
    $$
    \Vec{x}_{i} = \begin{bmatrix}
    \mathtt{education}_{1} \\ \mathtt{education}_{2} \\ \dots & \vdots & \mathtt{education}_N
    \end{bmatrix}
    $$

### Matrices

-   A **matrix** is a rectangular array of numbers

-   A matrix is $n \times k$ ("$n$ by $k$") if it has $n$ rows and $k$ columns

-   A matrix
    $$
    A = \begin{bmatrix}
    a_{11} & a_{12} & \dots & a_{1k} \\
    a_{21} & a_{22} & \dots & a_{2k} \\
    \vdots & \vdots & \ddots & \vdots \\
    a_{n1} & a_{n2} & \dots & a_{nk}
    \end{bmatrix}
    $$

#### Examples

The **design matrix** is the matrix of predictors/covariates in a regression:
$$
    X = \begin{bmatrix}
    1 & x_{11} & x_{12} & \dots & a_{1k} \\
    1 & x_{21} & x_{22} & \dots & a_{2k} \\
    \vdots & \vdots & \vdots & \ddots & \vdots \\
    1 & x_{n1} & a_{n2} & \dots & a_{nk}
    \end{bmatrix}
$$
The vector of ones is the constant.

In the Duncan data, for the regression
`prestige ~ income + education + type`, the design matrix is,
$$
    X = \begin{bmatrix}
    1 & \mathtt{income}_{1} & \mathtt{education}_{1} & \mathtt{wc}_{1} & \mathtt{prof}_{1} \\
    1 & \mathtt{income}_{2} & \mathtt{education}_{2} & \mathtt{wc}_{2} & \mathtt{prof}_{2} \\
    \vdots & \vdots & \vdots & \vdots & \vdots \\
    1 & \mathtt{income}_{N} & \mathtt{education}_{N} & \mathtt{wc}_{N} & \mathtt{prof}_{N} \\
    \end{bmatrix}
$$

Use R function `model.matrix` to create the design matrix from a formula and a data frame.

```r
model.matrix(prestige ~ income + education + type, data = Duncan)
```

```
##                    (Intercept) income education typeprof typewc
## accountant                   1     62        86        1      0
## pilot                        1     72        76        1      0
## architect                    1     75        92        1      0
## author                       1     55        90        1      0
## chemist                      1     64        86        1      0
## minister                     1     21        84        1      0
## professor                    1     64        93        1      0
## dentist                      1     80       100        1      0
## reporter                     1     67        87        0      1
## engineer                     1     72        86        1      0
## undertaker                   1     42        74        1      0
## lawyer                       1     76        98        1      0
## physician                    1     76        97        1      0
## welfare.worker               1     41        84        1      0
## teacher                      1     48        91        1      0
## conductor                    1     76        34        0      1
## contractor                   1     53        45        1      0
## factory.owner                1     60        56        1      0
## store.manager                1     42        44        1      0
## banker                       1     78        82        1      0
## bookkeeper                   1     29        72        0      1
## mail.carrier                 1     48        55        0      1
## insurance.agent              1     55        71        0      1
## store.clerk                  1     29        50        0      1
## carpenter                    1     21        23        0      0
## electrician                  1     47        39        0      0
## RR.engineer                  1     81        28        0      0
## machinist                    1     36        32        0      0
## auto.repairman               1     22        22        0      0
## plumber                      1     44        25        0      0
## gas.stn.attendant            1     15        29        0      0
## coal.miner                   1      7         7        0      0
## streetcar.motorman           1     42        26        0      0
## taxi.driver                  1      9        19        0      0
## truck.driver                 1     21        15        0      0
## machine.operator             1     21        20        0      0
## barber                       1     16        26        0      0
## bartender                    1     16        28        0      0
## shoe.shiner                  1      9        17        0      0
## cook                         1     14        22        0      0
## soda.clerk                   1     12        30        0      0
## watchman                     1     17        25        0      0
## janitor                      1      7        20        0      0
## policeman                    1     34        47        0      0
## waiter                       1      8        32        0      0
## attr(,"assign")
## [1] 0 1 2 3 3
## attr(,"contrasts")
## attr(,"contrasts")$type
## [1] "contr.treatment"
```

## Matrix Operations

### Transpose

The **transpose** of a matrix $A$ flips the rows and columns. It is denoted $A'$ or $A^{T}$.

The transpose of a $3 \times 2$ matrix is a $2 \times 3$ matrix,
$$
A = \begin{bmatrix}
a_{11} & a_{12} \\
a_{21} & a_{22} \\
a_{31} & a_{32}
\end{bmatrix}  =
\begin{bmatrix}
a_{11} & a_{21}  & a_{31} \\
a_{12} & a_{22}  & a_{32}
\end{bmatrix}
$$

Transposing turns a $1 \times k$ row vector into a $k \times 1$ column vector and vice-versa.

$$
\begin{aligned}[t]
x_i &=
\begin{bmatrix}
1 \\
x_{i1} \\
x_{i2} \\
\vdots \\
x_{ik}
\end{bmatrix} \\
x_i' &=
\begin{bmatrix}
1 &
x_{i1} &
x_{i2} &
\dots &
x_{ik}
\end{bmatrix}
\end{aligned}
$$


```r
A <- matrix(1:6, ncol = 3, nrow = 2)
A
```

```
##      [,1] [,2] [,3]
## [1,]    1    3    5
## [2,]    2    4    6
```

```r
t(A)
```

```
##      [,1] [,2]
## [1,]    1    2
## [2,]    3    4
## [3,]    5    6
```

```r
a <- 1:6
t(a)
```

```
##      [,1] [,2] [,3] [,4] [,5] [,6]
## [1,]    1    2    3    4    5    6
```

## Matrices as vectors

A matrix is a collection of row (or column) vectors.

Write the matrix as a collection of row vectors
$$
A = \begin{bmatrix}
a_{11} & a_{12} & a_{13} \\
a_{21} & a_{22} & a_{23}
\end{bmatrix} =
\begin{bmatrix}
\Vec{a}_1' \\
\Vec{a}_2'
\end{bmatrix}
$$
$$
B = \begin{bmatrix}
b_{11} & b_{12} \\
b_{21} & b_{22} \\
b_{31} & b_{32}
\end{bmatrix} =
\begin{bmatrix}
\Vec{b}_1 \\
\Vec{b}_2
\Vec{b}_3
\end{bmatrix}
$$

How does $X$ relate to the model specification?
See the `model.matrix`


```r
model.matrix(prestige ~ education * income + type, data = Duncan) %>%
  head()
```

```
##            (Intercept) education income typeprof typewc education:income
## accountant           1        86     62        1      0             5332
## pilot                1        76     72        1      0             5472
## architect            1        92     75        1      0             6900
## author               1        90     55        1      0             4950
## chemist              1        86     64        1      0             5504
## minister             1        84     21        1      0             1764
```

The OLS estimator of coefficients is
$$
\hat{\beta} = \underbrace{(X' X)^{-1}}_{Var(X)} \underbrace{X' y}_{Cov(X, Y)}
$$

## Special matrices

A **square matrix** has equal numbers of rows and columns

The **identity matrix**, $\Mat{I}_K$ is a $K \times K$ square matrix with 1s on the diagonal, and 0s everywhere else.
$$
\Mat{I}_3 = \begin{bmatrix}
1 & 0 & 0 \\
0 & 1 & 0 \\
0 & 0 & 1
\end{bmatrix}
$$

The identity matrix multiplied by any matrix returns the matrix,
$$
\Mat{A} \Mat{I}_{K} = \Mat{A} = \Mat{I}_{M} \Mat{A}
$$
where $\Mat{A}$ is an $M \times K$ matrix.

In R, to get the diagonal of a matrix use `diag()`,

```r
b <- diag(1:4, nrow = 2L, ncol = 2L)
b <-
diag(b)
```
The function `diag()` also creates identity matrices,

```r
diag(3L)
```

```
##      [,1] [,2] [,3]
## [1,]    1    0    0
## [2,]    0    1    0
## [3,]    0    0    1
```

The **zero matrix** is a matrix of all zeros,
$$
\Mat{0}_K =
\begin{bmatrix}
0 & 0 & \dots 0 \\
0 & 0 & \dots 0 \\
\vdots & \vdots & \ddots & vdots \\
0 & 0 & \dots & 0
\end{bmatrix}
$$
The *zero vector* is a matrix of all zeros,
$$
\Mat{0}_K =
\begin{bmatrix}
0 \\ 0 \\ \vdots \\ 0
\end{bmatrix}
$$
The **ones vector** is a vector of all ones,
$$
\Mat{0}_K =
\begin{bmatrix}
1 \\ 1 \\ \vdots \\ 1
\end{bmatrix}
$$

## Multiple linear regression in matrix form

Let $\widehat{\Vec{\beta}}$ be the matrix of estimated regression coefficients, and $\hat{\Vec{y}}$ be the vector of fitted values:
$$
\begin{aligned}[t]
\widehat{\Vec{\beta}} &=
\begin{bmatrix}
\widehat{\beta}_0 \\
\widehat{\beta}_1 \\
\vdots \\
\widehat{\beta}_K
\end{bmatrix} &
\hat{\Vec{y}} &= \Mat{X} \widehat{\Vec{\beta}}
\end{aligned}
$$
This could be expanded to,
$$
\begin{aligned}[t]
\hat{\Vec{y}} &=
\begin{bmatrix}
\hat{y}_1 \\
\hat{y}_2 \\
\vdots \\
\hat{y}_N
\end{bmatrix}
&= \Mat{X} \widehat{\Vec{\beta}}
&= \begin{aligned}
1\widehat{\beta}_0 + x_{11} \widehat{\beta}_1 + x_{12} \widehat{\beta}_2 + \dots + x_{1K} \widehat{\beta}_K \\
1\widehat{\beta}_0 + x_{21} \widehat{\beta}_1 + x_{22} \widehat{\beta}_2 + \dots + x_{2K} \widehat{\beta}_K \\
\vdots \\
1\widehat{\beta}_0 + x_{N1} \widehat{\beta}_1 + x_{N2} \widehat{\beta}_2 + \dots + x_{NK} \widehat{\beta}_K \\
\end{aligned}
\end{aligned}
$$

## Residuals

The residuals of a regression are,
$$
\Vec{u} = \Vec{y} - \Mat{X} \widehat{\beta}
$$

In two dimensions the Euclidian distance is,
$$
d(a, b) = \sqrt{a^2 + b^2}
$$
Think the hypotenuse of a triangle.

The **norm** or **length** of a vector generalizes the Euclidian distance to multiple dimensions[^norm]

For a $K \times 1$ vector $\Vec{a}$,
$$
| \Vec{a} | = \sqrt{a_1^2 + a_2^2 + \dots + a_K^2}
$$

The **norm** can be written as the **inner product**,
$$
{| \Vec{a} |}^2  = \Vec{a}\T \Vec{a}
$$

Note that when the mean of a vector is 0, the norm is equal to $N$ times the sample variance (using the $N$ denominator)
$$
\begin{aligned}
\Var{\Vec{u}} &= \frac{1}{N} \sum_{i = 1}^N (u_i - \var{u})^2 \\
&= \frac{1}{N} \sum_{i = 1}^N u_i^2 \\
&= \frac{1}{N} \Vec{u}\T \Vec{u} \\
&= \frac{1}{N} {| \Vec{u} |}^2 \\
\end{aligned}
$$

[^norm]: This is technically the 2-norm, as there are other norms.

## Scalar inverses

What is division? You may think of it as the inverse of multiplication (which it is), but it means that for number $a$ there exists another number (the inverse of $a$) denoted $a^{-1}$ or $1 / a$ such that $a \times a^{-1} = 1$.

This inverse does not always exist. There is no inverse for 0: $0 \times ? = 1$ has no solution.

If the inverse exists, we can solve algebraic expressions like $ax = b$ for $x$,
$$
\begin{aligned}
ax &= b \\
\frac{1}{a} ax &= \frac{1}{a} b & \text{multiply both sides by the inverse of \[a\]} \\
x = \frac{b}{a}
\end{aligned}
$$

We'll see in matrix algebra, the intuition is similar.

-   The inverse is a matrix such that when it multiplies a number it results in 1 (or the equivalent)
-   The inverse doesn't always exist
-   The inverse can be used to solve

## Matrix Inverses

If it exists (it does not always), the **inverse** of square matrix $\Mat{A}$, denoted $\Mat{A}^{-1}$, is the matrix such that
$$
\Mat{A}^{-1} \Mat{A} = \Mat{A} \Mat{A}^{-1} = \Mat{I}
$$

The inverse can be used to solve systems of equations (like OLS)
$$
\begin{aligned}[t]
\Mat{A} \Vec{x} &= \Vec{b} \\
\Mat{A}^{-1} \Mat{A} \Vec{x} &= \Mat{A}^{-1} \Vec{b} \\
I \Vec{x} &= \Mat{A}^{-1} \Vec{b} \\
\Vec{x} &= \Mat{A}^{-1} \Vec{b}
\end{aligned}
$$

If the inverse exists, then $\Mat{A}$ is called **invertible** or **nonsingular**.

## OLS Estimator

OLS minimizes the sum of squared residuals
$$
\arg \min
$$

## Implications of OLS

Independent variables are orthogonal to the residuals
$$
\Mat{X}\T \hat{\Vec{u}} = \Mat{X}\T(\Vec{y} - \Mat{X} \widehat{\Vec{\beta}}) = 0
$$
Fitted values are orthogonal to the residuals
$$
\Vec{y}\T \hat{\Vec{u}} =(\Mat{X} \widehat{\Vec{\beta}})\T \hat{\Vec{u}} = \widehat{\Vec{\beta}}\T \Mat{X}\T \hat{\Vec{u}} = 0
$$

### OLS in Matrix Form

$$
Y_i = \beta_0 + \beta_1 x_{i1} + \beta_2 x_{i2} + \dots + \beta_k x_{ik} + \epsilon_i
$$
We can write this as
$$
\begin{aligned}[t]
Y_i &=
\begin{bmatrix}
1 & x_{i1} & x_{i2} & \dots & x_{ik}
\end{bmatrix}
\begin{bmatrix}
\beta_0 \\
\beta_1 \\
\beta_2 \\
\vdots \\
\beta_k
\end{bmatrix} + \epsilon_i \\
&= \underbrace{{x_i'}}_{1 \times k + 1} \underbrace{\beta}_{k + 1 \times 1} + \epsilon_i
\end{aligned}
$$

$$
Y_i = \beta_0 + \beta_1 x_{i1} + \beta_2 x_{i2} + \dots + \beta_k x_{ik} + \epsilon_i
$$
We can write it as
$$
\begin{aligned}[t]
\begin{bmatrix}
Y_1 \\
Y_2 \\
\vdots \\
Y_n
\end{bmatrix}
&=
\begin{bmatrix}
1 & x_{11} & x_{12} & \dots & x_{1k}  \\
1 & x_{21} & x_{22} & \dots & x_{2k}  \\
\vdots & \vdots & \vdots & \ddots & \vdots \\
1 & x_{n1} & x_{n2} & \dots & x_{nk}
\end{bmatrix}
\begin{bmatrix}
\beta_0 \\
\beta_1 \\
\beta_2 \\
\vdots \\
\beta_k
\end{bmatrix} +
\begin{bmatrix}
\epsilon_1 \\
\epsilon_2 \\
\vdots \\
\epsilon_n
\end{bmatrix} \\
\underbrace{y}_{(n \times 1)} &=
\underbrace{{x_i'}}_{(n \times k + 1)} \underbrace{\beta}_{(k + 1 \times 1)} +
\underbrace{\epsilon}_{(n \times 1)}
\end{aligned}
$$

The regression standard error of the regression is
$$
\hat{\sigma}_y^2 = \frac{\sum_i^n \epsilon_i^2}{n - k - 1}
$$
Write this using matrix notation.

Note that
$$
E(X_i)^2 = \frac{\sum X_i^2}{n}
$$
In matrix notation this is,
$$
\begin{bmatrix}
x_1 & x_2 & \dots & x_n
\end{bmatrix}
\begin{bmatrix}
x_1 \\ x_2 \\ \dots \\ x_n
\end{bmatrix} =
x' x
$$
If $\bar{X} = 0$, then
$$
\frac{X' X}{N} = Var(X)
$$

-   What is the vcov matrix of $\beta$?
-   When would it be diagonal?
-   What is on the off-diagonal?
-   What is on the diagonal?
-   Extract the standard errors from it.

OLS Standard errors
$$
\hat{\beta}_{OLS} = (X' X)^{-1} X' y
$$

$$
V(\hat{\beta}) =
\begin{bmatrix}
V(\hat{\beta}_0) & Cov(\hat{\beta}_0, \hat{\beta}_1) & \dots & Cov(\hat{\beta}_0, \hat{\beta}_k) \\
Cov(\hat{\beta}_1, \hat{\beta}_0) & V(\hat{\beta}_1) & \dots & Cov(\hat{\beta}_1, \hat{\beta}_k) \\
\vdots & \vdots & \ddots & \vdots \\
Cov(\hat{\beta}_k, \hat{\beta}_0) & Cov(\hat{\beta}_k, \hat{\beta}_1) & \dots & V(\hat{\beta}_k) \\
\end{bmatrix}
$$

Which of these matrices are

1.  Homoskedastic
1.  Heteroskedastic
1.  Clustered standard errors
1.  Serially correlated

Show how $(X' X)^{-1} X' y$ is equivalent to the bivariate estimator.

1.  Write out $\beta$ and plug in for the true $Y$ in terms of $X$ and $\epsilon$
1.  Take the variance of $\hat{\beta} - \beta$

$$
\hat{\beta} = \beta + (X' X)^{-1} X' \epsilon \\
\Var(\hat{\beta} - \beta) =  var((X' X)^{-1} X' \epsilon) \\
$$
We know that

-   $(X' X)^{-1} X' \epsilon$ has mean zero since $E(X' \epsilon) = 0$.
-   $var(z) = E(Z^2) - 0$
-   In matrix form $Z Z'$ to get full matrix form

$$
V((X' X)^{-1} X' \epsilon) = (X' X)^{-1} X' \epsilon \epsilon' X (X' X)^{-1} = (X' X)^{-1} X' \Sigma X (X' X)^{-1}
$$
We need a way to estimate $\hat{\Sigma}$.
But it has $n (n + 1) / 2$ elements ... and we have only $n$ observations, and $n - k - 1$ degrees of freedom left after estimating the coefficients.

If homoskedasticity, $\Sigma = \sigma^2 I$.
$$
V((X' X)^{-1} X' \epsilon) = \sigma^2 (X' X)^{-1}
$$

Panel of countries. Correlation within each year that is always the same

<!--
## OLS Assumptions

1. Linearity: $y_i = x'_i \beta + u_i$
2. Random/iid sample: $(y_i, x'_i)$ are a iid sample from population
3. No perfect collinearity: $X$ is an $n \times (k + 1)$ matrix with rank $k + 1$
4. Zero conditional mean $E(u_i | x_i) = 0$
5. Homoskedasticity: $V(u_i | x_i) = \sigma_u^2$
6. Normality $u_i | x_i \sim N(0, \sigma_u^2)$

- Unbiasedness: 1--5 in large samples

Gauss-Markov

Suppose  that
$$
y = X \beta + \epsilon
$$
where $y, \epsilon \in R^n$, $\beta \in R^K$ and $X \in R^{n \times K}$.

With the following assumptions on the errors,

- mean zero $E(\epsilon_i | x_i) = 0$
- homoskedastic $Var(\epsilon_i) = \sigma^2 < \infty$
- uncorrelated $Cov(\epsilon_i, \epsilon_j) = 0$ for all $i \neq j$.

Then OLS is BLUE: "best linear unbiased estimator"

-   linear estimator: estimator can be written as a weighted sum of the responses. OLS is a linear estimator since
    $$
    \hat{\beta} = \underbrace{(X' X)^{-1} X'}_{\text{weight}} y
    $$
- unbiased: $E(\hat{\beta} - \beta) = 0$
- best: of all the unbiased linear estimators it has the lowest variance, $V(\beta)$.
-->

## Covariance/variance interpretation of OLS

$$
\Mat{X}\T \Vec{y} = \sum_{i = 1}^N
\begin{bmatrix}
y_i \\
y_i x_{i1} \\
y_i x_{i2}\\
\vdots \\
y_i x_{iK}
\end{bmatrix}
\approx
\begin{bmatrix}
n\bar{y} \\
\widehat{\Cov}[y_i, x_{i1}] \\
\widehat{\Cov}[y_i, x_{i2}] \\
\vdots \\
\widehat{\Cov}[y_i, x_{iK}]
\end{bmatrix}
$$

$$
\begin{aligned}
\Mat{X}\T \Mat{X} &= \sum_{i = 1}^N
\begin{bmatrix}
1 & x_{i1} & x_{i2}& \cdots & x_{ik} \\
x_{i1} & x_{i1}^2 & x_{i2} x_{i1} & \cdots & x_{i1} x_{iK} \\
x_{i2} & x_{i1} x_{i2} & x_{i2}^2 & \cdots & x_{i2} x_{iK} \\
\vdots & \vdots & \vdots & \ddots & \vdots \\
x_{iK} & x_{i1} x_{iK} & x_{i2} x_{iK} & \cdots & x_{ik} x_{iK}
\end{bmatrix}  \\
&\approx
\begin{bmatrix}
n  & n \bar{x}_1 & n \bar{x}_2 & \cdots & n \bar{x}_K \\
n \bar{x}_3 & \widehat{\Var}[x_{i1}] & \widehat{\Cov}[x_{i1}, x_{i2}] & \cdots & n \widehat{Cov}[x_{i1}, x_{iK}] \\
n \bar{x}_3 & \widehat{\Cov}[x_{i1}, x_{i2}] & \widehat{\Var}[x_{i2}] & \cdots & n \widehat{\Cov}[x_{i2}, x_{iK}] \\
\vdots \\
n \bar{x}_K & \widehat{\Cov}[x_{iK}, x_{i1}] & \widehat{\Cov}[x_{iK}, x_{i2}] & \cdots & n \widehat{\Var}[x_{iK}]
\end{bmatrix}
\end{aligned}
$$
