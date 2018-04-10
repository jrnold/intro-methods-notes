
# Formatting Tables

## Overview of Packages

R has multiple packages and functions for directly producing formatted tables
for LaTeX, HTML, and other output formats.
Given the 

See the [Reproducible Research Task View](https://cran.r-project.org/web/views/ReproducibleResearch.html) for an overview of various options.

- **[xtable](https://cran.r-project.org/package=xtable)** is a general purpose package for creating LaTeX, HTML, or plain text tables in R.
- **[texreg](https://cran.r-project.org/package=texreg)** is more specifically geared to regression tables. It also outputs results in LaTeX ([texreg](https://www.rdocumentation.org/packages/texreg/topics/texreg)),
HTML ([texreg](https://www.rdocumentation.org/packages/texreg/topics/htmlreg)), and plain text.

The packages **[stargazer](https://cran.r-project.org/package=stargazer)** and **[apsrtable](https://cran.r-project.org/package=apsrtable)** are other popular packages for formatting regression output.
However, they are less-well maintained and have less functionality than **texreg**. For example, **apsrtable** hasn't been updated since 2012, **stargazer** since 2015.

The [texreg vignette](https://cran.r-project.org/web/packages/texreg/vignettes/texreg.pdf) is a good introduction to **texreg**, and also discusses the 
These [blog](http://conjugateprior.org/2013/10/call-them-what-you-will/) [posts](http://conjugateprior.org/2013/03/r-to-latex-packages-coverage/) by Will Lowe cover many of the options.

Additionally, for simple tables, **[knitr](https://cran.r-project.org/package=knitr)**, the package which provides the heavy lifting for R markdown, has a function [knitr](https://www.rdocumentation.org/packages/knitr/topics/kable).
**knitr** also has the ability to customize how R objects are printed with the [knit_print](https://cran.rstudio.com/web/packages/knitr/vignettes/knit_print.html) function.

Other notable packages are:

- **[pander](https://cran.r-project.org/package=pander)** creates output in markdown for export to other formats.
- **[tables](https://cran.r-project.org/package=tables)** uses a formula syntax to define tables
- **[ReportR](https://cran.r-project.org/package=ReportR)** has the most complete support for creating Word documents, but is likely too much.


For a political science perspective on why automating the research process is important see:

- Nicholas Eubank [Embrace Your Fallibility: Thoughts on Code Integrity](https://thepoliticalmethodologist.com/2016/06/06/embrace-your-fallibility-thoughts-on-code-integrity/), based on this [article](https://doi.org/10.1017/S1049096516000196)
- Matthew Gentzkow Jesse M. Shapiro.[Code and Data for the Social Sciences:
A Practitioner’s Guide](http://web.stanford.edu/~gentzkow/research/CodeAndData.pdf). March 10, 2014.
- Political Methodologist issue on [Workflow Management](http://www.jakebowers.org/PAPERS/tpm_v18_n2.pdf)

## Summary Statistic Table Example

The `xtable` package has methods to convert many types of R objects to tables.


```r
library("gapminder")

gapminder_summary <-
  gapminder %>%
  # Keep numeric variables
  select_if(is.numeric) %>%
  # gather variables
  gather(variable, value) %>%
  # Summarize by variable
  group_by(variable) %>%
  # summarise all columns
  summarise(n = sum(!is.na(value)),
            `Mean` = mean(value),
            `Std. Dev.` = sd(value),
            `Median` = median(value),
            `Min.` = min(value),
            `Max.` = max(value))
gapminder_summary
```

```
## # A tibble: 4 × 7
##    variable     n         Mean  `Std. Dev.`       Median       Min.
##       <chr> <int>        <dbl>        <dbl>        <dbl>      <dbl>
## 1 gdpPercap  1704 7.215327e+03 9.857455e+03    3531.8470   241.1659
## 2   lifeExp  1704 5.947444e+01 1.291711e+01      60.7125    23.5990
## 3       pop  1704 2.960121e+07 1.061579e+08 7023595.5000 60011.0000
## 4      year  1704 1.979500e+03 1.726533e+01    1979.5000  1952.0000
## # ... with 1 more variables: Max. <dbl>
```

Now that we have a data frame with the table we want, use `xtable` to create
it:

```r
library("xtable")
foo <- xtable(gapminder_summary, digits = 0) %>%
  print(type = "html",
        html.table.attributes = "",
        include.rownames = FALSE,
        format.args = list(big.mark = ","))
```

<!-- html table generated in R 3.3.3 by xtable 1.8-2 package -->
<!-- Fri Apr 14 19:34:10 2017 -->
<table >
<tr> <th> variable </th> <th> n </th> <th> Mean </th> <th> Std. Dev. </th> <th> Median </th> <th> Min. </th> <th> Max. </th>  </tr>
  <tr> <td> gdpPercap </td> <td align="right"> 1,704 </td> <td align="right"> 7,215 </td> <td align="right"> 9,857 </td> <td align="right"> 3,532 </td> <td align="right"> 241 </td> <td align="right"> 113,523 </td> </tr>
  <tr> <td> lifeExp </td> <td align="right"> 1,704 </td> <td align="right"> 59 </td> <td align="right"> 13 </td> <td align="right"> 61 </td> <td align="right"> 24 </td> <td align="right"> 83 </td> </tr>
  <tr> <td> pop </td> <td align="right"> 1,704 </td> <td align="right"> 29,601,212 </td> <td align="right"> 106,157,897 </td> <td align="right"> 7,023,596 </td> <td align="right"> 60,011 </td> <td align="right"> 1,318,683,096 </td> </tr>
  <tr> <td> year </td> <td align="right"> 1,704 </td> <td align="right"> 1,980 </td> <td align="right"> 17 </td> <td align="right"> 1,980 </td> <td align="right"> 1,952 </td> <td align="right"> 2,007 </td> </tr>
   </table>
Note that there we two functions to get HTML. The function `xtable` creates
an `xtable` R object, and the function [xtable](https://www.rdocumentation.org/packages/xtable/topics/print.xtable) (called as `print()`), which prints the `xtable` object as HTML (or LaTeX).
The default HTML does not look nice, and would need to be formatted with CSS.
If you are copy and pasting it into Word, you would do some post-processing cleanup anyways.

Another alternative is the [knitr](https://www.rdocumentation.org/packages/knitr/topics/kable) function in the **[knitr](https://cran.r-project.org/package=knitr)** package, which outputs R markdown tables.

```r
knitr::kable(gapminder_summary)
```



variable        n           Mean      Std. Dev.         Median         Min.           Max.
----------  -----  -------------  -------------  -------------  -----------  -------------
gdpPercap    1704   7.215327e+03   9.857455e+03      3531.8470     241.1659   1.135231e+05
lifeExp      1704   5.947444e+01   1.291711e+01        60.7125      23.5990   8.260300e+01
pop          1704   2.960121e+07   1.061579e+08   7023595.5000   60011.0000   1.318683e+09
year         1704   1.979500e+03   1.726533e+01      1979.5000    1952.0000   2.007000e+03

This is useful for producing quick tables.

Finally, [htmlTables](https://cran.r-project.org/web/packages/htmlTable/vignettes/tables.html) package unsurprisingly produces HTML tables.

```r
library("htmlTable")
htmlTable(txtRound(gapminder_summary, 0),
          align = "lrrrr")
```

<!--html_preserve--><table class='gmisc_table' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey;'> </th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>variable</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>n</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Std. Dev.</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Median</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Min.</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Max.</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: left;'>1</td>
<td style='text-align: left;'>gdpPercap</td>
<td style='text-align: right;'>1704</td>
<td style='text-align: right;'>7</td>
<td style='text-align: right;'>10</td>
<td style='text-align: right;'>3532</td>
<td style='text-align: right;'>241</td>
<td style='text-align: right;'>1</td>
</tr>
<tr>
<td style='text-align: left;'>2</td>
<td style='text-align: left;'>lifeExp</td>
<td style='text-align: right;'>1704</td>
<td style='text-align: right;'>6</td>
<td style='text-align: right;'>1</td>
<td style='text-align: right;'>61</td>
<td style='text-align: right;'>24</td>
<td style='text-align: right;'>8</td>
</tr>
<tr>
<td style='text-align: left;'>3</td>
<td style='text-align: left;'>pop</td>
<td style='text-align: right;'>1704</td>
<td style='text-align: right;'>3</td>
<td style='text-align: right;'>1</td>
<td style='text-align: right;'>7023596</td>
<td style='text-align: right;'>60011</td>
<td style='text-align: right;'>1</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: left;'>4</td>
<td style='border-bottom: 2px solid grey; text-align: left;'>year</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>1704</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>2</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>2</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>1980</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>1952</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>2</td>
</tr>
</tbody>
</table><!--/html_preserve-->
It has more features for producing HTML tables than `xtable`, but does not output LaTeX.

## Regression Table Example


```r
library("tidyverse")
library("texreg")
```

We will run several regression models with the Duncan data


```r
Prestige <- car::Prestige
```

Since I'm running several regressions, I will save them to a list.
If you know that you will be creating multiple objects, and programming with them, always put them in a list.

First, create a list of the regression formulas,

```r
formulae <- list(
  prestige ~ type,
  prestige ~ income,
  prestige ~ education,
  prestige ~ type + education + income
)
```
Write a function to run a single model,
Now use `map` to run a regression with each of these formulae, 
and save them to a list,

```r
prestige_mods <- map(formulae, ~ lm(.x, data = Prestige, model = FALSE))
```
This is a list of `lm` objects,

```r
map(prestige_mods, class)
```

```
## [[1]]
## [1] "lm"
## 
## [[2]]
## [1] "lm"
## 
## [[3]]
## [1] "lm"
## 
## [[4]]
## [1] "lm"
```
We can look at the first model,

```r
prestige_mods[[1]]
```

```
## 
## Call:
## lm(formula = .x, data = Prestige, model = FALSE)
## 
## Coefficients:
## (Intercept)     typeprof       typewc  
##      35.527       32.321        6.716
```

Now we can format the regression table in HTML using `htmlreg`.
The first argument of `htmlreg` is a list of models:

```r
htmlreg(prestige_mods)
```


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<table cellspacing="0" align="center" style="border: none;">
<caption align="bottom" style="margin-top:0.3em;">Statistical models</caption>
<tr>
<th style="text-align: left; border-top: 2px solid black; border-bottom: 1px solid black; padding-right: 12px;"><b></b></th>
<th style="text-align: left; border-top: 2px solid black; border-bottom: 1px solid black; padding-right: 12px;"><b>Model 1</b></th>
<th style="text-align: left; border-top: 2px solid black; border-bottom: 1px solid black; padding-right: 12px;"><b>Model 2</b></th>
<th style="text-align: left; border-top: 2px solid black; border-bottom: 1px solid black; padding-right: 12px;"><b>Model 3</b></th>
<th style="text-align: left; border-top: 2px solid black; border-bottom: 1px solid black; padding-right: 12px;"><b>Model 4</b></th>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">(Intercept)</td>
<td style="padding-right: 12px; border: none;">35.53<sup style="vertical-align: 0px;">***</sup></td>
<td style="padding-right: 12px; border: none;">27.14<sup style="vertical-align: 0px;">***</sup></td>
<td style="padding-right: 12px; border: none;">-10.73<sup style="vertical-align: 0px;">**</sup></td>
<td style="padding-right: 12px; border: none;">-0.62</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">(1.43)</td>
<td style="padding-right: 12px; border: none;">(2.27)</td>
<td style="padding-right: 12px; border: none;">(3.68)</td>
<td style="padding-right: 12px; border: none;">(5.23)</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">typeprof</td>
<td style="padding-right: 12px; border: none;">32.32<sup style="vertical-align: 0px;">***</sup></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">6.04</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">(2.23)</td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">(3.87)</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">typewc</td>
<td style="padding-right: 12px; border: none;">6.72<sup style="vertical-align: 0px;">**</sup></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">-2.74</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">(2.44)</td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">(2.51)</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">income</td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">0.00<sup style="vertical-align: 0px;">***</sup></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">0.00<sup style="vertical-align: 0px;">***</sup></td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">(0.00)</td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">(0.00)</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">education</td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">5.36<sup style="vertical-align: 0px;">***</sup></td>
<td style="padding-right: 12px; border: none;">3.67<sup style="vertical-align: 0px;">***</sup></td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">(0.33)</td>
<td style="padding-right: 12px; border: none;">(0.64)</td>
</tr>
<tr>
<td style="border-top: 1px solid black;">R<sup style="vertical-align: 0px;">2</sup></td>
<td style="border-top: 1px solid black;">0.70</td>
<td style="border-top: 1px solid black;">0.51</td>
<td style="border-top: 1px solid black;">0.72</td>
<td style="border-top: 1px solid black;">0.83</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">Adj. R<sup style="vertical-align: 0px;">2</sup></td>
<td style="padding-right: 12px; border: none;">0.69</td>
<td style="padding-right: 12px; border: none;">0.51</td>
<td style="padding-right: 12px; border: none;">0.72</td>
<td style="padding-right: 12px; border: none;">0.83</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">Num. obs.</td>
<td style="padding-right: 12px; border: none;">98</td>
<td style="padding-right: 12px; border: none;">102</td>
<td style="padding-right: 12px; border: none;">102</td>
<td style="padding-right: 12px; border: none;">98</td>
</tr>
<tr>
<td style="border-bottom: 2px solid black;">RMSE</td>
<td style="border-bottom: 2px solid black;">9.50</td>
<td style="border-bottom: 2px solid black;">12.09</td>
<td style="border-bottom: 2px solid black;">9.10</td>
<td style="border-bottom: 2px solid black;">7.09</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;" colspan="6"><span style="font-size:0.8em"><sup style="vertical-align: 0px;">***</sup>p &lt; 0.001, <sup style="vertical-align: 0px;">**</sup>p &lt; 0.01, <sup style="vertical-align: 0px;">*</sup>p &lt; 0.05</span></td>
</tr>
</table>

By default, `htmlreg()` prints out HTML, which is exactly what I want in an R markdown document. 
To save the output to a file, specify a non-null `file` argument.
For example, to save the table to the file `prestige.html`,

```r
htmlreg(prestige_mods, file = "prestige.html")
```

Since this function outputs HTML directly to the console, it can be hard to tell what's going on.
If you want to preview the table in RStudio while working on it, this
snippet of code uses **[htmltools](https://cran.r-project.org/package=htmltools)** package to do so:

```r
library("htmltools")
htmlreg(prestige_mods) %>% HTML() %>% browsable()
```

The `htmlreg` function has many options to adjust the table formatting.
Below, I clean up the table. 

- I remove stars using `stars = NULL`. It is a growing convention to avoid the use of stars indicating significance in regression tables (see *AJPS* and *Political Analysis* guidelines).
- The arguments `doctype`, `html.tag`, `head.tag`, `body.tag` control what sort of HTML is created. Generally all these functions (whether LaTeX or HTML output) have some arguments that determine whether it is creating a standalone, complete document, or a fragment that will be copied into another document.
- The arguments `include.rsquared`, `include.adjrs`, and `include.nobs` are passed to the function `extract()` which determines what information the `texreg` package extracts from a model to put into the table. I get rid of $R^2$, but keep adjusted $R^2$, and the number of observations.


```r
library("stringr")
coefnames <- c("Professional",
               "Working Class",
               "Income", 
               "Education")
note <- "OLS regressions with prestige as the response variable."
htmlreg(prestige_mods, stars = NULL,
        custom.model.names = str_c("(", seq_along(prestige_mods), ")"),
        omit.coef = "\\(Intercept\\)",
        custom.coef.names = coefnames,
        custom.note = str_c("Note: ", note),
        caption.above = TRUE,
        caption = "Regressions of Occupational Prestige",
        # better for markdown
        doctype = FALSE,
        html.tag = FALSE,
        head.tag = FALSE,
        body.tag = FALSE, 
        # passed to extract() method for "lm"
        include.adjr = TRUE,
        include.rsquared = FALSE,
        include.rmse = FALSE,
        include.nobs = TRUE)
```


<table cellspacing="0" align="center" style="border: none;">
<caption align="top" style="margin-bottom:0.3em;">Regressions of Occupational Prestige</caption>
<tr>
<th style="text-align: left; border-top: 2px solid black; border-bottom: 1px solid black; padding-right: 12px;"><b></b></th>
<th style="text-align: left; border-top: 2px solid black; border-bottom: 1px solid black; padding-right: 12px;"><b>(1)</b></th>
<th style="text-align: left; border-top: 2px solid black; border-bottom: 1px solid black; padding-right: 12px;"><b>(2)</b></th>
<th style="text-align: left; border-top: 2px solid black; border-bottom: 1px solid black; padding-right: 12px;"><b>(3)</b></th>
<th style="text-align: left; border-top: 2px solid black; border-bottom: 1px solid black; padding-right: 12px;"><b>(4)</b></th>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">Professional</td>
<td style="padding-right: 12px; border: none;">32.32</td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">6.04</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">(2.23)</td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">(3.87)</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">Working Class</td>
<td style="padding-right: 12px; border: none;">6.72</td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">-2.74</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">(2.44)</td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">(2.51)</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">Income</td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">0.00</td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">0.00</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">(0.00)</td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">(0.00)</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">Education</td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">5.36</td>
<td style="padding-right: 12px; border: none;">3.67</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">(0.33)</td>
<td style="padding-right: 12px; border: none;">(0.64)</td>
</tr>
<tr>
<td style="border-top: 1px solid black;">Adj. R<sup style="vertical-align: 0px;">2</sup></td>
<td style="border-top: 1px solid black;">0.69</td>
<td style="border-top: 1px solid black;">0.51</td>
<td style="border-top: 1px solid black;">0.72</td>
<td style="border-top: 1px solid black;">0.83</td>
</tr>
<tr>
<td style="border-bottom: 2px solid black;">Num. obs.</td>
<td style="border-bottom: 2px solid black;">98</td>
<td style="border-bottom: 2px solid black;">102</td>
<td style="border-bottom: 2px solid black;">102</td>
<td style="border-bottom: 2px solid black;">98</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;" colspan="6"><span style="font-size:0.8em">Note: OLS regressions with prestige as the response variable.</span></td>
</tr>
</table>

Once you find a set of options that are common across your tables, make a function so you do not need to retype them.


```r
my_reg_table <- function(mods, ..., note = NULL) {
  htmlreg(mods,
          stars = NULL,
          custom.note = if (!is.null(note)) str_c("Note: ", note) else NULL,
          caption.above = TRUE,
          # better for markdown
          doctype = FALSE,
          html.tag = FALSE,
          head.tag = FALSE)       
}
my_reg_table(prestige_mods,
            custom.model.names = str_c("(", seq_along(prestige_mods), ")"),
            custom.coef.names = coefnames,
            note = note,
            # put intercept at the bottom
            reorder.coef = c(2, 3, 4, 5, 1),
            caption = "Regressions of Occupational Prestige")
```


<table cellspacing="0" align="center" style="border: none;">
<caption align="top" style="margin-bottom:0.3em;">Statistical models</caption>
<tr>
<th style="text-align: left; border-top: 2px solid black; border-bottom: 1px solid black; padding-right: 12px;"><b></b></th>
<th style="text-align: left; border-top: 2px solid black; border-bottom: 1px solid black; padding-right: 12px;"><b>Model 1</b></th>
<th style="text-align: left; border-top: 2px solid black; border-bottom: 1px solid black; padding-right: 12px;"><b>Model 2</b></th>
<th style="text-align: left; border-top: 2px solid black; border-bottom: 1px solid black; padding-right: 12px;"><b>Model 3</b></th>
<th style="text-align: left; border-top: 2px solid black; border-bottom: 1px solid black; padding-right: 12px;"><b>Model 4</b></th>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">(Intercept)</td>
<td style="padding-right: 12px; border: none;">35.53</td>
<td style="padding-right: 12px; border: none;">27.14</td>
<td style="padding-right: 12px; border: none;">-10.73</td>
<td style="padding-right: 12px; border: none;">-0.62</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">(1.43)</td>
<td style="padding-right: 12px; border: none;">(2.27)</td>
<td style="padding-right: 12px; border: none;">(3.68)</td>
<td style="padding-right: 12px; border: none;">(5.23)</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">typeprof</td>
<td style="padding-right: 12px; border: none;">32.32</td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">6.04</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">(2.23)</td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">(3.87)</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">typewc</td>
<td style="padding-right: 12px; border: none;">6.72</td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">-2.74</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">(2.44)</td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">(2.51)</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">income</td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">0.00</td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">0.00</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">(0.00)</td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">(0.00)</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">education</td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">5.36</td>
<td style="padding-right: 12px; border: none;">3.67</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;"></td>
<td style="padding-right: 12px; border: none;">(0.33)</td>
<td style="padding-right: 12px; border: none;">(0.64)</td>
</tr>
<tr>
<td style="border-top: 1px solid black;">R<sup style="vertical-align: 0px;">2</sup></td>
<td style="border-top: 1px solid black;">0.70</td>
<td style="border-top: 1px solid black;">0.51</td>
<td style="border-top: 1px solid black;">0.72</td>
<td style="border-top: 1px solid black;">0.83</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">Adj. R<sup style="vertical-align: 0px;">2</sup></td>
<td style="padding-right: 12px; border: none;">0.69</td>
<td style="padding-right: 12px; border: none;">0.51</td>
<td style="padding-right: 12px; border: none;">0.72</td>
<td style="padding-right: 12px; border: none;">0.83</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">Num. obs.</td>
<td style="padding-right: 12px; border: none;">98</td>
<td style="padding-right: 12px; border: none;">102</td>
<td style="padding-right: 12px; border: none;">102</td>
<td style="padding-right: 12px; border: none;">98</td>
</tr>
<tr>
<td style="border-bottom: 2px solid black;">RMSE</td>
<td style="border-bottom: 2px solid black;">9.50</td>
<td style="border-bottom: 2px solid black;">12.09</td>
<td style="border-bottom: 2px solid black;">9.10</td>
<td style="border-bottom: 2px solid black;">7.09</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;" colspan="6"><span style="font-size:0.8em">Note: OLS regressions with prestige as the response variable.</span></td>
</tr>
</table>
Note that I didn't include every option in `my_reg_table`, only those arguments that will be common across tables.
I use `...` to pass arguments to `htmlreg`.
Then when I call `my_reg_table` the only arguments are those specific to the
*content* of the table, not the formatting, making it easier to understand what each table is saying.

Of course, `texreg` also produces LaTeX output, with the function [texreg](https://www.rdocumentation.org/packages/texreg/topics/texreg).
Almost all the options are the same as `htmlreg`.
