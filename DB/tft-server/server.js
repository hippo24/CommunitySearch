const express = require("express");
const app = express();

// Riot API 설정
const API_KEY = "RGAPI-9b484120-f042-423e-b0b5-0e3a256de28a";
const RIOT_API = {
  ASIA: "https://asia.api.riotgames.com",
  KOREA: "https://kr.api.riotgames.com"
};

console.log("서버 준비 중...");

app.get("/", (req, res) => {
  res.send("백엔드 정상 작동 중!");
});

app.listen(3001, () => {
  console.log("서버 실행 중: http://localhost:3001");
});

const mysql = require("mysql2/promise");
const cors = require("cors");
const bodyParser = require("body-parser");

app.use(cors());
app.use(bodyParser.json());

const dbConfig = {
  host: "localhost",
  user: "root",
  password: "root",
  database: "riot",
};

let db;
mysql.createConnection(dbConfig).then((connection) => {
  db = connection;
  console.log("✅ MySQL 연결 완료");
});

// POST 요청으로 DB 저장
app.post("/api/save-match", async (req, res) => {
  const {
    match_id,
    puuid,
    riot_id_name,
    riot_id_tagline,
    placement,
    level,
    gold_left,
    last_round,
    players_eliminated,
    time_eliminated,
    total_damage_to_players,
    game_length,
    companion,
    traits,
    units,
    game_date,
  } = req.body;

  try {
    // 1. tft_players 테이블에 저장
    await db.query(
      `INSERT INTO tft_players 
      (puuid, riot_id_name, riot_id_tagline, game_date)
      VALUES (?, ?, ?, ?)
      ON DUPLICATE KEY UPDATE
      riot_id_name = VALUES(riot_id_name),
      riot_id_tagline = VALUES(riot_id_tagline),
      game_date = VALUES(game_date)`,
      [puuid, riot_id_name, riot_id_tagline, game_date]
    );

    // 2. tft_matches 테이블에 저장
    await db.query(
      `INSERT IGNORE INTO tft_matches 
      (match_id, puuid, placement, level, gold_left, last_round, 
       players_eliminated, time_eliminated, total_damage_to_players,
       game_length, companion, traits, units)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        match_id,
        puuid,
        placement,
        level,
        gold_left,
        last_round,
        players_eliminated,
        time_eliminated,
        total_damage_to_players,
        game_length,
        companion,
        typeof traits === 'string' ? traits : JSON.stringify(traits),
        units
      ]
    );

    res.json({ message: "✅ 저장 성공" });
  } catch (err) {
    console.error("❌ 저장 실패:", err);
    res.status(500).json({ message: "DB 오류" });
  }
});

// 랭크 정보를 저장하는 새로운 엔드포인트
app.post("/api/save-rank", async (req, res) => {
  const {
    puuid,
    tier,
    rank_division,
    league_points,
    wins,
    losses
  } = req.body;

  try {
    await db.query(
      `INSERT INTO tft_rank 
      (puuid, tier, rank_division, league_points, wins, losses)
      VALUES (?, ?, ?, ?, ?, ?)
      ON DUPLICATE KEY UPDATE
      tier = VALUES(tier),
      rank_division = NULLIF(VALUES(rank_division), ''),
      league_points = COALESCE(VALUES(league_points), 0),
      wins = COALESCE(VALUES(wins), 0),
      losses = COALESCE(VALUES(losses), 0)`,
      [puuid, tier, rank_division || null, league_points || 0, wins || 0, losses || 0]
    );

    res.json({ message: "✅ 랭크 정보 저장 성공" });
  } catch (err) {
    console.error("❌ 랭크 정보 저장 실패:", err);
    res.status(500).json({ message: "DB 오류", error: err.message });
  }
});

// 아이템 정보 저장 (기존 두 엔드포인트를 하나로 통합)
app.post("/api/save-unit-item", async (req, res) => {
  const { match_id, puuid, unit_index, unit_name, item_name } = req.body;

  try {
    await db.query(
      `INSERT IGNORE INTO tft_items 
      (match_id, puuid, unit_index, unit_name, item_name)
      VALUES (?, ?, ?, ?, ?)`,
      [match_id, puuid, unit_index, unit_name, item_name]
    );

    res.json({ message: "✅ 유닛 아이템 정보 저장 성공" });
  } catch (err) {
    console.error("❌ 유닛 아이템 정보 저장 실패:", err);
    res.status(500).json({ message: "DB 오류" });
  }
});

// BOT 매치 정보 저장
app.post("/api/save-bot-match", async (req, res) => {
  const {
    match_id,
    puuid,
    placement,
    level,
    gold_left,
    last_round,
    players_eliminated,
    time_eliminated,
    total_damage_to_players,
    game_length,
    companion,
    game_date
  } = req.body;

  try {
    await db.query(
      `INSERT IGNORE INTO tft_bot_matches 
      (match_id, puuid, placement, level, gold_left, last_round, 
       players_eliminated, time_eliminated, total_damage_to_players,
       game_length, companion, game_date)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        match_id,
        puuid,
        placement,
        level,
        gold_left,
        last_round,
        players_eliminated,
        time_eliminated,
        total_damage_to_players,
        game_length,
        companion,
        game_date
      ]
    );
    res.json({ message: "✅ BOT 매치 저장 성공" });
  } catch (err) {
    console.error("❌ BOT 매치 저장 실패:", err);
    res.status(500).json({ message: "DB 오류" });
  }
});

// BOT 아이템 정보 저장
app.post("/api/save-bot-item", async (req, res) => {
  const { match_id, puuid, unit_index, unit_name, item_name } = req.body;

  try {
    await db.query(
      `INSERT IGNORE INTO tft_bot_items 
      (match_id, puuid, unit_index, unit_name, item_name)
      VALUES (?, ?, ?, ?, ?)`,
      [match_id, puuid, unit_index, unit_name, item_name]
    );
    res.json({ message: "✅ BOT 아이템 정보 저장 성공" });
  } catch (err) {
    console.error("❌ BOT 아이템 정보 저장 실패:", err);
    res.status(500).json({ message: "DB 오류" });
  }
});

// Rate limiting helper
const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

async function fetchWithRetry(url, options, retries = 3) {
  for (let i = 0; i < retries; i++) {
    try {
      const response = await fetch(url, options);
      
      if (response.status === 429) {
        const retryAfter = response.headers.get('Retry-After') || 10;
        console.log(`Rate limited. Waiting ${retryAfter} seconds...`);
        await sleep(retryAfter * 1000);
        continue;
      }
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      return await response.json();
    } catch (error) {
      if (i === retries - 1) throw error;
      await sleep(1000 * (i + 1)); // Exponential backoff
    }
  }
}

// Replace fetch calls with fetchWithRetry
app.get('/api/summoner/:name/:tag', async (req, res) => {
  try {
    const { name, tag } = req.params;
    const data = await fetchWithRetry(
      `${RIOT_API.ASIA}/riot/account/v1/accounts/by-riot-id/${name}/${tag}`,
      { headers: { 'X-Riot-Token': API_KEY } }
    );
    // ... rest of the code ...
  } catch (error) {
    console.error("❌ 오류:", error);
    res.status(500).json({ message: "Riot API 호출 실패" });
  }
});

app.get('/api/matches/:puuid', async (req, res) => {
  try {
    const { puuid } = req.params;
    const data = await fetchWithRetry(
      `${RIOT_API.ASIA}/tft/match/v1/matches/by-puuid/${puuid}/ids?start=0&count=10`,
      { headers: { 'X-Riot-Token': API_KEY } }
    );
    res.json(data);
  } catch (error) {
    console.error("❌ 오류:", error);
    res.status(500).json({ message: "매치 목록 조회 실패" });
  }
});

app.get('/api/match/:matchId', async (req, res) => {
  try {
    const { matchId } = req.params;
    const data = await fetchWithRetry(
      `${RIOT_API.ASIA}/tft/match/v1/matches/${matchId}`,
      { headers: { 'X-Riot-Token': API_KEY } }
    );
    res.json(data);
  } catch (error) {
    console.error("❌ 오류:", error);
    res.status(500).json({ message: "매치 상세 조회 실패" });
  }
});

// 랭크 정보 조회
app.get('/api/rank/:puuid', async (req, res) => {
  try {
    const { puuid } = req.params;
    
    // 소환사 기본 정보 조회
    const accountData = await fetchWithRetry(
      `${RIOT_API.ASIA}/riot/account/v1/accounts/by-puuid/${puuid}`,
      { headers: { 'X-Riot-Token': API_KEY } }
    );

    // 소환사 ID 조회
    const summonerData = await fetchWithRetry(
      `${RIOT_API.KOREA}/tft/summoner/v1/summoners/by-puuid/${puuid}`,
      { headers: { 'X-Riot-Token': API_KEY } }
    );
    
    if (!summonerData || !summonerData.id) {
      throw new Error('소환사 정보를 찾을 수 없습니다');
    }

    // 랭크 정보 조회
    const rankData = await fetchWithRetry(
      `${RIOT_API.KOREA}/tft/league/v1/entries/by-summoner/${summonerData.id}`,
      { headers: { 'X-Riot-Token': API_KEY } }
    );

    // 응답 데이터 구성
    const response = {
      summoner: {
        puuid: puuid,
        riot_id: accountData.gameName,
        tagline: accountData.tagLine,
        summoner_id: summonerData.id,
        summoner_level: summonerData.summonerLevel
      },
      ranks: rankData // 모든 큐 타입의 랭크 정보 포함
    };

    res.json(response);
  } catch (error) {
    console.error("❌ 오류:", error);
    res.status(500).json({ 
      message: "랭크 정보 조회 실패", 
      error: error.message 
    });
  }
});

// BOT 매치 검색
app.get('/api/bot-matches', async (req, res) => {
  try {
    const [rows] = await db.query(
      `SELECT m.*, p.riot_id_name, p.riot_id_tagline
       FROM tft_matches m
       JOIN tft_players p ON m.puuid = p.puuid
       WHERE m.puuid LIKE 'BOT%'
       ORDER BY m.game_length DESC`
    );

    // 각 매치에 대한 아이템 정보도 함께 조회
    const matchesWithItems = await Promise.all(
      rows.map(async (match) => {
        const [items] = await db.query(
          `SELECT unit_name, item_name
           FROM tft_items
           WHERE match_id = ? AND puuid = ?`,
          [match.match_id, match.puuid]
        );
        return { ...match, items };
      })
    );

    res.json(matchesWithItems);
  } catch (err) {
    console.error("❌ BOT 매치 검색 실패:", err);
    res.status(500).json({ message: "DB 오류" });
  }
});

// BOT 플레이어 검색 (단순 쿼리)
app.get('/api/bots', async (req, res) => {
  try {
    const [rows] = await db.query(
      `SELECT * FROM tft_players 
       WHERE puuid LIKE 'BOT%'
       ORDER BY game_date DESC 
       LIMIT 1000`
    );
    res.json(rows);
  } catch (err) {
    console.error("❌ BOT 검색 실패:", err);
    res.status(500).json({ message: "DB 오류" });
  }
});