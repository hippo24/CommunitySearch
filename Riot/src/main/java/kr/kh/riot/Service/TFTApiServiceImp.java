package kr.kh.riot.Service;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.kh.riot.Model.vo.Trait;

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
    	//최근 경기부터 시작해 10개까지
        String url = String.format("https://asia.api.riotgames.com/tft/match/v1/matches/by-puuid/%s/ids?start=0&count=10&api_key=%s",
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
    
    //JSON 파싱
    private Map<String, Trait> traitMap;
    
    @PostConstruct
    public void init() throws IOException {
        ObjectMapper mapper = new ObjectMapper();
        InputStream is = getClass().getResourceAsStream("/static/data/tft-trait.json");
        JsonNode root = mapper.readTree(is);
        JsonNode dataNode = root.get("data");

        traitMap = new HashMap<>();
        Iterator<Map.Entry<String, JsonNode>> fields = dataNode.fields();
        while (fields.hasNext()) {
            Map.Entry<String, JsonNode> entry = fields.next();
            String id = entry.getKey();

            if (id.startsWith("TFT14_")) {
                Trait trait = mapper.treeToValue(entry.getValue(), Trait.class);
                traitMap.put(trait.getName(), trait); // 한글 이름으로 키 저장
            }
        }
    }
    @Override
    public Trait getTraitByKoreanName(String name) {
        return traitMap.get(name);
    }

    @Override
    public List<Trait> getTraitList() {
        return new ArrayList<>(traitMap.values());
    }
}
