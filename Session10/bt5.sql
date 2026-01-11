USE social_network_pro;


EXPLAIN ANALYZE
SELECT
  u.user_id,
  u.username,
  u.hometown,
  p.post_id,
  p.content
FROM users u
JOIN posts p ON p.user_id = u.user_id
WHERE u.hometown = 'Hà Nội'
ORDER BY u.username DESC
LIMIT 10;

CREATE INDEX idx_hometown
ON users(hometown);

EXPLAIN ANALYZE
SELECT
  u.user_id,
  u.username,
  u.hometown,
  p.post_id,
  p.content
FROM users u
JOIN posts p ON p.user_id = u.user_id
WHERE u.hometown = 'Hà Nội'
ORDER BY u.username DESC
LIMIT 10;
