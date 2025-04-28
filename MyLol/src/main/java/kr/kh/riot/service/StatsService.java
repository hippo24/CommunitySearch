package kr.kh.riot.service;

import java.util.List;
import java.util.Map;

import kr.kh.riot.model.vo.TftItems;
import kr.kh.riot.model.vo.TftMatches;
import kr.kh.riot.model.vo.TftPlayers;
import kr.kh.riot.model.vo.TftRank;

public interface StatsService {
    List<TftPlayers> getTftPlayers();
    List<TftRank> getTftRank();
    List<TftMatches> getTftMatches();
    List<TftItems> getTftItems();
    List<TftPlayers> getTftPlayersByRiotId(String riotIdName, String riotIdTagline);
    List<TftRank> getTftRankByRiotId(String riotIdName, String riotIdTagline);
    List<TftMatches> getTftMatchesByRiotId(String riotIdName, String riotIdTagline);
	List<TftItems> getTftItemsByRiotId(String riotIdName, String riotIdTagline);
	
	//유저 통계
	List<Map<String, Object>> getTop3UnitsByRiotId(String riotIdName, String riotIdTagline);
	List<Map<String, Object>> getTop3TraitsByRiotId(String riotIdName, String riotIdTagline);
	List<Map<String, Object>> getTop3ItemsByRiotId(String riotIdName, String riotIdTagline);
	List<Map<String, Object>> getTierCountByRiotId(String riotIdName, String riotIdTagline);
	List<Map<String, Object>> getTop3LevelsByRiotId(String riotIdName, String riotIdTagline);
}