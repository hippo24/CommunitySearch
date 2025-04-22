package kr.kh.riot.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class LOLApiServiceImp implements LOLApiService {
	
	@Value("${riotAPIKey}")
    private String apiKey;// 라이엇 API 키
	

    private final RestTemplate restTemplate;

    public LOLApiServiceImp() {
        this.restTemplate = new RestTemplate();
    }
    @Autowired
    LOLApiService riotApiService;

    //닉네임과 태그를 통해 PUUID 가져오기
    @Override
    public Map<String, Object> getSummonerByRiotId(String gameName, String tagLine) throws Exception {
    	String url = String.format("https://asia.api.riotgames.com/riot/account/v1/accounts/by-riot-id/%s/%s?api_key=%s",
                                   gameName, tagLine, apiKey);
    	System.out.println(url);
        // REST API 호출 및 응답 받기
        return restTemplate.getForObject(url, Map.class);
    }

    //PUUID로 소환사 정보 가져오기
    @Override
    public Map<String, Object> getSummonerByPuuid(String puuid) throws Exception {
    	String url = String.format("https://kr.api.riotgames.com/lol/summoner/v4/summoners/by-puuid/%s?api_key=%s", puuid, apiKey);

        return restTemplate.getForObject(url, Map.class);
    }

    //소환사 ID로 티어, 점수 가져오기
    @Override
    public List<Map<String, Object>> getLOLLeagueInfo(String summonerId) throws Exception {
        String url = String.format(
            "https://kr.api.riotgames.com/lol/league/v4/entries/by-summoner/%s?api_key=%s",
            summonerId, apiKey
        );
        System.out.println(url);
        return restTemplate.getForObject(url, List.class);
    }

	
	@Override
    public List<String> getRecentLOLMatchIds(String puuid, int start){
    	//(start+1)번째 경기부터 시작해 count개까지
    	int count = 10;
        String url = String.format("https://asia.api.riotgames.com/lol/match/v5/matches/by-puuid/"+puuid+"/ids?start="+start+"&count="+count+"&api_key="+ apiKey);
        System.out.println(url);
        // REST API 호출 및 응답 받기
        return restTemplate.getForObject(url, List.class);
    }

	@Override
	public Map<String, Object> getMatchDetail(String matchId, String puuid) {
	    String url = String.format("https://asia.api.riotgames.com/lol/match/v5/matches/" + matchId + "?api_key=" + apiKey);
	    //한 게임의 전체 경기 내용
	    Map<String, Object> match = restTemplate.getForObject(url, Map.class);
	    //게임 정보 대부분은 match.info안에 있음
	    Map<String, Object> info = (Map<String, Object>) match.get("info");
	    List<Map<String, Object>> participants = (List<Map<String, Object>>) info.get("participants");
	    //match.info.participant 안에 해당 유저의 puuid가 있음
	    for (Map<String, Object> participant : participants) {
	        //일단 검색한 유저의 정보만 보기 위함
	    	if (puuid.equals(participant.get("puuid"))) {
	            return participant; 
	        }
	    }
	    return null;
	}

}