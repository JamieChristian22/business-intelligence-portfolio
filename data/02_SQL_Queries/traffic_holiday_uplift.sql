WITH base AS (
  SELECT
    d.date,
    t.segment_id,
    t.volume,
    t.weather,
    d.is_holiday_us
  FROM traffic_volume_daily t
  JOIN dim_date d ON d.date_key = t.date_key
)
SELECT
  CASE WHEN is_holiday_us THEN 'Holiday' ELSE 'Non-Holiday' END AS period_type,
  AVG(volume) AS avg_volume,
  AVG(CASE WHEN weather='Clear' THEN volume END) AS avg_volume_clear,
  AVG(CASE WHEN weather<>'Clear' THEN volume END) AS avg_volume_nonclear
FROM base
GROUP BY 1;