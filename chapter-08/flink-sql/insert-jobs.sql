-- Enrichment + classification job
INSERT INTO login_events_enriched
SELECT
  user_id,
  `timestamp`,
  ip,
  platform,
  CASE
    WHEN LOWER(device) LIKE '%iphone%' OR LOWER(device) LIKE '%android%' THEN 'mobile'
    ELSE 'desktop'
  END AS device_type,
  g.country,
  g.city
FROM login_events
LEFT JOIN ip_geo AS g ON ip LIKE CONCAT(g.ip_prefix, '%');


INSERT INTO login_anomalies
SELECT user_id, `timestamp`, 'Login from new country' AS reason, country
FROM (
  SELECT user_id, `timestamp`, country,
    ROW_NUMBER() OVER (PARTITION BY user_id, country ORDER BY `timestamp`) AS rn
  FROM login_events_enriched
)
WHERE rn = 1;