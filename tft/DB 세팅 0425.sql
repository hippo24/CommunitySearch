/*
node "D:\git\CommunitySearch\bin\hyeonyeong\tft-server\server.js"
*/

-- DROP DATABASE IF EXISTS tft;
-- CREATE DATABASE tft;
CREATE DATABASE tft;
-- USE tft;

CREATE TABLE tft_players (
  id INT AUTO_INCREMENT PRIMARY KEY,
  puuid VARCHAR(100) NOT NULL,		-- puuid
  name VARCHAR(40),		      		-- 소환사 이름
  tagline VARCHAR(10),  		  	-- 소환사 태그
  game_date DATE,			    	-- 날짜
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_match_user (puuid)
);

CREATE TABLE tft_matches (
  id INT AUTO_INCREMENT PRIMARY KEY,
  match_id VARCHAR(40) NOT NULL,  -- 매치 id
  puuid VARCHAR(100) NOT NULL,    -- puuid
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
  UNIQUE KEY unique_match_player (match_id, puuid)
									  -- name 특성명
									  -- num_units 이 시너지를 가진 유닛 수
									  -- style 시너지의 등급 (0: 없음, 1: 브론즈, 2: 실버, 3: 골드, 4: 크로매틱)
									  -- tier_current 예- 3/5/7단계중에 2단계 = 5
									  -- tier_total 이 시너지의 총 단계 수 3/5/7 = 3
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

CREATE TABLE unit_items (
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
SELECT r.puuid, r.id, p.name, p.tagline, r.tier, r.rank_division, r.league_points, r.wins, r.losses, r.created_at, r.updated_at 
FROM tft_rank r 
LEFT JOIN tft_players p ON r.puuid = p.puuid 
ORDER BY r.id LIMIT 100;

-- 총 유저 세기
SELECT COUNT(DISTINCT puuid) as total_players
FROM tft_matches;

-- 게임수 세기
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

SELECT 
    SUBSTRING_INDEX(SUBSTRING_INDEX(traits, '"name":"', -1), '"', 1) as trait_name,
    COUNT(*) as count_in_first_place
FROM tft_matches
WHERE placement = 1
    AND traits LIKE '%name%'
GROUP BY trait_name
ORDER BY count_in_first_place DESC
LIMIT 5;
