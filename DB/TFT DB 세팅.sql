/*
node "D:\git\CommunitySearch\bin\hyeonyeong\tft-server\server.js"
node "C:\Users\loden\Desktop\DevHub\CommunitySearch\DB\tft-server/server.js"
*/

-- DROP DATABASE IF EXISTS tft;
CREATE DATABASE tft;
USE tft;

CREATE TABLE tft_players (
    id INT AUTO_INCREMENT PRIMARY KEY,
    puuid VARCHAR(100) NOT NULL,      -- puuid
    name VARCHAR(40),         -- 소환사 이름
    tagline VARCHAR(10),      -- 소환사 태그
    game_date DATE,                   -- 날짜
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_bot BOOLEAN GENERATED ALWAYS AS (puuid LIKE 'BOT%') STORED,  -- BOT으로 시작하면 자동으로 TRUE
    INDEX idx_puuid (puuid)
);

-- 기존 트리거 삭제 및 조건부 유니크 인덱스 추가
DROP TRIGGER IF EXISTS before_insert_tft_players;

ALTER TABLE tft_players
ADD UNIQUE INDEX idx_non_bot_puuid ((CASE 
    WHEN puuid NOT LIKE 'BOT%' THEN puuid 
    ELSE NULL 
END));

CREATE TABLE tft_matches (
  id INT AUTO_INCREMENT PRIMARY KEY,
  match_id VARCHAR(40) NOT NULL,  -- match_id 컬럼 추가
  puuid VARCHAR(100) NOT NULL,    -- puuid 컬럼 추가
  placement INT,				  -- 등수
  level INT,					  -- 레벨
  gold_left INT,			      -- 마지막에 남은 골드
  last_round INT,				  -- 탈락 라운드
  players_eliminated INT,		  -- 죽인 플레이어 수
  time_eliminated INT,			  -- 탈락 시간
  total_damage_to_players INT,    -- 가한 총 데미지
  game_length FLOAT,              -- 게임 진행 시간
  companion TEXT,                 -- 꼬마 전설이 정보
  traits TEXT,					  -- 시너지
  units TEXT,					  -- 유닛
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (puuid) REFERENCES tft_players(puuid),
  UNIQUE KEY unique_match_player (match_id, puuid),
  INDEX idx_match_id (match_id),
  INDEX idx_puuid (puuid),
  INDEX idx_created_at (created_at)
);
CREATE TABLE tft_rank (
    id INT AUTO_INCREMENT PRIMARY KEY,
    puuid VARCHAR(100) NOT NULL,
    tier VARCHAR(20),
    rank_division VARCHAR(10),
    league_points INT,
    wins INT,
    losses INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_player (puuid)
);
CREATE TABLE tft_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    match_id VARCHAR(40),
    puuid VARCHAR(100),
    unit_index INT,
    unit_name VARCHAR(50),
    item_name VARCHAR(100),
    FOREIGN KEY (match_id, puuid) REFERENCES tft_matches(match_id, puuid)
);

-- 매치 조회
USE tft;
SELECT * FROM tft_players ORDER BY created_at DESC LIMIT 1000;
SELECT * FROM tft_matches ORDER BY created_at DESC LIMIT 1000;
SELECT * FROM tft_items ORDER BY id DESC LIMIT 500;

-- 특정 유닛이 주로 사용하는 아이템 통계
SELECT unit_name, item_name, COUNT(*) as count
FROM tft_items
GROUP BY unit_name, item_name
ORDER BY count DESC LIMIT 10;

-- 가장 많이 사용된 아이템 통계
SELECT item_name, COUNT(*) as use_count 
FROM tft_items 
GROUP BY item_name 
ORDER BY use_count DESC 
LIMIT 10;

-- 티어 등록된 유저 확인
SELECT r.id, p.name, p.tagline, r.tier, r.rank_division, r.league_points, r.wins, r.losses, r.created_at, r.updated_at 
FROM tft_rank r 
LEFT JOIN tft_players p ON r.puuid = p.puuid 
ORDER BY r.id LIMIT 100;

-- 집계된 유저 수
SELECT COUNT(DISTINCT puuid) as total_players
FROM tft_matches;

-- 집계돤 게임 수
SELECT COUNT(DISTINCT match_id) as total_matches
FROM tft_matches;

-- 라운드별 탈락 분포 분석
SELECT last_round, COUNT(*)
FROM tft_matches 
GROUP BY last_round 
ORDER BY COUNT(*) DESC;

-- 유저들의 모스트 5픽
SELECT 
    SUBSTRING_INDEX(SUBSTRING_INDEX(units, '"character_id":"', -1), '"', 1) as champion,
    COUNT(*) as pick_count
FROM tft_matches
GROUP BY champion
ORDER BY pick_count DESC
LIMIT 5;

-- 특정 유닛 판수
SELECT COUNT(*) as unit_games
FROM tft_matches
WHERE units LIKE '%TFT14_Kobuko%';

-- 그 유닛이 포함 될 때의 평균 등수
SELECT AVG(placement) as average_placement
FROM tft_matches
WHERE units LIKE '%TFT14_Kobuko%';

-- 1등이 가장 많았던 유닛 찾기
SELECT 
    SUBSTRING_INDEX(SUBSTRING_INDEX(units, 'TFT14_', -1), '"', 1) as champion,
    COUNT(*) as count_in_first_place
FROM tft_matches
WHERE placement = 1
    AND units LIKE '%TFT14_%'
GROUP BY champion
ORDER BY count_in_first_place DESC
LIMIT 5;

-- 1등이 가장 많았던 시너지
SELECT 
    SUBSTRING_INDEX(SUBSTRING_INDEX(traits, '"name":"', -1), '"', 1) as trait_name,
    COUNT(*) as count_in_first_place
FROM tft_matches
WHERE placement = 1
    AND traits LIKE '%name%'
GROUP BY trait_name
ORDER BY count_in_first_place DESC
LIMIT 5;

-- BOT의 평균 등수
SELECT 
    ROUND(AVG(m.placement), 2) as avg_placement,
    COUNT(*) as total_bot_appearances,
    COUNT(DISTINCT m.match_id) as total_games_with_bots,
    ROUND(COUNT(*) / COUNT(DISTINCT m.match_id), 2) as avg_bots_per_game
FROM tft_matches m
WHERE m.puuid LIKE 'BOT%';

-- BOT이 주로 사용하는 아이템 TOP 10
SELECT 
    i.item_name,
    COUNT(*) as use_count,
    COUNT(DISTINCT i.match_id) as games_used,
    ROUND(AVG(m.placement), 2) as avg_placement_with_item
FROM tft_items i
JOIN tft_matches m ON i.match_id = m.match_id AND i.puuid = m.puuid
WHERE i.puuid LIKE 'BOT%'
GROUP BY i.item_name
ORDER BY use_count DESC
LIMIT 10;

-- BOT의 라운드별 탈락 분포
SELECT 
    last_round,
    COUNT(*) as elimination_count,
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM tft_matches WHERE puuid LIKE 'BOT%'), 2) as percentage,
    ROUND(AVG(placement), 2) as avg_placement
FROM tft_matches
WHERE puuid LIKE 'BOT%'
GROUP BY last_round
ORDER BY last_round ASC;

-- BOT들의 정보 확인
SELECT DISTINCT puuid, name, tagline 
FROM tft_players 
WHERE puuid LIKE 'BOT%';

-- BOT 플레이어 목록과 각각의 통계
SELECT 
    p.puuid,
    p.name,
    COUNT(*) as games_played,
    ROUND(AVG(m.placement), 2) as avg_placement,
    MIN(m.placement) as best_placement,
    MAX(m.placement) as worst_placement
FROM tft_players p
JOIN tft_matches m ON p.puuid = m.puuid
WHERE p.puuid LIKE 'BOT%'
GROUP BY p.puuid, p.name
ORDER BY avg_placement ASC;

-- BOT들의 전체 평균 등수
SELECT 
    COUNT(DISTINCT p.puuid) as total_bots,
    COUNT(*) as total_bot_games,
    ROUND(AVG(m.placement), 2) as overall_avg_placement
FROM tft_players p
JOIN tft_matches m ON p.puuid = m.puuid
WHERE p.puuid LIKE 'BOT%';

-- BOT이 주로 사용하는 유닛 TOP 10 (수정된 통계)
WITH RECURSIVE numbers AS (
    SELECT 0 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 50
),
unit_data AS (
    SELECT 
        m.match_id,
        m.puuid,
        m.placement,
        JSON_EXTRACT(
            JSON_EXTRACT(units, CONCAT('$[', n, ']')),
            '$.character_id'
        ) as character_id,
        JSON_EXTRACT(
            JSON_EXTRACT(units, CONCAT('$[', n, ']')),
            '$.tier'
        ) as tier,
        JSON_EXTRACT(
            JSON_EXTRACT(units, CONCAT('$[', n, ']')),
            '$.rarity'
        ) as rarity
    FROM tft_matches m
    CROSS JOIN numbers n
    WHERE m.puuid LIKE 'BOT%'
    AND JSON_EXTRACT(units, CONCAT('$[', n, ']')) IS NOT NULL
)
SELECT 
    REPLACE(REPLACE(character_id, '"', ''), 'TFT14_', '') as champion,
    COUNT(*) as pick_count,
    ROUND(AVG(placement), 2) as avg_placement,
    ROUND(AVG(tier), 2) as avg_tier,
    ROUND(AVG(rarity), 2) as avg_rarity,
    ROUND((COUNT(*) * 100.0) / (
        SELECT COUNT(*) FROM tft_matches WHERE puuid LIKE 'BOT%'
    ), 2) as pick_rate
FROM unit_data
WHERE character_id IS NOT NULL
GROUP BY character_id
ORDER BY pick_count DESC, avg_placement ASC
LIMIT 10;

-- BOT이 주로 사용하는 시너지 TOP 10
SELECT 
    SUBSTRING_INDEX(SUBSTRING_INDEX(traits, '"name":"', -1), '"', 1) as trait_name,
    COUNT(*) as use_count,
    ROUND(AVG(placement), 2) as avg_placement,
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM tft_matches WHERE puuid LIKE 'BOT%'), 2) as usage_rate,
    ROUND(AVG(CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(traits, '"tier_current":', -1), ',', 1) AS SIGNED)), 1) as avg_tier
FROM tft_matches
WHERE puuid LIKE 'BOT%'
    AND traits LIKE '%name%'
GROUP BY trait_name
ORDER BY use_count DESC
LIMIT 10;

-- BOT 매치들의 실제 데이터 확인
SELECT 
    m.match_id,
    m.puuid,
    m.placement,
    m.units as raw_units,
    JSON_LENGTH(m.units) as unit_count,
    p.name
FROM tft_matches m
JOIN tft_players p ON m.puuid = p.puuid
WHERE p.is_bot = true
ORDER BY m.match_id, m.placement;