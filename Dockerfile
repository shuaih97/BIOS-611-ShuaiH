FROM rocker/verse
RUN R -e "install.packages(\"e1071\"); install.packages(\"caret\"); install.packages(\"randomForest\"); install.packages(\"corrplot\"); install.packages(\"pROC\"); install.packages(\"rmarkdown\"); install.packages(\"pandoc\"); install.packages(\"scales\")"
RUN Rscript --no-restore --no-save -e "update.packages(ask = FALSE);"
