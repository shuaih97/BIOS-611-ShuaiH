PHONY: clean

clean:
	rm Derived_data/*
	rm Figures/*

Derived_data/ObesityConvert.txt:\
  Source_data/obesity.txt preprocess.R
	Rscript preprocess.R

Derived_data/Predited_value_test.csv:\
  Derived_data/ObesityConvert.txt analysis.R
	Rscript analysis.R

Figures/corr.png Figures/Variable_importance_base.png Figures/Tree_number.png Figures/Variable_importance_tree300.png Figures/ROC.png:\
  Derived_data/ObesityConvert.txt analysis.R
	Rscript analysis.R

report.pdf:\
  Figures/corr.png report.Rmd
	Rscript createreport.R
