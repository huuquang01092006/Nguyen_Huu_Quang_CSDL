
USE social_network_pro;

CREATE INDEX idx_user_gender ON users(gender);

CREATE OR REPLACE VIEW view_highly_interactive_users AS
SELECT
  u.user_id,
  u.username,
  COUNT(c.comment_id) AS comment_count
FROM users u
JOIN comments c ON c.user_id = u.user_id
GROUP BY u.user_id, u.username
HAVING COUNT(c.comment_id) > 5;

SELECT
  user_id,
  username,
  comment_count
FROM view_highly_interactive_users
ORDER BY comment_count DESC;


SELECT
  v.username,
  COUNT(c.comment_id) AS sum_comment_user
FROM view_highly_interactive_users v
JOIN posts p    ON p.user_id = v.user_id
LEFT JOIN comments c ON c.post_id = p.post_id
GROUP BY v.user_id, v.username
ORDER BY sum_comment_user DESC;
