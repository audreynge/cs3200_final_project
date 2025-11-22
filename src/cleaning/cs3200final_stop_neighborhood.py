
'''
Used for asistance:
[1] - https://www.geeksforgeeks.org/python/response-raise_for_status-python-requests/
[2] - https://geopandas.org/en/stable/docs/user_guide/io.html
[3] -https://geopandas.org/en/stable/gallery/create_geopandas_from_pandas.html
[4] -https://geopandas.org/en/stable/docs/user_guide/mergingdata.html
[5]   -https://shapely.readthedocs.io/en/latest/manual.html#binary-predicates

'''
import requests
import pandas as pd
import geopandas as gpd

#store url, will need to be updated every 24 hrs from boston.gov
url = "https://s3.amazonaws.com/og-production-open-data-bostonma-892364687672/resources/e5849875-a6f6-4c9c-9d8a-5048b0fbd03e/boston_neighborhood_boundaries.geojson?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJJIENTAPKHZMIPXQ%2F20251119%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20251119T160303Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=host&X-Amz-Signature=8a27ec9057eb124ebcc25646eaad4bee81c145d87c89e3a657da3905e1d0e653"

#get url and error handling
response = requests.get(url)
response.raise_for_status() #[1]
print("successful")

print(type(response.content))
#<class 'bytes'>

#write the file using response content
with open("../../data/raw/boston_neighborhood_boundaries.geojson", "wb") as f:
    f.write(response.content)


print("geojson download success")

#read file to geodf
neighborhoods = gpd.read_file("../../data/raw/boston_neighborhood_boundaries.geojson") # [2]

#check columns and crs
print(neighborhoods.head())
print(neighborhoods.columns)
print(neighborhoods.crs)

#read stops to df [3]
stations_df = pd.read_csv("../../data/raw/Rapid_Transit_Stops.csv") 

print(stations_df.columns)

#create geodf with stations and long/lat of stops using matching crs from neighborhoods
stations_gdf = gpd.GeoDataFrame(
    stations_df,
    geometry=gpd.points_from_xy(stations_df.stop_lon, stations_df.stop_lat),
    crs="EPSG:4326")

#joining stations geodf with neighborhoods on the lat/long [4] [5]
stations_with_neighborhood = gpd.sjoin(stations_gdf, neighborhoods, how="left", predicate="within")

#check results
print(stations_with_neighborhood[['stop_id', 'stop_name', 'name']].head())

#create a csv
stations_with_neighborhood[['stop_id', 'stop_name', 
                            'name']].rename(columns={'name': 'neighborhood_name'}).to_csv("../../data/processed/station_neighborhood.csv", 
                                                                                          index=False)
#success message
print("station_neighborhood.csv created")

