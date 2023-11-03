"""
https://facebook.github.io/prophet/docs/quick_start.html#python-api
"""
import pandas as pd
from prophet import Prophet

import plotly.io as pio
pio.renderers.default = "browser"


def get_data():
    df = pd.read_csv(
        "https://raw.githubusercontent.com/facebook/prophet/"
        + "main/examples/example_wp_log_peyton_manning.csv"
    )
    return df


def prophet_tutorial():
    print("in getting started")
    df = get_data()
    print(df.head())

    # fit existing data
    m = Prophet()
    m.fit(df)

    print("display last few rows")
    print(df.tail())

    # generate future time data
    future = m.make_future_dataframe(periods=365)
    print(future.tail())

    forecast = m.predict(future)
    cols = ['ds', 'yhat', 'yhat_lower', 'yhat_upper']
    print(forecast[cols].tail())

    fig1 = m.plot(forecast)
    fig1.show()
    breakpoint()

