-- Overview: counts & rating by type
SELECT
  type,
  COUNT(*) AS titles,
  AVG(imdb_rating) AS avg_imdb
FROM netflix_content
GROUP BY type;

-- Genre performance
SELECT
  genre,
  COUNT(*) AS titles,
  AVG(imdb_rating) AS avg_imdb
FROM netflix_content
GROUP BY genre
ORDER BY avg_imdb DESC;

-- Country + type mix
SELECT
  country,
  type,
  COUNT(*) AS titles
FROM netflix_content
GROUP BY country, type
ORDER BY titles DESC;