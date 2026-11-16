# Music Library Management System

DBMS Capstone Project – Problem Statement 09  
**Nishika Chaudhary** | Roll No: 2501420057 | B.Tech CSE (Data Science), Section A  
K.R. Mangalam University | Faculty: Dr. Swati Gupta

## About
A relational database for a music library built in MySQL 26.7 using MySQL Workbench.

## Features
- 8 normalised tables: artists, albums, genres, tracks, users, playlists, playlist_tracks, listening_history
- Primary/foreign keys with RESTRICT and CASCADE rules, CHECK, UNIQUE and DEFAULT constraints
- CRUD operations and safe deletion
- Search by title, artist and genre; playlist creation; listening-preference analysis
- FULLTEXT and composite indexes, compared using EXPLAIN
- Views: vw_track_details, vw_top_artists
- Window functions: DENSE_RANK, LEAD, running total, SUM() OVER (PARTITION BY)

## Files
- `music_library.sql` – complete SQL script
- `ER_Diagram.png` – ER diagram
- `Music_Library_Management_System_Report.pdf` – project report with output screenshots
