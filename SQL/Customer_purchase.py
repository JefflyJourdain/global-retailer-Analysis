# Import required libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

# Load and view your data
shopping_data = pd.read_csv("online_shopping_session_data.csv")
shopping_data.head()


 df = shopping_data[shopping_data['Month'].isin(['Nov', 'Dec'])]
rate = df.groupby('CustomerType')['Purchase'].mean() 
rate

purchase_rates  = rate.to_dict()
purchase_rates 

