Notes and Quotes for Tukey *Exploratory Data Analysis*, 2nd ed.


**It is important to understand what you CAN DO before you learn to measure how WELL you
seem to have DONE it.**

Tukey (EDA 2nd, p. v) (author's emphasis)

The best way to **understand what CAN be done is no longer**--if it ever was--
**to ask what things could**, in our current state of our skill techniques, **be confirmed**
(positively or negatively). Even more understanding is *lost* if we consider each thing we can do to data *only*
in terms of some set of very restrictive assumptions under which tat thing is best possible--
assumptions that we *know we CANNOT check in practice*. (p. vii. Author's emphasis)

**To learn about data analysis, it is right that each of try many things that do not work**--
that we tackle more problems than we make expert analyses of. We oftern learn less from an expertly
done analysis than from one where, by not trying something, we missed--at least until we were told about it--
an opportunity to learn more.

Time will keep us from learning about many tools--we shall try to look at a few of the most general and powerful
among the simple ones. **We do not guarantee to introduce you to the ``best'' tools, particularly since
we are not sure that they can be unique bests.**  (p. 1)

**Exploratory data analysis is detective work** (p. 1)

General statistical guidelines (p. 3)

- **Unless exploratory data analysis uncovers indications, usually quantitative ones, there is likely to be
nothing for confirmatory data analysis to consider.** (p. 3)
- **... restricting one's self to the planned analysis--failing to accompany it with exploration--loses sight
    of the most interesting results too frequently to be comfortable.**
- To accept all appearances as conclusive would be destructively foolish ....
    **To fail to collect all appearances because some--or even most--are only accidents would, however, be gross malfeasance ...**

**Exploratory data analysis can never be the whole story, but nothing else can serve as the foundation stone--as the first step.** (p. 3)


- Summarizing
- Batching numbers

we ought to judge each occurrence against the background of--or a background derived from--other ``nearby'' occurrences. (p. 125)

plot the residuals.

the fit is our current description--always incomplete, always approximate--of the overall behavior of the data.
Each individual observation is spit up into a sum of this fit and what is left over, called "a residual". (p. 125)

   data = fit + residuals
   given data = smooth + rough
