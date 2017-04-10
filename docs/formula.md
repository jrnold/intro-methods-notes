
# R's Forumula Syntax

These notes build off of the topics discussed in the chapter [Many Models](http://r4ds.had.co.nz/many-models.html) in *R for Data Science*. It uses the functionals (`map()` function) for iteration, string functions, and list columns in data frames.

## Setup


```r
data("Duncan", package = "car")
library("tidyverse")
library("stringr")
library("broom")
```

## Introduction to Formula Objects

Many R functions, especially those for statistical models such as `lm()`, use a convenient syntax to compactly specify the outcome and predictor variables.
This format is described in more detail in the [stats](https://www.rdocumentation.org/packages/stats/topics/formula).
Formula objects in R are created with the tilde operator (`~`), and can be either one- or two-sided.
```
prestige ~ type + income * education
~ prestige + type + income 
```
Formula are used in a variety of different contexts in R, e.g. [ggplot2](https://www.rdocumentation.org/packages/ggplot2/topics/facet_grid), but are commonly associated with statistical modeling functions as a compact way to specify the outcome and design matrix.



```r
lm(formula = prestige ~ type + income * education, data = Duncan)
```
estimates this,
$$
\mathtt{prestige} = \beta_0 + \beta_1 \mathtt{income} + \beta_2 \mathtt{education} + \beta_3 \mathtt{income} \times \mathtt{education} .
$$
Note that in a formula, the operators `+` and `*` do not refer to addition or multiplication.
Instead adding `+` adds terms to the regression, and `*` creates interactions.

Symbol   Example              Meaning
-------- -------------------- --------------------------------------------------------------------
`+`       `+x`                Include $x$
`-`       `-x`                Exclude $x$
`:`       `x : z`             Include $x z$ as a predictor
`*`       `x * z`             Include $x$, $z$, and their interaction $x z$ as predictors
`^`       `(x + w + z) ^ 3`   Include variables and interactions up to three way: $x$, $z$, $w$, $xz$, $xw$, $zw$, $xzw$.
`I`       `I(x ^ 2)`          as is: include a new variable with $x ^ 2$.
`1`       `-1`                Intercept; Use `-1` to delete, and `+1` to include

Formula                          Equation
-------------------------------- ---------------------------------------------
`y ~ x + y + z`                  $y = \beta_0 + beta_1 x + beta_2 y + beta_3 z$
`y ~ x + y - 1`                  $y = \beta_1 x + \beta_2 y$
`y ~ 1`                          $y = \beta_0$
`y ~ x:z`                        $y = \beta_0 + \beta_1 xz$
`y ~ x*z`                        $y = \beta_0 + \beta_1 x + \beta_2 z + \beta_3 xz$
`y ~ x*z - x`                    $y = \beta_0 + \beta_1 z + \beta_2 xz$
`y ~ (x + z)^2`                  $y = \beta_0 + \beta_1 x + \beta_2 z + \beta_3$
`y ~ (x + z + w)^2`              $y = \beta_0 + \beta_1 x + \beta_2 z + \beta_3 w + \beta_4 w + \beta_5 xz + \beta_6 xw + \beta_7 zw$
`y ~ (x + z + w)^2`              $y = \beta_0 + \beta_1 x + \beta_2 z + \beta_3 w + \beta_4 w + \beta_5 xz + \beta_6 xw + \beta_7 zw + \beta_8 xzw$
`y ~ x + I(x ^ 2)`               $y = \beta_0 + \beta_1 x + \beta_2 x^2$
`y ~ poly(x, 2)`                 $y = \beta_0 + \beta_1 x + \beta_2 x^2$
`y ~ I(x * z)`                   $y = \beta_0 + \beta_1 xz$
`y ~ I(x + z) + I(x - z)`        $y = \beta_0 + \beta_1 (x + z) + \beta_2 (x - z)$
`y ~ log(x)`                     $y = \beta_0 + \beta_1 \log(x)$
`y ~ x / z`                      $y = \beta_0 + \beta_1 (x / z)$
`y ~ x + 0`                      $y = \beta_1 x$

Formula objects provide a convenient means of specifying the statistical model and also generating temporary variables that we only needed in the model.
For example, if we want to include $\log(x)$, $z$, their interaction, and the square of $z$, we could write `y ~ log(x) * y + I(y ^ 2)` instead of of having to create new columns with the log, square, and interaction variables before running the regression. 
This becomes especially useful if you need to include large polynomials, splines, interaction, or similarly complicated functional forms.

**Warning:** Often you will want to include polynomials in a regression. 
However, `^` already has a special meaning in R's syntax, so you cannot use `x ^ 2`. 
There are two ways to specify polynomials.
- Use the as is operator, `I()`. For example, `I(x ^ 2)` includes $x^2$ in the regression.
- Use the `poly` function to generate polynomials. For example, `I(x ^ 2)` will include $x$ and $x^2$ in the regression. This can be more convenient and clear than writing `x + I(x ^ 2)`$.

**Warning:** R's `formula` syntax is flexible and includes more features than what was covered in this section. What was described in this section were features that `lm()` uses. Other functions may have more features or the parts will have different meanings. However, they will be mostly be similar to what was described here. An example of a function that has slightly different syntax for its formula is [lme4](https://www.rdocumentation.org/packages/lme4/topics/lmer) which adds notation for random and fixed effects. Some functions like [stats](https://www.rdocumentation.org/packages/stats/topics/xtabs) use a formula syntax even though they aren't statistical modeling functions. The package **[Formula](https://cran.r-project.org/package=Formula)** provides an even more powerful Formula syntax than that included with base R. If you have to write a function or package that uses a formula, use that package.

Inspired by this [handout](http://faculty.chicagobooth.edu/richard.hahn/teaching/formulanotation.pdf) from Richard Hahn and the [handout](http://science.nature.nps.gov/im/datamgmt/statistics/r/formulas/) form the NPS.


## Programming with Formulas

In these examples, we'll use the [car](https://www.rdocumentation.org/packages/car/topics/Prestige) dataset in the 
**[car](https://cran.r-project.org/package=car)** package.

```r
Prestige <- car::Prestige
```
Each observation is an occupation, and contains the prestige score of the 
occupation from a survey, and the average education, income, percentage of women, and type of occupation. 

```r
glimpse(Prestige)
```

```
## Observations: 102
## Variables: 6
## $ education <dbl> 13.11, 12.26, 12.77, 11.42, 14.62, 15.64, 15.09, 15....
## $ income    <int> 12351, 25879, 9271, 8865, 8403, 11030, 8258, 14163, ...
## $ women     <dbl> 11.16, 4.02, 15.70, 9.11, 11.68, 5.13, 25.65, 2.69, ...
## $ prestige  <dbl> 68.8, 69.1, 63.4, 56.8, 73.5, 77.6, 72.6, 78.1, 73.1...
## $ census    <int> 1113, 1130, 1171, 1175, 2111, 2113, 2133, 2141, 2143...
## $ type      <fctr> prof, prof, prof, prof, prof, prof, prof, prof, pro...
```
We will run several regressions with prestige as the outcome variable,
and the over variables are explanatory variables.

In R, the formulas are objects (of class `"formula"`).
That means we can program on them, and importantly, perhaps avoid excessive
copying and pasting if we run multiple models.

A formula object is created with the `~` operator:

```r
f <- prestige ~ type + education
class(f)
```

```
## [1] "formula"
```

```r
f
```

```
## prestige ~ type + education
```

A useful function for working with formulas is [update](https://www.rdocumentation.org/packages/stats/topics/update.formula).
The `update` function allows you to easily update a formula object

```r
# the . is replaced by the original formula values
update(f, . ~ income)
```

```
## prestige ~ income
```

```r
update(f, income ~ .)
```

```
## income ~ type + education
```

```r
update(f, . ~ . + type + women)
```

```
## prestige ~ type + education + women
```
Also note that many types of models have `update` method which will rerun the model with a new formula.
Sometimes this can help computational time if the model is able to reuse some previous results or data.

You can also create formula objects from a character vector

```r
as.formula("prestige ~ income + education")
```

```
## prestige ~ income + education
```

This means that you can create model formula objects programmatically
which is useful if you are running many models, or simply to keep
the logic of your code clear.

```r
xvars <- c("type", "income", "education")
as.formula(str_c("prestige", "~", str_c(xvars, collapse = " + ")))
```

```
## prestige ~ type + income + education
```

Often you will need to run multiple models.
Since most often the only thing that changes between models is the
formula (the outcome or response variables), storing the formula
in a list, and then running the models by iterating through the list
is a clean strategy for estimating your models.

```r
xvar_list <- list(c("type"),
                  c("income"),
                  c("education"),
                  c("type", "income"),
                  c("type", "income", "education"))
formulae <- vector("list", length(xvar_list))
for (i in seq_along(xvar_list)) {
  formulae[[i]] <- str_c("prestige ~ ",
                         str_c(xvar_list[[i]], collapse = " + "))
}
formulae
```

```
## [[1]]
## [1] "prestige ~ type"
## 
## [[2]]
## [1] "prestige ~ income"
## 
## [[3]]
## [1] "prestige ~ education"
## 
## [[4]]
## [1] "prestige ~ type + income"
## 
## [[5]]
## [1] "prestige ~ type + income + education"
```

Alternatively, create this list of formula objects with a functional,

```r
make_mod_f <- function(x) {
  str_c("prestige ~ ", str_c(x, collapse = " + "))  
}
formulae <- map(xvar_list, make_mod_f)
```

Now that we have a list with formula objects for each model that we want to run, we can loop over the list and run each model.
But first, we need to create a function that runs a single model that returns a data frame with a
single row and a column named `mod`, which is a list column with an `lm` object containing the fitted model.
In this function, I set `model = FALSE` because by default an `lm` model stores the data used to estimate.
This is convenient, but if you are estimating many models, this can consume much memory.

```r
run_reg <- function(f) {
  mod <- lm(f, data = Prestige, model = FALSE)
  data_frame(mod = list(mod))
}

ret <- run_reg(formulae[[1]])
ret[["mod"]][[1]]
```

```
## 
## Call:
## lm(formula = f, data = Prestige, model = FALSE)
## 
## Coefficients:
## (Intercept)     typeprof       typewc  
##      35.527       32.321        6.716
```

Since each data frame has only one row, it is not particularly useful on its own, but it will be convenient 
to keep all the models in a data frame.

Now, run `run_reg` for each formula in `formulae` using `map_df` to return 
the results as a data frame with a list column, `mod`, containing the `lm` objects.

```r
prestige_fits <- map_df(formulae, run_reg, .id = ".id")
prestige_fits
```

```
## # A tibble: 5 × 2
##     .id      mod
##   <chr>   <list>
## 1     1 <S3: lm>
## 2     2 <S3: lm>
## 3     3 <S3: lm>
## 4     4 <S3: lm>
## 5     5 <S3: lm>
```

To extract the original formulas and add them to the data set,
run `formula()` on each `lm` object using `map`, and then convert
it to a character string using `deparse`:

```r
prestige_fits <- prestige_fits %>%
  mutate(formula = map_chr(mod, ~ deparse(formula(.x))))
prestige_fits$formula
```

```
## [1] "prestige ~ type"                     
## [2] "prestige ~ income"                   
## [3] "prestige ~ education"                
## [4] "prestige ~ type + income"            
## [5] "prestige ~ type + income + education"
```

Get a data frame of the coefficients for all models using `tidy` and [tidyr](https://www.rdocumentation.org/packages/tidyr/topics/unnest):

```r
mutate(prestige_fits, x = map(mod, tidy)) %>% 
  unnest(x)
```

```
## # A tibble: 16 × 7
##      .id                              formula        term      estimate
##    <chr>                                <chr>       <chr>         <dbl>
## 1      1                      prestige ~ type (Intercept)  35.527272727
## 2      1                      prestige ~ type    typeprof  32.321114370
## 3      1                      prestige ~ type      typewc   6.716205534
## 4      2                    prestige ~ income (Intercept)  27.141176368
## 5      2                    prestige ~ income      income   0.002896799
## 6      3                 prestige ~ education (Intercept) -10.731981968
## 7      3                 prestige ~ education   education   5.360877731
## 8      4             prestige ~ type + income (Intercept)  27.997056941
## 9      4             prestige ~ type + income    typeprof  25.055473883
## 10     4             prestige ~ type + income      typewc   7.167155112
## 11     4             prestige ~ type + income      income   0.001401196
## 12     5 prestige ~ type + income + education (Intercept)  -0.622929165
## 13     5 prestige ~ type + income + education    typeprof   6.038970651
## 14     5 prestige ~ type + income + education      typewc  -2.737230718
## 15     5 prestige ~ type + income + education      income   0.001013193
## 16     5 prestige ~ type + income + education   education   3.673166052
## # ... with 3 more variables: std.error <dbl>, statistic <dbl>,
## #   p.value <dbl>
```

Get a data frame of model summary statistics for all models using `glance`,

```r
mutate(prestige_fits, x = map(mod, glance)) %>%
  unnest(x)
```

```
## # A tibble: 5 × 14
##     .id      mod                              formula r.squared
##   <chr>   <list>                                <chr>     <dbl>
## 1     1 <S3: lm>                      prestige ~ type 0.6976287
## 2     2 <S3: lm>                    prestige ~ income 0.5110901
## 3     3 <S3: lm>                 prestige ~ education 0.7228007
## 4     4 <S3: lm>             prestige ~ type + income 0.7764569
## 5     5 <S3: lm> prestige ~ type + income + education 0.8348574
## # ... with 10 more variables: adj.r.squared <dbl>, sigma <dbl>,
## #   statistic <dbl>, p.value <dbl>, df <int>, logLik <dbl>, AIC <dbl>,
## #   BIC <dbl>, deviance <dbl>, df.residual <int>
```

