# Mixed-Effect Bayesian Network Reveals Personal Effects of Nutrition 
## Supplementary material for the article

This repository contains all the data and code for reproducing the analysis and figures in the main article. The analysis is conducted in RMarkdown notebook and it contains all the details for model developing, testing and inference. All the figures at the article are produced with this notebook without any editing.

Repository contents:

- revealing-personal-reactions.pdf  - PDF extract of the main supplementary document
- revealing-personal-reactions.Rmd  - Main supplementary document in RMarkdown 
- cross-validation.Rmd              - Separated RMarkdown notebook for executing cross-validation. The results are shown in the main document.
- xgboost.Rmd                       - Separated RMarkdown notebook for comparing XGBoost model against the same data. The results are shown in the main document.
- randomforest.Rmd                  - Separated RMarkdown notebook for comparing Random Forest decision tree with MEBN and XGBoost.
- data/                             - Folder including Sysdimet-dataset that is used in the analysis
- evaluations/                      - cross-validation.Rmd and xgboost.Rmd output their results in this folder for the main document
- mebn/MEBN.r                       - Reusable R-function library for constructing Mixed-effect Bayesian networks
- mebn/*.stan                       - Stan definitions of different model candidates that are compared in the main document
- models/                           - Cache folder for storing estimated Stan models. Estimated models are stored as files to speed up the execution.
- graphs/                           - Cache folder for storing MEBN-graphs estimated Stan models. Estimated models are stored as files to speed up the execution.
- README.md                         - This file


Execution of the RMarkdown notebooks require R version 3.6 (https://cran.r-project.org/) and following packages
- RStan (https://mc-stan.org/users/interfaces/rstan)
- iGraph (https://igraph.org/r)
- Bayesplot (https://mc-stan.org/bayesplot)
- knitr (https://cran.r-project.org/web/packages/knitr)
- kableExtra (https://cran.r-project.org/web/packages/kableExtra)
- ggplot2 (https://cran.r-project.org/web/packages/ggplot2)
- gridExtra (https://cran.r-project.org/web/packages/gridExtra)
- xgboost (https://cran.r-project.org/web/packages/xgboost)
- randomForest (https://cran.r-project.org/web/packages/randomForest)
- stats

..
