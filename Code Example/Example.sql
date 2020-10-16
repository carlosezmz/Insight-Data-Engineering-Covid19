
-- GET DATA FROM RAW PINGS AND MARK DUPLICATES
pings_table AS (
  SELECT ........,
         ROW_NUMBER() OVER (PARTITION BY ID, location_time ORDER BY speed, LONGITUDE, LATITUDE) AS duplicates
  FROM {raw_pings_table}
),
-- GET DATA FROM RAW PINGS AND MARK DUPLICATES
approach_start AS (
  SELECT ID,
         locationn_time,
         speed,
         LATITUDE AS lat2,
         LONGITUDE AS lon2,
         LAG(LATITUDE, 1) OVER (PARTITION BY ID ORDER BY location_time) AS previous_lat,
         LAG(LONGITUDE, 1) OVER (PARTITION BY ID ORDER BY location_time) AS previous_lon,
         LAG(speed, 1) OVER (PARTITION BY ID ORDER BY location_time) AS previous_speed,
         IFF(previous_lat::float=previous_lat, previous_lat, lat2) AS fixed_previous_lat,
         IFF(previous_lon::float=previous_lon, previous_lon, lon2) AS fixed_previous_lon,
         IFF(previous_speed::float=previous_speed, previous_speed, speed) AS fixed_previous_speed,
         HAVERSINE(fixed_previous_lat, fixed_previous_lon, lat2, lon2 ) AS distance_km,
         (
           distance_km  < 0.0914 AND speed < 15 AND fixed_previous_speed < 15
         ) AS STAYED,
         IFF(STAYED,0,1) AS increment_cluster_index
    FROM pings_table
       WHERE duplicates = 1
),
-- MAKE CLUSTER INDEX
pre_cluster AS (
  SELECT .........,
         SUM(increment_cluster_index) OVER (PARTITION BY ID ORDER BY location_time) AS cluster_index
     FROM approach_start
),
-- MAKE FIRST CLUSTER
initial_cluster AS (
  SELECT ID,
         MIN(location_time) AS cluster_stared,
         MAX(location_time) AS cluster_ended,
         AVG(LATITUDE) AS LATITUDE,
         AVG(LONGITUDE) AS LONGITUDE,
         .............
    FROM pre_cluster
      GROUP BY ID, cluster_index
)
