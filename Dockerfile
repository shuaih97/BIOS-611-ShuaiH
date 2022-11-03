FROM rocker/verse
RUN R -e "install.packages(\"e1071\"); install.packages(\"caret\"); install.packages(\"randomForest\"); install.packages(\"corrplot\"); install.packages(\"pROC\"); install.packages(\"pandoc\")"
RUN Rscript --no-restore --no-save -e "update.packages(ask = FALSE);"