package kr.kh.riot.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import kr.kh.riot.model.vo.TftItems;
import kr.kh.riot.model.vo.TftMatches;
import kr.kh.riot.model.vo.TftPlayers;
import kr.kh.riot.model.vo.TftRank;

public interface StatsMapper {
    List<TftPlayers> selectTftPlayers();
    List<TftRank> selectTftRank();
    List<TftMatches> selectTftMatches();
    List<TftItems> selectTftItems();
    
    // 조건부(검색) 메서드 추가
    List<TftPlayers> selectTftPlayersByRiotId(@Param("riotIdName") String riotIdName, @Param("riotIdTagline") String riotIdTagline);
    List<TftRank> selectTftRankByRiotId(@Param("riotIdName") String riotIdName, @Param("riotIdTagline") String riotIdTagline);
    List<TftMatches> selectTftMatchesByRiotId(@Param("riotIdName") String riotIdName, @Param("riotIdTagline") String riotIdTagline);
    List<TftItems> selectTftItemsByRiotId(@Param("riotIdName") String riotIdName, @Param("riotIdTagline") String riotIdTagline);
    
    List<Map<String, Object>> selectTop3UnitsByRiotId(@Param("riotIdName") String riotIdName, @Param("riotIdTagline") String riotIdTagline);
    List<Map<String, Object>> selectTop3TraitsByRiotId(@Param("riotIdName") String riotIdName, @Param("riotIdTagline") String riotIdTagline);
}