package kr.kh.riot.Service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class TFTApiServiceImp implements TFTApiService {
	
	@Value("${riotAPIKey}")
    private String apiKey;// 라이엇 API 키
	

    private final RestTemplate restTemplate;

    public TFTApiServiceImp() {
        this.restTemplate = new RestTemplate();
    }
    @Autowired
    TFTApiService riotApiService;

    @Override
    public Map<String, Object> getSummonerByRiotId(String gameName, String tagLine) throws Exception {
        String url = String.format("https://asia.api.riotgames.com/riot/account/v1/accounts/by-riot-id/%s/%s?api_key=%s",
                                   gameName, tagLine, apiKey);

        // REST API 호출 및 응답 받기
        return restTemplate.getForObject(url, Map.class);
    }

    @Override
    public List<String> getRecentTftMatchIds(String puuid) throws Exception {
    	//(start+1)번째 경기부터 시작해 count개까지
    	int start = 0;
    	int count = 10;
        String url = String.format("https://asia.api.riotgames.com/tft/match/v1/matches/by-puuid/%s/ids?start="+start+"&count="+count+"&api_key=%s",
                                   puuid, apiKey);
        // REST API 호출 및 응답 받기
        return restTemplate.getForObject(url, List.class);
    }
    
    @Override
    public Map<String, Object> getMatchDetail(String matchId) throws Exception {
        String url = String.format("https://asia.api.riotgames.com/tft/match/v1/matches/%s?api_key=%s",
                                   matchId, apiKey);

        // REST API 호출 및 응답 받기
        return restTemplate.getForObject(url, Map.class);
    }
    //PUUID로 소환사 정보 가져오기
    @Override
    public Map<String, Object> getSummonerByPuuid(String puuid) throws Exception {
        String url = String.format("https://kr.api.riotgames.com/tft/summoner/v1/summoners/by-puuid/%s?api_key=%s",
                                   puuid, apiKey);
        return restTemplate.getForObject(url, Map.class);
    }

    //소환사 ID로 티어, 점수 가져오기
    @Override
    public List<Map<String, Object>> getTFTLeagueInfo(String summonerId) throws Exception {
        String url = String.format("https://kr.api.riotgames.com/tft/league/v1/entries/by-summoner/%s?api_key=%s",
                                   summonerId, apiKey);
        return restTemplate.getForObject(url,  List.class);
        
    }
    
	
}
