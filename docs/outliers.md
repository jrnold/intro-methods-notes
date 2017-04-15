
# Outliers

This has absolutely nothing to do with the Malcolm Gladwell book.

- An *outlier* is an observation which has large regression errors $\hat{\epsilon}^2$.
- It is distant from the other observations on the $y$ dimension. 
- It increases standard errors by increasing $\hat{\sigma}^2$, but does not bias $\beta$ if it is has typical values of $x$

There are two types of extreme values in a regression.

- Leverage point: extreme in the $x$ direction
- Outlier : extreme in the $y$ direction. The point has a large error (the regression line does not fit the point well)

For a point to affect the results of a regression (**influential**) it must be both a high *levarage point* and an *outlier*.

The points that are **influential** follows from the same calculations that were in the discussion of how the linear regression is a weighted averge of points.


What does this mean? 

- Are the outliers bad data? 
- Are the data truly contaminated, meaning that they come from a different distribution. This means that you are fitting the wrong model to the DGP causing inefficiency and maybe bias.

Hat matrix



The hat matrix is named as such because it puts the "hat" on $Y$,

The hat matrix 
$$
\mat{H} = \mat{X} (\mat{X}\T \mat{X})^{-1} \mat{X}\T
$$

$$
\begin{aligned}[t]
\hat{\vec{\epsilon}} &= \vec{y} - \mat{X} \hat{\vec{\beta}} \\
&= \vec{y} - \mat{X} (\mat{X}\T \mat{X})^{-1} \mat{X} \vec{y} \\ 
&= \vec{y} - \mat{H} \vec{y} \\
&= (\mat{I} - \mat{H}) \vec{y}
\end{aligned}
$$

$$
\hat{\vec{y}} = \mat{H} \vec{y}
$$

Some notes:

- $\mat{H}$ is a $n \times n$ symmetric matrix
- $\mat{H}$ is idempotent: $\mat{H} \mat{H} = \mat{H}$

Since
$$
\hat\vec{y} = \mat{X} \widehat{\vec{\beta}} = \mat{X} (\mat{X}\T \mat{X})^{-1} \mat{X}\T \vec{y} = \mat{H} \vec{y},
$$
for a particular observation $i$,
$$
\hat{y}_i = \sum_{j = 1}^n h_{ij} y_j.
$$
The equation above means that predicted value of every observation is a weighted value of the outcomes of other observations.

The hat values $h_i = h_ij$ are diagonal entries in the hat matrix.

For a bivariate linear regresion,
$$
h_i = \frac{1}{n} + \frac{(x_i - \bar{x})^2}{\sum_{j = 1}^n (x_j - \bar{x})^2},
$$
meaning

- hat values are always *at least* $1 / n$
- hat values are a function of how far $i$ is from the center of $\mat{X}$ distribution

Rule of thumb: examine hat values greater than $2 (k + 1) / n$.

