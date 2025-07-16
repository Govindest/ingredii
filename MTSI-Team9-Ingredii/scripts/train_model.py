"""Train a very small model using the expiry dataset."""

import pandas as pd
from sklearn.linear_model import LinearRegression

CSV_PATH = '../data/expiry_dataset.csv'

if __name__ == '__main__':
    data = pd.read_csv(CSV_PATH)
    X = data[['expiry_days']]
    y = data['expiry_days']  # toy example
    model = LinearRegression().fit(X, y)
    print('Model trained with', len(data), 'records')
