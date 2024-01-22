CREATE SCHEMA Spotify;
use Spotify;

CREATE TABLE Spotify_Songs (
track_name varchar(50),	
artist_name	varchar(50),
artist_count INTEGER,	
released_year INTEGER,
released_month INTEGER,
released_day INTEGER,
in_spotify_playlists INTEGER,
in_spotify_charts INTEGER,
streams	INTEGER,
in_apple_playlists INTEGER,
in_apple_charts	INTEGER,
in_deezer_playlists	INTEGER,
in_deezer_charts INTEGER, 
in_shazam_charts INTEGER,	
bpm	INTEGER,
keyy VARCHAR(2),
modee VARCHAR(7),
danceability INTEGER,
valence INTEGER,
energy INTEGER,
acousticness INTEGER,
instrumentalness INTEGER,
liveness INTEGER,
speechiness INTEGER
);

select * from Spotify_songs;

-- 1-Retrieve the names of all tracks released in the year 2021.
select track_name as Tracks, released_year as Year from Spotify_Songs where released_year = 2021;

-- 2-Find the total number of streams for all tracks in the dataset.
select sum(streams) as Total_Streams_All_Tracks from Spotify_Songs;

-- 3-List the distinct musical keys present in the dataset.
select distinct(keyy) from spotify_songs;

-- 4-Count the number of tracks that are present in Spotify playlists.
select count(track_name) from spotify_songs where in_spotify_playlists !=0;

-- 5-Find the tracks with the highest danceability percentage.
select track_name from spotify_songs where danceability = (select max(danceability) from spotify_songs);

-- 1-Calculate the average energy percentage for tracks released in 2020.
select avg(energy) from spotify_songs where released_year = 2020;

-- 2-Identify the top 5 artists with the most tracks in Spotify charts.
with top_artists as (select artist_name, dense_rank() over (order by in_spotify_charts desc) as rank_charts from Spotify_songs) select artist_name as Artist from top_artists where rank_charts <= 5;

-- 3-List the tracks with the highest instrumentalness percentage.
select track_name as Track, Instrumentalness from spotify_songs where instrumentalness = (select max(instrumentalness) from spotify_songs);

-- 4-Find the total number of streams for tracks in both Spotify and Apple Music playlists.
select sum(in_spotify_playlists) as Streams_Spotify_Playlists, sum(in_apple_playlists) as Streams_Apple_Playlists from Spotify_songs;

-- 5-Retrieve the tracks released in the month of May.
select track_name as Track from Spotify_songs where released_month = 5;

-- 1-Identify the artist(s) with the highest average valence percentage.
select artist_name as Artist, Valence from spotify_songs where valence = (select max(valence) from spotify_songs);

-- 2-List the top 10 tracks with the most streams in Spotify charts.
with Track_Stream as (select track_name, dense_rank() over (order by in_spotify_charts desc) as Rank_List from Spotify_songs)
select track_name as Track from Track_Stream where Rank_List <= 10;

-- 3-Find the tracks with danceability percentage above 80% and energy percentage below 60%.
select track_name as Tracks, Danceability, Energy from spotify_songs where danceability > 80 and energy < 60;

-- 4-Calculate the average acousticness percentage for tracks in Deezer charts.
select avg(acousticness) from spotify_songs where in_deezer_charts != 0;

-- 5-Retrieve the tracks released on a weekend (Saturday or Sunday).
with cte as (SELECT track_name, CONCAT(released_year, '-' ,released_month,'-',released_day) AS Dayy from spotify_songs) select track_name as Track from cte where weekday(dayy) in ('5', '6');


-- 1-Identify the artist(s) with the highest total streams across all their tracks.
with cte as (select artist_name, sum(streams) as Total_Streams from spotify_songs group by artist_name) SELECT artist_name as Artist from cte where total_streams = (SELECT MAX(total_streams) from cte);

-- 2-Find the tracks that are present in both Apple Music and Deezer charts.
select track_name as Track from Spotify_songs where in_apple_charts !=0 and in_deezer_playlists !=0;

-- 3-Calculate the median danceability percentage for all tracks.
SET @row_index := -1;
SELECT AVG(subquery.danceability) AS median_value
FROM (
    SELECT @row_index:=@row_index + 1 AS row_index, danceability    
    FROM Spotify_songs
    ORDER BY danceability
  ) AS subquery
  WHERE subquery.row_index
  IN (FLOOR(@row_index / 2) , CEIL(@row_index / 2));

-- 4-Identify the tracks with the highest liveness percentage in Spotify playlists.
select track_name as track from spotify_songs where in_spotify_playlists != 0 and liveness = (select max(liveness) from spotify_songs);

-- 5-Find the tracks with the highest speechiness percentage in Shazam charts.
select track_name as track from spotify_songs where in_shazam_charts != 0 and speechiness = (select max(speechiness) from spotify_songs);
