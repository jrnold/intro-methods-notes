
# Marginal Effects

Let's start with what it that we want to calculate. 
We want to calculate the "marginal effect" of changing the $j$th predictors while holding other predictors constant.

$$
ME_j =  E( y | x_j, x_{-j}) - E( y | x_j + \Delta x_j, x_{-j})
$$
or for a small change, $\Delta x_j \to 0$ in a continuous $x_j$, this is the partial derivative,
$$
ME_j =  \frac{\partial E( y | x_j, x_{-j})}{\partial x_j}
$$

Now consider the linear regression with two predictors for a change in $x_1$,
$$
\begin{aligned}[t]
ME_j &=  E(y | x_1, \tilde{x}_2) - E(y | x_1 + \Delta x_1, \tilde{x}_2)
\end{aligned}
$$
Since the linear regression equation is $E(y | x)$, this simplifies to
$$
\begin{aligned}[t]
ME_j &=  (\beta_0 + \beta_1 x_1 + \tilde{x}_2) - (\beta_0 + \beta_1 (x_1 + \Delta x_1) \tilde{x}_2) \\
&= \beta_1 \Delta x_1
\end{aligned}
$$
or with $\Delta \to 0$,
$$
\begin{aligned}[t]
ME_j &=  \frac{\partial E(y | x_1, x_2)}{\partial x_1} \\
\frac{\partial (\beta_0 + \beta_1 x_1 + \tilde{x}_2)}{\partial x_1}
&= \beta_1
\end{aligned}
$$

Note that those equations were on the population level
$$
\widehat{ME}_j = \hat{\beta}_1
$$

So, for a linear regression, the marginal effect of $x_j$, defined as the change in the expected value of $y$ for a small a unit of $j$

The equation presented above is not **causal**, it is simply a function derived from the population or estimated equation. 

If population equation is not the as the linear regression,  $\hat{\beta_j}$ can still be viewed as an estimator of $ME_j$. In OLS, the $ME_j$ is weighted by observations with the most variation in $x_j$, after accounting for the parts of $x_j$ and $y$ predicted by the other predictors. See the discussion @AngristPischke2009a and @AronowSamii2015a. 

For regressions other than OLS, the coefficients are not the $ME_j$.
It is a luxury that the coefficients happen to have a nice interpretation in OLS.
In most other regressions, the coefficients are not directly useful. This is yet another
reason to avoid the mindless presentation of tables and star-worshipping. 
The researcher should focus on inference about the research quantity of interest, whether
or not that happens to be conveniently provided as a parameter of the model that was estimated.


Even for OLS, if $x_j$ is included as part of a function, e.g. a polynomial or an interaction, then its coefficient cannot be interpreted as the marginal effect. Suppose that the regression equation is
$$
\vec{y} = \vec{\beta}_0 + \vec{\beta}_1 x_1 + \vec{\beta}_2 x_1^2 + \vec{\beta}_3 x_2,
$$
then the marginal effect of $x_1$ is,
$$
\begin{aligned}[t]
ME_j &=  \frac{\partial E(y | x_1, x_2)}{\partial x_1} \\
&= \frac{\partial (\beta_0 + \beta_1 x_1 + \beta_1 x_1^2 +  \beta_3 \tilde{x}_2)}{\partial x_1} \\
&= \beta_1 + 2 \beta_2 x_1
\end{aligned}
$$
Note that the marginal effect of $x_1$ is **not**, $\beta_1$. 
That would require a change in $x_1$ while holding $x_1 ^ 2$ constant, which is a logical impossibility.
Instead, the marginal effect of $x_1$ depends on the value of $x_2$ at which it is evaluated, and 
thus observations will have different marginal effects.

Similarly, if there is an interaction between $x_1$ and $x_2$, the coefficient of a predictor
is not its marginal effect.
For example, in
$$
y = \vec{\beta}_0 + \vec{\beta}_1 x_1 + \vec{\beta}_2 x_1 + \vec{\beta}_3 x_1 x_2
$$
the marginal effect of $x_1$ is
$$
\begin{aligned}[t]
ME_j &=  \frac{\partial E(y | x_1, x_2)}{\partial x_1} \\
&= \frac{\partial (\beta_0 + \beta_1 x_1 + \beta_1 x_1^2 +  \beta_2 \tilde{x}_2)}{\partial x_1} \\
&= \beta_1 + \beta_3 x_2
\end{aligned}
$$
Now the marginal effect of $x_1$ is a function of another variable $x_2$.


For marginal effects that are functions of the data, there are multiple ways to calculate them. They include,

- AME: Average Marginal Effect. Average the marginal effects at each observed $x$.
- MEM: Marginal Effect at the mean. Calculate the marginal effect with all observations at their means or other central values.
- MER: Marginal Effect at a representative value. Similar to MEM but with another meaningful value.

Of these, the AME is the preferred one; MEM is an approximation.

When it is discrete change in $x$, it is called a partial effect (APE) or a first difference.
The difference in the expected value of y, given a change in $x_j$ from $x^*$ to $x^* + \Delta$ is $\beta_j \Delta$, and the standard error can be calculated analytically by [https://en.wikipedia.org/wiki/Delta_method](https://en.wikipedia.org/wiki/Delta_method),
$$
\se(\hat{\beta}_j \Delta x_j) = \sqrt{\var\hat{\beta_j} (\Delta x_j)^2} = \se\hat{\beta_j} \Delta x_j.
$$
The Delta method can be used to analytically derive approximations of the standard errors for other nonlinear functions and interaction in regression, but it scales poorly, and it is often easier to use bootstrapping or software than calculate it by hand. See the [margins](https://github.com/leeper/margins) package.


## References

- Cameron, Trivedi, "Microeconomics Using Stata" Ch 10.
- Agresti and Pischke etc.
