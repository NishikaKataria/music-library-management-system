CREATE DATABASE music_library;
USE music_library;
USE music_library;

CREATE DATABASE IF NOT EXISTS music_library;

USE music_library;

CREATE TABLE artists (
    artist_id INT AUTO_INCREMENT PRIMARY KEY,
    artist_name VARCHAR(100) NOT NULL,
    country VARCHAR(60),
    debut_year SMALLINT,
    CHECK (debut_year IS NULL OR debut_year BETWEEN 1000 AND 2026)
);
ALTER TABLE artists
ADD CONSTRAINT uq_artists_name UNIQUE (artist_name);

CREATE TABLE genres (
    genre_id    INT AUTO_INCREMENT PRIMARY KEY,
    genre_name  VARCHAR(50) NOT NULL UNIQUE
);
CREATE TABLE users (
    user_id    INT AUTO_INCREMENT PRIMARY KEY,
    username   VARCHAR(50)  NOT NULL UNIQUE,
    email      VARCHAR(100) NOT NULL UNIQUE,
    join_date  DATE NOT NULL DEFAULT (CURRENT_DATE)
);

CREATE TABLE albums (
    album_id      INT AUTO_INCREMENT PRIMARY KEY,
    album_title   VARCHAR(150) NOT NULL,
    artist_id     INT NOT NULL,
    release_year  SMALLINT CHECK (release_year BETWEEN 1900 AND 2026),
    CONSTRAINT fk_albums_artist
        FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
        ON DELETE RESTRICT
);

CREATE TABLE tracks (
    track_id          INT AUTO_INCREMENT PRIMARY KEY,
    title             VARCHAR(150) NOT NULL,
    album_id          INT NOT NULL,
    genre_id          INT NOT NULL,
    track_number      SMALLINT NOT NULL CHECK (track_number > 0),
    duration_seconds  SMALLINT NOT NULL CHECK (duration_seconds > 0),
    CONSTRAINT uq_tracks_album_number UNIQUE (album_id, track_number),
    CONSTRAINT fk_tracks_album
        FOREIGN KEY (album_id) REFERENCES albums(album_id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_tracks_genre
        FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
        ON DELETE RESTRICT
);

CREATE TABLE playlists (
    playlist_id    INT AUTO_INCREMENT PRIMARY KEY,
    user_id        INT NOT NULL,
    playlist_name  VARCHAR(100) NOT NULL,
    created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_playlists_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE playlist_tracks (
    playlist_id  INT NOT NULL,
    track_id     INT NOT NULL,
    position     SMALLINT NOT NULL CHECK (position > 0),
    added_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (playlist_id, track_id),
    CONSTRAINT fk_pt_playlist
        FOREIGN KEY (playlist_id) REFERENCES playlists(playlist_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_pt_track
        FOREIGN KEY (track_id) REFERENCES tracks(track_id)
        ON DELETE CASCADE
);
CREATE TABLE listening_history (
    history_id  INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT NOT NULL,
    track_id    INT NOT NULL,
    played_at   DATETIME NOT NULL,
    CONSTRAINT fk_lh_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_lh_track
        FOREIGN KEY (track_id) REFERENCES tracks(track_id)
        ON DELETE RESTRICT
);
DESCRIBE artists;
DESCRIBE genres;
DESCRIBE users;
DESCRIBE albums;
DESCRIBE tracks;
DESCRIBE playlists;
DESCRIBE playlist_tracks;
DESCRIBE listening_history;

SELECT TABLE_NAME, CONSTRAINT_NAME, REFERENCED_TABLE_NAME, DELETE_RULE
FROM information_schema.REFERENTIAL_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = 'music_library'
ORDER BY TABLE_NAME;

INSERT INTO artists (artist_id, artist_name, country, debut_year) VALUES
(1, 'Pritam',          'India',          2003),
(2, 'A. R. Rahman',    'India',          1992),
(3, 'Taylor Swift',    'USA',            2006),
(4, 'The Weeknd',      'Canada',         2011),
(5, 'Coldplay',        'United Kingdom', 2000),
(6, 'Imagine Dragons', 'USA',            2012),
(7, 'Eminem',          'USA',            1996),
(8, 'Daft Punk',       'France',         1997);

INSERT INTO genres (genre_id, genre_name) VALUES
(1, 'Pop'),
(2, 'Rock'),
(3, 'Hip-Hop'),
(4, 'Bollywood'),
(5, 'Electronic');

INSERT INTO albums (album_id, album_title, artist_id, release_year) VALUES
(1, 'Ae Dil Hai Mushkil',        1, 2016),
(2, 'Yeh Jawaani Hai Deewani',   1, 2013),
(3, 'Rockstar',                  2, 2011),
(4, '1989',                      3, 2014),
(5, 'After Hours',               4, 2020),
(6, 'Parachutes',                5, 2000),
(7, 'Night Visions',             6, 2012),
(8, 'The Marshall Mathers LP',   7, 2000),
(9, 'Random Access Memories',    8, 2013);

INSERT INTO tracks (track_id, title, album_id, genre_id, track_number, duration_seconds) VALUES
-- Ae Dil Hai Mushkil (Bollywood)
(1,  'Ae Dil Hai Mushkil',        1, 4, 1, 269),
(2,  'Bulleya',                   1, 4, 2, 349),
(3,  'Channa Mereya',             1, 4, 3, 289),
(4,  'Cutiepie',                  1, 4, 4, 213),
-- Yeh Jawaani Hai Deewani (Bollywood)
(5,  'Badtameez Dil',             2, 4, 1, 252),
(6,  'Balam Pichkari',            2, 4, 2, 289),
(7,  'Ilahi',                     2, 4, 3, 228),
(8,  'Kabira',                    2, 4, 4, 223),
-- Rockstar (Bollywood)
(9,  'Phir Se Ud Chala',          3, 4, 1, 271),
(10, 'Kun Faya Kun',              3, 4, 4, 473),
(11, 'Sadda Haq',                 3, 4, 5, 365),
(12, 'Nadaan Parindey',           3, 4, 6, 382),
-- 1989 (Pop)
(13, 'Welcome to New York',       4, 1, 1, 212),
(14, 'Blank Space',               4, 1, 2, 231),
(15, 'Style',                     4, 1, 3, 231),
(16, 'Shake It Off',              4, 1, 6, 219),
(17, 'Bad Blood',                 4, 1, 8, 211),
(18, 'Wildest Dreams',            4, 1, 9, 220),
-- After Hours (Pop)
(19, 'Heartless',                 5, 1, 7, 198),
(20, 'Blinding Lights',           5, 1, 9, 200),
(21, 'In Your Eyes',              5, 1, 10, 237),
(22, 'Save Your Tears',           5, 1, 11, 215),
-- Parachutes (Rock)
(23, 'Don''t Panic',              6, 2, 1, 137),
(24, 'Shiver',                    6, 2, 2, 304),
(25, 'Yellow',                    6, 2, 5, 269),
(26, 'Trouble',                   6, 2, 6, 273),
-- Night Visions (Rock)
(27, 'Radioactive',               7, 2, 1, 186),
(28, 'Demons',                    7, 2, 4, 177),
(29, 'It''s Time',                7, 2, 3, 240),
(30, 'On Top of the World',       7, 2, 5, 192),
-- The Marshall Mathers LP (Hip-Hop)
(31, 'Stan',                      8, 3, 3, 404),
(32, 'The Way I Am',              8, 3, 7, 290),
(33, 'The Real Slim Shady',       8, 3, 8, 284),
-- Random Access Memories (Electronic)
(34, 'Give Life Back to Music',   9, 5, 1, 275),
(35, 'Instant Crush',             9, 5, 5, 337),
(36, 'Lose Yourself to Dance',    9, 5, 6, 353),
(37, 'Get Lucky',                 9, 5, 8, 369);

INSERT INTO users (user_id, username, email, join_date) VALUES
(1, 'aarav_music',  'aarav.sharma@example.com', '2026-01-15'),
(2, 'priya_beats',  'priya.verma@example.com',  '2026-02-20'),
(3, 'rohan_rocks',  'rohan.mehta@example.com',  '2026-03-05'),
(4, 'sneha_melody', 'sneha.iyer@example.com',   '2026-04-12'),
(5, 'kabir_vibes',  'kabir.singh@example.com',  '2026-06-01');

INSERT INTO playlists (playlist_id, user_id, playlist_name, created_at) VALUES
(1, 1, 'Bollywood Hits',  '2026-10-01 10:00:00'),
(2, 1, 'Workout Mix',     '2026-10-02 18:30:00'),
(3, 2, 'Pop Favourites',  '2026-10-03 09:15:00'),
(4, 3, 'Rock Classics',   '2026-10-04 20:00:00'),
(5, 4, 'Chill Evenings',  '2026-10-05 21:45:00'),
(6, 5, 'Road Trip',       '2026-10-06 07:30:00');

INSERT INTO playlist_tracks (playlist_id, track_id, position, added_at) VALUES
(1, 3,  1, '2026-10-01 10:01:00'),
(1, 5,  2, '2026-10-01 10:02:00'),
(1, 10, 3, '2026-10-01 10:03:00'),
(1, 8,  4, '2026-10-01 10:04:00'),
(1, 2,  5, '2026-10-01 10:05:00'),
(2, 27, 1, '2026-10-02 18:31:00'),
(2, 33, 2, '2026-10-02 18:32:00'),
(2, 20, 3, '2026-10-02 18:33:00'),
(2, 11, 4, '2026-10-02 18:34:00'),
(3, 14, 1, '2026-10-03 09:16:00'),
(3, 20, 2, '2026-10-03 09:17:00'),
(3, 16, 3, '2026-10-03 09:18:00'),
(3, 22, 4, '2026-10-03 09:19:00'),
(3, 18, 5, '2026-10-03 09:20:00'),
(4, 25, 1, '2026-10-04 20:01:00'),
(4, 28, 2, '2026-10-04 20:02:00'),
(4, 23, 3, '2026-10-04 20:03:00'),
(4, 27, 4, '2026-10-04 20:04:00'),
(5, 35, 1, '2026-10-05 21:46:00'),
(5, 7,  2, '2026-10-05 21:47:00'),
(5, 24, 3, '2026-10-05 21:48:00'),
(5, 21, 4, '2026-10-05 21:49:00'),
(6, 37, 1, '2026-10-06 07:31:00'),
(6, 20, 2, '2026-10-06 07:32:00'),
(6, 5,  3, '2026-10-06 07:33:00'),
(6, 30, 4, '2026-10-06 07:34:00'),
(6, 13, 5, '2026-10-06 07:35:00');

INSERT INTO listening_history (user_id, track_id, played_at) VALUES
-- 1 Nov
(1, 3,  '2026-11-01 08:00:00'),
(1, 5,  '2026-11-01 08:05:00'),
(1, 10, '2026-11-01 08:09:00'),
(1, 3,  '2026-11-01 08:17:00'),
(2, 14, '2026-11-01 09:00:00'),
(2, 20, '2026-11-01 09:04:00'),
(2, 16, '2026-11-01 09:08:00'),
(2, 20, '2026-11-01 09:12:00'),
(3, 25, '2026-11-01 19:00:00'),
(3, 28, '2026-11-01 19:05:00'),
(3, 27, '2026-11-01 19:08:00'),
-- 2 Nov
(5, 37, '2026-11-02 07:30:00'),
(5, 20, '2026-11-02 07:37:00'),
(5, 5,  '2026-11-02 07:41:00'),
(1, 2,  '2026-11-02 08:10:00'),
(1, 3,  '2026-11-02 08:16:00'),
(1, 8,  '2026-11-02 08:21:00'),
(1, 12, '2026-11-02 08:25:00'),
(4, 35, '2026-11-02 21:00:00'),
(4, 7,  '2026-11-02 21:06:00'),
(4, 24, '2026-11-02 21:10:00'),
(4, 21, '2026-11-02 21:15:00'),
-- 3 Nov
(2, 14, '2026-11-03 10:00:00'),
(2, 18, '2026-11-03 10:04:00'),
(2, 22, '2026-11-03 10:08:00'),
(2, 20, '2026-11-03 10:12:00'),
(2, 14, '2026-11-03 10:16:00'),
(3, 27, '2026-11-03 18:30:00'),
(3, 31, '2026-11-03 18:34:00'),
(3, 32, '2026-11-03 18:41:00'),
(3, 25, '2026-11-03 18:46:00'),
(1, 10, '2026-11-03 22:00:00'),
(1, 9,  '2026-11-03 22:08:00'),
-- 4 Nov
(5, 20, '2026-11-04 08:00:00'),
(5, 30, '2026-11-04 08:04:00'),
(5, 13, '2026-11-04 08:08:00'),
(5, 37, '2026-11-04 08:12:00'),
(2, 16, '2026-11-04 12:00:00'),
(2, 17, '2026-11-04 12:04:00'),
(2, 20, '2026-11-04 12:08:00'),
(4, 21, '2026-11-04 20:00:00'),
(4, 7,  '2026-11-04 20:04:00'),
(4, 3,  '2026-11-04 20:08:00'),
-- 5 Nov
(1, 3,  '2026-11-05 08:00:00'),
(1, 5,  '2026-11-05 08:05:00'),
(1, 6,  '2026-11-05 08:09:00'),
(1, 11, '2026-11-05 08:14:00'),
(5, 35, '2026-11-05 18:00:00'),
(5, 36, '2026-11-05 18:06:00'),
(3, 33, '2026-11-05 19:00:00'),
(3, 28, '2026-11-05 19:05:00'),
(3, 29, '2026-11-05 19:08:00'),
(3, 25, '2026-11-05 19:12:00'),
-- 6 Nov
(2, 20, '2026-11-06 09:30:00'),
(2, 19, '2026-11-06 09:34:00'),
(2, 14, '2026-11-06 09:38:00'),
(2, 15, '2026-11-06 09:42:00'),
(4, 24, '2026-11-06 21:30:00'),
(4, 26, '2026-11-06 21:35:00'),
(4, 7,  '2026-11-06 21:40:00'),
(4, 21, '2026-11-06 21:44:00'),
(1, 2,  '2026-11-06 23:00:00'),
(1, 3,  '2026-11-06 23:06:00'),
-- 7 Nov
(5, 37, '2026-11-07 10:00:00'),
(5, 20, '2026-11-07 10:06:00'),
(5, 34, '2026-11-07 10:10:00'),
(5, 5,  '2026-11-07 10:15:00'),
(2, 22, '2026-11-07 11:00:00'),
(2, 14, '2026-11-07 11:04:00'),
(2, 18, '2026-11-07 11:08:00'),
(3, 27, '2026-11-07 17:00:00'),
(3, 25, '2026-11-07 17:03:00'),
(3, 23, '2026-11-07 17:08:00'),
(3, 31, '2026-11-07 17:12:00'),
(1, 10, '2026-11-07 20:00:00'),
(1, 12, '2026-11-07 20:08:00'),
(1, 8,  '2026-11-07 20:14:00');
 
SELECT 'artists' AS table_name, COUNT(*) AS total_rows FROM artists
UNION ALL SELECT 'genres',            COUNT(*) FROM genres
UNION ALL SELECT 'albums',            COUNT(*) FROM albums
UNION ALL SELECT 'tracks',            COUNT(*) FROM tracks
UNION ALL SELECT 'users',             COUNT(*) FROM users
UNION ALL SELECT 'playlists',         COUNT(*) FROM playlists
UNION ALL SELECT 'playlist_tracks',   COUNT(*) FROM playlist_tracks
UNION ALL SELECT 'listening_history', COUNT(*) FROM listening_history;

SELECT * FROM artists;
SELECT * FROM genres;
SELECT * FROM albums;
SELECT * FROM tracks;
SELECT * FROM users;
SELECT * FROM playlists;
SELECT * FROM playlist_tracks;
SELECT * FROM listening_history;

SELECT t.track_id, t.title
FROM tracks t
LEFT JOIN albums a ON a.album_id = t.album_id
WHERE a.album_id IS NULL;

INSERT INTO artists (artist_name, country, debut_year)
VALUES ('Dua Lipa', 'England', 2015);
SET @new_artist_id = LAST_INSERT_ID();
INSERT INTO albums (album_title, artist_id, release_year)
VALUES ('Future Nostalgia', @new_artist_id, 2020);
 
SET @new_album_id = LAST_INSERT_ID();
 
INSERT INTO tracks (title, album_id, genre_id, track_number, duration_seconds)
VALUES ('Levitating', @new_album_id,
        (SELECT genre_id FROM genres WHERE genre_name = 'Pop'),
        5, 204);
 
SET @new_track_id = LAST_INSERT_ID();
SELECT @new_artist_id AS new_artist_id,
       @new_album_id  AS new_album_id,
       @new_track_id  AS new_track_id;
SELECT t.track_id, t.title, al.album_title, ar.artist_name, ar.country,
       t.duration_seconds
FROM tracks t
JOIN albums  al ON al.album_id  = t.album_id
JOIN artists ar ON ar.artist_id = al.artist_id
WHERE t.track_id = @new_track_id;

UPDATE artists
SET country = 'United Kingdom'
WHERE artist_id = @new_artist_id;

UPDATE tracks
SET duration_seconds = 203
WHERE track_id = @new_track_id;

SELECT t.title, ar.artist_name, ar.country, t.duration_seconds
FROM tracks t
JOIN albums  al ON al.album_id  = t.album_id
JOIN artists ar ON ar.artist_id = al.artist_id
WHERE t.track_id = @new_track_id;

DELETE FROM artists WHERE artist_id = @new_artist_id;
DELETE FROM tracks  WHERE track_id  = @new_track_id;   -- child of album
DELETE FROM albums  WHERE album_id  = @new_album_id;   -- child of artist
DELETE FROM artists WHERE artist_id = @new_artist_id;  -- now allowed

SELECT * FROM artists WHERE artist_name = 'Dua Lipa';
DELETE FROM tracks WHERE track_id = 20;

SELECT track_id, title
FROM tracks
WHERE title LIKE '%dil%';

SELECT t.title, al.album_title, ar.artist_name
FROM tracks t
JOIN albums  al ON al.album_id  = t.album_id
JOIN artists ar ON ar.artist_id = al.artist_id
WHERE ar.artist_name = 'Taylor Swift'
ORDER BY t.title;

SELECT t.title, ar.artist_name
FROM tracks t
JOIN albums  al ON al.album_id  = t.album_id
JOIN artists ar ON ar.artist_id = al.artist_id
WHERE ar.artist_name LIKE '%punk%';

SELECT t.title, g.genre_name, ar.artist_name
FROM tracks t
JOIN genres  g  ON g.genre_id   = t.genre_id
JOIN albums  al ON al.album_id  = t.album_id
JOIN artists ar ON ar.artist_id = al.artist_id
WHERE g.genre_name = 'Rock'
ORDER BY ar.artist_name, t.title;

SELECT t.track_number, t.title,
       CONCAT(FLOOR(t.duration_seconds / 60), ':',
              LPAD(t.duration_seconds % 60, 2, '0')) AS duration
FROM tracks t
JOIN albums al ON al.album_id = t.album_id
WHERE al.album_title = '1989'
ORDER BY t.track_number;

SELECT g.genre_name, COUNT(t.track_id) AS number_of_tracks
FROM genres g
LEFT JOIN tracks t ON t.genre_id = g.genre_id
GROUP BY g.genre_id, g.genre_name
ORDER BY number_of_tracks DESC;

INSERT INTO playlists (user_id, playlist_name)
VALUES (3, 'Late Night Drive');
 
SET @new_playlist_id = LAST_INSERT_ID();

INSERT INTO playlist_tracks (playlist_id, track_id, position) VALUES
(@new_playlist_id, 20, 1),   -- Blinding Lights
(@new_playlist_id, 37, 2),   -- Get Lucky
(@new_playlist_id, 25, 3);   -- Yellow

INSERT INTO playlist_tracks (playlist_id, track_id, position)
SELECT @new_playlist_id, 35, COALESCE(MAX(position), 0) + 1
FROM playlist_tracks
WHERE playlist_id = @new_playlist_id;


SELECT p.playlist_name, u.username, pt.position, t.title, ar.artist_name
FROM playlist_tracks pt
JOIN playlists p  ON p.playlist_id = pt.playlist_id
JOIN users     u  ON u.user_id     = p.user_id
JOIN tracks    t  ON t.track_id    = pt.track_id
JOIN albums    al ON al.album_id   = t.album_id
JOIN artists   ar ON ar.artist_id  = al.artist_id
WHERE pt.playlist_id = @new_playlist_id
ORDER BY pt.position;

DELETE FROM playlist_tracks
WHERE playlist_id = @new_playlist_id AND track_id = 37;

SELECT pt.position, t.title
FROM playlist_tracks pt
JOIN tracks t ON t.track_id = pt.track_id
WHERE pt.playlist_id = @new_playlist_id
ORDER BY pt.position;

INSERT INTO playlist_tracks (playlist_id, track_id, position)
VALUES (@new_playlist_id, 20, 9);

SELECT p.playlist_id, p.playlist_name, u.username,
       COUNT(pt.track_id) AS number_of_songs
FROM playlists p
JOIN users u ON u.user_id = p.user_id
LEFT JOIN playlist_tracks pt ON pt.playlist_id = p.playlist_id
GROUP BY p.playlist_id, p.playlist_name, u.username
ORDER BY p.playlist_id;

SELECT t.title, ar.artist_name, COUNT(*) AS play_count
FROM listening_history lh
JOIN tracks  t  ON t.track_id   = lh.track_id
JOIN albums  al ON al.album_id  = t.album_id
JOIN artists ar ON ar.artist_id = al.artist_id
GROUP BY t.track_id, t.title, ar.artist_name
ORDER BY play_count DESC, t.title
LIMIT 5;

SELECT ar.artist_name, COUNT(*) AS total_plays
FROM listening_history lh
JOIN tracks  t  ON t.track_id   = lh.track_id
JOIN albums  al ON al.album_id  = t.album_id
JOIN artists ar ON ar.artist_id = al.artist_id
GROUP BY ar.artist_id, ar.artist_name
HAVING COUNT(*) >= 5
ORDER BY total_plays DESC;

SELECT u.username, g.genre_name, COUNT(*) AS plays
FROM listening_history lh
JOIN users  u ON u.user_id  = lh.user_id
JOIN tracks t ON t.track_id = lh.track_id
JOIN genres g ON g.genre_id = t.genre_id
GROUP BY u.user_id, u.username, g.genre_id, g.genre_name
ORDER BY u.username, plays DESC;

SELECT x.username, x.genre_name AS favourite_genre, x.plays
FROM (
    SELECT u.user_id, u.username, g.genre_name, COUNT(*) AS plays
    FROM listening_history lh
    JOIN users  u ON u.user_id  = lh.user_id
    JOIN tracks t ON t.track_id = lh.track_id
    JOIN genres g ON g.genre_id = t.genre_id
    GROUP BY u.user_id, u.username, g.genre_id, g.genre_name
) AS x
WHERE x.plays = (
    SELECT MAX(y.plays)
    FROM (
        SELECT lh2.user_id, t2.genre_id, COUNT(*) AS plays
        FROM listening_history lh2
        JOIN tracks t2 ON t2.track_id = lh2.track_id
        GROUP BY lh2.user_id, t2.genre_id
    ) AS y
    WHERE y.user_id = x.user_id
)
ORDER BY x.username;

SELECT u.username, COUNT(*) AS total_plays
FROM listening_history lh
JOIN users u ON u.user_id = lh.user_id
GROUP BY u.user_id, u.username
HAVING COUNT(*) > (
    SELECT AVG(plays_per_user)
    FROM (SELECT COUNT(*) AS plays_per_user
          FROM listening_history
          GROUP BY user_id) AS per_user
)
ORDER BY total_plays DESC;

SELECT t.title, al.album_title
FROM tracks t
JOIN albums al ON al.album_id = t.album_id
LEFT JOIN listening_history lh ON lh.track_id = t.track_id
WHERE lh.history_id IS NULL
ORDER BY al.album_title, t.title;

ALTER TABLE tracks  ADD FULLTEXT INDEX ft_tracks_title (title);
ALTER TABLE artists ADD FULLTEXT INDEX ft_artists_name (artist_name);

SELECT track_id, title,
       MATCH(title) AGAINST ('dil' IN NATURAL LANGUAGE MODE) AS relevance
FROM tracks
WHERE MATCH(title) AGAINST ('dil' IN NATURAL LANGUAGE MODE);

SELECT track_id, title
FROM tracks
WHERE MATCH(title) AGAINST ('+blinding +lights' IN BOOLEAN MODE);
SELECT artist_id, artist_name
FROM artists
WHERE MATCH(artist_name) AGAINST ('punk' IN NATURAL LANGUAGE MODE);
SHOW CREATE TABLE artists;

SELECT t.title, ar.artist_name
FROM tracks t
JOIN albums  al ON al.album_id  = t.album_id
JOIN artists ar ON ar.artist_id = al.artist_id
WHERE MATCH(t.title)        AGAINST ('dil'    IN NATURAL LANGUAGE MODE)
   OR MATCH(ar.artist_name) AGAINST ('rahman' IN NATURAL LANGUAGE MODE);
SHOW VARIABLES LIKE 'innodb_ft_min_token_size';

CREATE UNIQUE INDEX idx_playlist_position
    ON playlist_tracks (playlist_id, position);
 
SHOW INDEX FROM playlist_tracks;
EXPLAIN
SELECT track_id, position
FROM playlist_tracks
WHERE playlist_id = 3
ORDER BY position;
 
EXPLAIN
SELECT playlist_id, track_id
FROM playlist_tracks
WHERE position = 1;
CREATE INDEX idx_tracks_title ON tracks (title);
 
SHOW INDEX FROM tracks;
EXPLAIN SELECT * FROM tracks WHERE title LIKE '%dil%';
EXPLAIN SELECT * FROM tracks WHERE title LIKE 'Bad%';
EXPLAIN SELECT * FROM tracks WHERE MATCH(title) AGAINST ('dil');

CREATE VIEW vw_track_details AS
SELECT t.track_id,
       t.title           AS track_title,
       ar.artist_name,
       al.album_title,
       al.release_year,
       g.genre_name,
       t.track_number,
       t.duration_seconds,
       CONCAT(FLOOR(t.duration_seconds / 60), ':',
              LPAD(t.duration_seconds % 60, 2, '0')) AS duration
FROM tracks  t
JOIN albums  al ON al.album_id  = t.album_id
JOIN artists ar ON ar.artist_id = al.artist_id
JOIN genres  g  ON g.genre_id   = t.genre_id;
 
SELECT * FROM vw_track_details;

SELECT track_title, album_title, duration
FROM vw_track_details
WHERE artist_name = 'Taylor Swift';
 
SELECT track_title, artist_name
FROM vw_track_details
WHERE genre_name = 'Bollywood';
 
SELECT track_title, artist_name, album_title
FROM vw_track_details
WHERE track_title LIKE '%dil%';

CREATE VIEW vw_top_artists AS
SELECT ar.artist_id,
       ar.artist_name,
       COUNT(lh.history_id)       AS total_plays,
       COUNT(DISTINCT lh.user_id) AS unique_listeners
FROM artists ar
LEFT JOIN albums            al ON al.artist_id = ar.artist_id
LEFT JOIN tracks            t  ON t.album_id   = al.album_id
LEFT JOIN listening_history lh ON lh.track_id  = t.track_id
GROUP BY ar.artist_id, ar.artist_name;
 
SELECT * FROM vw_top_artists
ORDER BY total_plays DESC
LIMIT 5;

UPDATE tracks SET duration_seconds = 270 WHERE track_id = 25;
SELECT track_title, duration_seconds FROM vw_track_details WHERE track_id = 25;
UPDATE tracks SET duration_seconds = 269 WHERE track_id = 25;   -- restore

ALTER TABLE tracks ADD COLUMN is_explicit BOOLEAN NOT NULL DEFAULT FALSE;
SELECT * FROM vw_track_details LIMIT 3;           -- no is_explicit column
ALTER TABLE tracks DROP COLUMN is_explicit;       -- restore the design

ALTER TABLE albums RENAME COLUMN album_title TO album_name;
SELECT * FROM vw_track_details;
CHECK TABLE vw_track_details;

ALTER TABLE albums RENAME COLUMN album_name TO album_title;
SELECT * FROM vw_track_details LIMIT 3;

SHOW CREATE VIEW vw_top_artists;
SHOW FULL TABLES WHERE Table_type = 'VIEW';

WITH track_plays AS (
    SELECT g.genre_name, t.track_id, t.title, COUNT(*) AS play_count
    FROM listening_history lh
    JOIN tracks t ON t.track_id = lh.track_id
    JOIN genres g ON g.genre_id = t.genre_id
    GROUP BY g.genre_name, t.track_id, t.title
),
ranked AS (
    SELECT genre_name, title, play_count,
           DENSE_RANK() OVER (PARTITION BY genre_name
                              ORDER BY play_count DESC) AS genre_rank
    FROM track_plays
)
SELECT genre_name, genre_rank, title, play_count
FROM ranked
WHERE genre_rank <= 5
ORDER BY genre_name, genre_rank, title;

SELECT u.username,
       lh.played_at,
       t.title AS current_track,
       LEAD(t.title) OVER (PARTITION BY lh.user_id
                           ORDER BY lh.played_at, lh.history_id) AS next_track,
       LEAD(lh.played_at) OVER (PARTITION BY lh.user_id
                                ORDER BY lh.played_at, lh.history_id) AS next_played_at
FROM listening_history lh
JOIN users  u ON u.user_id  = lh.user_id
JOIN tracks t ON t.track_id = lh.track_id
WHERE lh.user_id = 1
ORDER BY lh.played_at, lh.history_id;

WITH daily AS (
    SELECT DATE(played_at) AS play_date, COUNT(*) AS plays_that_day
    FROM listening_history
    GROUP BY DATE(played_at)
)
SELECT play_date,
       plays_that_day,
       SUM(plays_that_day) OVER (ORDER BY play_date
                                 ROWS BETWEEN UNBOUNDED PRECEDING
                                          AND CURRENT ROW) AS running_total
FROM daily
ORDER BY play_date;

WITH daily_user AS (
    SELECT user_id, DATE(played_at) AS play_date, COUNT(*) AS plays_that_day
    FROM listening_history
    GROUP BY user_id, DATE(played_at)
)
SELECT u.username, d.play_date, d.plays_that_day,
       SUM(d.plays_that_day) OVER (PARTITION BY d.user_id
                                   ORDER BY d.play_date
                                   ROWS BETWEEN UNBOUNDED PRECEDING
                                            AND CURRENT ROW) AS user_running_total
FROM daily_user d
JOIN users u ON u.user_id = d.user_id
ORDER BY u.username, d.play_date;

WITH track_plays AS (
    SELECT al.album_id, al.album_title, t.track_id, t.title,
           COUNT(lh.history_id) AS track_plays
    FROM tracks t
    JOIN albums al ON al.album_id = t.album_id
    LEFT JOIN listening_history lh ON lh.track_id = t.track_id
    GROUP BY al.album_id, al.album_title, t.track_id, t.title
)
SELECT album_title,
       title,
       track_plays,
       SUM(track_plays) OVER (PARTITION BY album_id) AS album_total_plays,
       ROUND(100 * track_plays
             / NULLIF(SUM(track_plays) OVER (PARTITION BY album_id), 0), 2)
             AS pct_of_album_plays
FROM track_plays
ORDER BY album_title, pct_of_album_plays DESC, title;
SHOW DATABASES;
SELECT DATABASE();