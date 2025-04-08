package kr.kh.riot.Service;

import java.util.List;
import java.util.Map;

import kr.kh.riot.Model.vo.Trait;

public interface TFTApiService {
	//닉네임, 태그로 PUUID 가져오기
    Map<String, Object> getSummonerByRiotId(String gameName, String tagLine) throws Exception;
    //PUUID로 최근 경기 ID 가져오기
    List<String> getRecentTftMatchIds(String puuid) throws Exception;
    //경기 ID로 게임 정보 가져오기
    Map<String, Object> getMatchDetail(String matchId) throws Exception;
    //PUUID로 소환사 정보 가져오기
    Map<String, Object> getSummonerByPuuid(String puuid) throws Exception;  
    //티어 & 점수 가져오기
    List<Map<String, Object>> getTFTLeagueInfo(String summonerId) throws Exception;  
    
    // 이름으로 검색
    Trait getTraitByKoreanName(String name);
	List<Trait> getTraitList(); 
}
