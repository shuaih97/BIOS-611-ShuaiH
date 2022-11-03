PHONY: clean

clean:
	rm Derived_data/*
	rm Figures/*

Derived_data/ObesityConvert.txt:\
  Source_data/obesity.txt 1.preprocess.R
	Rscript 1.preprocess.R

Derived_data/Predited_value_test.csv:\
  Derived_data/ObesityConvert.txt 2.analysis.R
	Rscript 2.analysis.R

Figures/corr.png Figures/Variable_importance_base.png Figures/Tree_number.png Figures/Variable_importance_tree300.png Figures/ROC.png:\
  Derived_data/ObesityConvert.txt 2.analysis.R
	Rscript 2.analysis.R

3.report.pdf:\
  Figures/corr.png 3.report.Rmd
	Rscript 4.createreport.R