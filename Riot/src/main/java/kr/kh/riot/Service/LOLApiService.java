package kr.kh.riot.Service;

import java.util.List;
import java.util.Map;

import kr.kh.riot.Model.vo.Trait;

public interface LOLApiService {
	//닉네임, 태그로 PUUID 가져오기
    Map<String, Object> getSummonerByRiotId(String gameName, String tagLine) throws Exception;
    //PUUID로 소환사 정보 가져오기
    Map<String, Object> getSummonerByPuuid(String puuid) throws Exception;  
    //티어 & 점수 가져오기
    List<Map<String, Object>> getLOLLeagueInfo(String summonerId) throws Exception;
	
    //경기ID 가져오기
    List<String> getRecentLOLMatchIds(String puuid, int start);
	//경기 세부 내용 가져오기
    Map<String, Object> getMatchDetail(String matchId, String puuid);  
}
