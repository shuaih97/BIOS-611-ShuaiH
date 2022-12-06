Obesity Prediction Using Random Forest
======================================

Part of the data was collected from people from the countries of Mexico, Peru and Colombia using a survey in a web platform. The age of the participants is between 14 and 61. In order to make the data, the authors first searched for literatures to find out the most possible factors that may induce obesity. The covariates include diverse eating habits and physical condition. The questionnaire was conducted anonymously, so the researchers could ensure that participants' privacy was not violated. The total sample size of the original data was 485, and the outcome was not very balanced, with about 300 normal participants, and the total number of other weight level just a small percent. For example, both of the number of overweight I and overweight II participants are only about 50. To make the data more balanced, the original data was processed to obtain a sample size of 2111. After the balancing class problem was identified, synthetic data was generated, up to 77% of the data, using the toolWeka and the filter SMOTE. The final data set has a total of 17 features and 2111 records. Then all the participants were labeled as obesity and not obesity based on height and weight using the equation for calculating the BMI and the criteria for classifying obesity (BMI larger than or equal to 25.0 will be classified as obesity and below 25.0 will be classified as non-obesity).
In the analysis, the response variable is obesity, which is a binary variable, and there are 14 covariates used for evaluation, including eating habits, physical condition and other features.
The eating habits features are: Frequent consumption of high caloric food (FAVC), Frequency of consumption of vegetables (FCVC), Number of main meals (NCP), Consumption of food between meals (CAEC), Consumption of water daily (CH20), and Consumption of alcohol (CALC). The physical condition features are: Calories consumption monitoring (SCC), Physical activity frequency (FAF), Time using technology devices (TUE), Transportation used (MTRANS), other covariates obtained were: Gender, Age, Smoke, Family overweight history. 
The covariate age is a continuous variable, while other covariates are all categorical variables.

docker:
First, make sure you are under this bios-611-project folder, then run:
```
docker build -t bios611-project .
docker run -v ${PWD}:/home/rstudio -e PASSWORD=pwd -p 8787:8787 bios611-project
```

You then visit http://localhost:8787 via a browser on your machine to access the machine and development environment. For the curious, we also expose port 8888 so that we can launch other servers from in the container.

This structure of dependencies is manifested directly in your
makefile, so putting aside issues of Docker, etc, the way your project
works is that you say:

``` 
make clean
make 3.report.pdf
```
Note that to build the final report, you should visit the terminal in RStudio and type
```
make 3.report.pdf
```
