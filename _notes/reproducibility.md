
- "Good Enough Practices in Scientific Computing" https://arxiv.org/abs/1609.00037
- ProjectTemplate http://projecttemplate.net/
- Jenny Bryan. Stat 545. "R coding style and organizing analytical projects" https://www.stat.ubc.ca/~jenny/STAT545A/block19_codeFormattingOrganization.html
- [How to efficiently manage a statistical analysis project?](http://stats.stackexchange.com/questions/2910/how-to-efficiently-manage-a-statistical-analysis-project)
- Rich Fitzjohn [Designing projects](https://nicercode.github.io/blog/2013-04-05-projects/) April 5, 2013
- Noble WS (2009) A Quick Guide to Organizing Computational Biology Projects. PLoS Comput Biol 5(7): e1000424. doi:10.1371/journal.pcbi.1000424
- Carl Boetinger "My research workflow, based on GitHub" http://www.carlboettiger.info/2012/05/06/research-workflow.html. May 6, 2012.
- Example R analysis workflow. https://github.com/klmr/example-r-analysis
- Karl Broman. Steps toward reproducible research. http://kbroman.org/steps2rr/
- Data Organization http://kbroman.org/dataorg/
- How I mangage data projects with RStudio and Git. http://christianlemp.com/blog/2014/02/05/How-I-Manage-Data-Projects-with-RStudio-and-Git.html
- Organizing a project. http://www.rci.rutgers.edu/~ag978/litdata/organizing/
- Some data analysis/warning with R: Things I wish I had been told. http://reganmian.net/blog/2014/10/14/starting-data-analysiswrangling-with-r-things-i-wish-id-been-told/
- Organizing the project directory. https://nicercode.github.io/blog/2013-05-17-organising-my-project/
- Gentzkow M, Shapiro JM. Code and Data for the Social Sciences: A Practitioner’s Guide; 2014. Available from:
http://web.stanford.edu/~gentzkow/research/CodeAndData.pdf.

- Organizing a data analysis project. https://www.maxmasnick.com/analysis-org/. July 15, 2014.
- Sandve GK, Nekrutenko A, Taylor J, Hovig E (2013) Ten Simple Rules for Reproducible Computational Research. PLoS Comput Biol 9(10): e1003285. doi:10.1371/journal.pcbi.1003285
- StackOverflow. "How does software development compare with statistical programming/analysis?" http://stackoverflow.com/questions/2295389/how-does-software-development-compare-with-statistical-programming-analysis. 2010.
- Stackoverflow. ESS workflow for R project/package development. http://stackoverflow.com/questions/3027476/ess-workflow-for-r-project-package-development
- Stackoverflow. "Workflow for statistical analysis and report writing" http://stackoverflow.com/questions/1429907/workflow-for-statistical-analysis-and-report-writing


- Be systematic, be consistent.
- The source and original data are real - everything else is temporary
- Treat data as read only
- Use paths relative to the project root. Never use `setwd`, never include absolute paths.
- Encapsulate everything in one directory
- Separate raw data from derived data
- Separate data from code
- Choose file names carefully (never use "final")
- Include a README file which explains what's in the directory.
