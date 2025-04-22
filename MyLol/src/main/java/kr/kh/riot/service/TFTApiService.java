package kr.kh.riot.service;

import java.util.List;
import java.util.Map;

public interface TFTApiService {
	//닉네임, 태그로 PUUID 가져오기
    Map<String, Object> getSummonerByRiotId(String gameName, String tagLine) throws Exception;
    //PUUID로 최근 경기 ID 가져오기
    List<String> getRecentTftMatchIds(String puuid, int start) throws Exception;
    //경기 ID로 게임 정보 가져오기
    Map<String, Object> getMatchDetail(String matchId) throws Exception;
    //PUUID로 소환사 정보 가져오기
    Map<String, Object> getSummonerByPuuid(String puuid) throws Exception;  
    //티어 & 점수 가져오기
    List<Map<String, Object>> getTFTLeagueInfo(String summonerId) throws Exception;  
}
