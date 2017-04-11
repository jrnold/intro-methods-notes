
# Yule's Pauperism Data

Example from @Yule1897a,@Yule1896b,@Yule1896a,@Plewis2017a.

See @Stigler2016a,@Stigler1990a

## Setup


```r
library("tidyverse")
```

## Examples


```r
datums::pauperism_year %>%
  filter(year == 1871) %>%  
  select(outratio, pauper2) %>%
  drop_na() %>%
  ggplot(aes(x = outratio, pauper2)) +
  geom_point() + 
  geom_smooth(method = "lm")
```

<img src="pauperism_files/figure-html/unnamed-chunk-3-1.svg" width="672" />


```r
datums::pauperism_year %>%
  filter(year == 1871) %>%  
  select(outratio, pauper2) %>%
  drop_na() %>%
  cor()
```

```
##           outratio   pauper2
## outratio 1.0000000 0.2105665
## pauper2  0.2105665 1.0000000
```

Regressions for each year

```r
datums::pauperism_year %>%
  group_by(year) %>%
  summarise(mod = list(lm(outratio ~ pauper2, data = .)))
```

```
## # A tibble: 3 × 2
##    year      mod
##   <int>   <list>
## 1  1871 <S3: lm>
## 2  1881 <S3: lm>
## 3  1891 <S3: lm>
```



```r
datums::pauperism_year %>%
  filter(year == 1871) %>%
  select(outratio, pauper2) %>%
  drop_na() %>%
  lm(pauper2 ~ outratio, data = .)
```

```
## 
## Call:
## lm(formula = pauper2 ~ outratio, data = .)
## 
## Coefficients:
## (Intercept)     outratio  
##    0.043637     0.001218
```
