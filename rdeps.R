install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest'), repos='http://cran.us.r-project.org')
devtools::install_github('IRkernel/IRkernel')
IRkernel::installspec()
IRkernel::installspec(user = FALSE)