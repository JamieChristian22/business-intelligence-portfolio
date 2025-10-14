SELECT
  segment_id,
  AVG(volume) AS avg_volume,
  AVG(incidents) AS avg_incidents,
  AVG(avg_speed_mph) AS avg_speed
FROM traffic_volume_daily
GROUP BY segment_id
ORDER BY avg_volume DESC;