import plotly.graph_objs as go
import plotly
import pandas as pd
import plotly.plotly as py
import plotly.figure_factory as FF
# https://plot.ly/python/




df = pd.read_csv('/home/avios/check_internet.csv')

# #############Table graph (make graph of header)##################
# sample_data_table = FF.create_table(df)
# plotly.offline.plot(sample_data_table, filename='sample-data-table.html')
# ##########################################

# ################Lines Graph vs (x y coordinate) ######################
# trace1 = go.Scatter(
#                     x=df['Time'], y=df['Status'], # Data
#                     mode='lines', name='Time' # Additional options
#                    )
# trace2 = go.Scatter(x=df['Date'], y=df['Status'], mode='lines', name='Date' )
#
# layout = go.Layout(title='Simple Plot from csv data',
#                    plot_bgcolor='rgb(230, 230,230)')
#
# fig = go.Figure(data=[trace1, trace2], layout=layout)
# plotly.offline.plot(fig, filename='sample-data-table.html')
# ##################################################

###################Graph lines vs date & time########################
trace = go.Scatter(x = df['Date'], y = df['Status'],
                  name='Internet status')
layout = go.Layout(title='Check internet',
                   plot_bgcolor='rgb(230, 230,230)',
                   showlegend=True)
fig = go.Figure(data=[trace], layout=layout)

plotly.offline.plot(fig, filename='sample-data-table.html')
#############################################################




