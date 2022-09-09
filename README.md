House price data in Kaggle: 
https://www.kaggle.com/competitions/house-prices-advanced-regression-techniques/overview
This is a data set for us to build models to predict the house prices. For a house, the price may be 
influenced  by  many  aspects  of  things,  such  as  area,  shape,  street,  neighborhood.  It  is  hard  to  tell 
what will the final price of a house be using a small number of predictors. This data set provides us 
79 explanatory variables, so that we have a lot of information to do prediction on the house price. 
We can build some models, like linear regression models, random forest, or deep learning models 
to do prediction on the house price, and to compare different models.
We  can  first  check  the  missing  values  of  the  data,  to  see  whether  we  need  to  exclude  some 
observations or not (in many cases, we will not delete the observation unless the response variable 
is missing). We can check the basic statistics of the variables including predictors and the response 
variables, like mean, max, min, and quantiles, from which we can check if they are balanced. We 
can make some plots to make it clearer.
If we fit a linear regression model, we can do some variable selection to see which variables are not 
important to predict the house price, and we can select some top significant variables, like top five 
variables, for people who want to buy a new house as a reference to make a more reasonable decision.
We can also give suggestions to developers, to see whether it worth to build houses in one place.
We can also learn the most important reasons for a house price, to compare with our common sense, 
since sometimes our common sense goes awry.
Besides the linear regression model with all predictors added independently, we can try to analyze 
interactions between some variables, like the interaction between area and neighborhood, since we 
know from our common sense, in some areas, the neighborhood will have more impact on the safety 
or happiness, then impact the house price, and in some areas, the impact of neighborhood might be 
less.
We can also fit other models, like random forest, and some deep learning models like MLP. Those 
are famous machine learning models. By using random forest, we can also do variable selections. 
We can use some metric to measure the importance of each variable, and result can be compared 
with the linear regression models.
The deep learning models are demonstrated a great ability in big data. If the data is too small, deep 
learning models might have some over-fitting problem. We can also try deep learning models in the 
house price prediction task and try different parameters like learning rate and drop out rate to see 
the robustness of deep learning models in this data.