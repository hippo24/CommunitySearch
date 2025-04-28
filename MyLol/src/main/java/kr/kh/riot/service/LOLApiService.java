package kr.kh.riot.service;

import java.util.List;
import java.util.Map;

import kr.kh.riot.model.dto.MatchDTO;

public interface LOLApiService {
	//닉네임, 태그로 PUUID 가져오기
    Map<String, Object> getSummonerByRiotId(String gameName, String tagLine) throws Exception;
    //PUUID로 소환사 정보 가져오기
    Map<String, Object> getSummonerByPuuid(String puuid) throws Exception;  
    //티어 & 점수 가져오기
    List<Map<String, Object>> getLOLLeagueInfo(String summonerId) throws Exception;
    //상세 검색
    List<MatchDTO> getRecentMatches(String puuid, int count) throws Exception;  
}