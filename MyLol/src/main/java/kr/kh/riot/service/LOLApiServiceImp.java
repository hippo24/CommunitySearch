package kr.kh.riot.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import kr.kh.riot.model.dto.MatchDTO;

@Service
public class LOLApiServiceImp implements LOLApiService {
	
	@Value("${riotAPIKey}")
    private String apiKey;
    private final RestTemplate restTemplate;

    public LOLApiServiceImp() {
        this.restTemplate = new RestTemplate();
    }
    @Autowired
    LOLApiService riotApiService;

    //게임 타입 변환을 위한 Map 선언
    private static final Map<Integer, String> QUEUE_TYPE_MAP = Map.of(
        420, "솔로랭크",
        430, "일반 게임",
        440, "자유랭크",
        450, "칼바람"
    );

    //게임 타입 변환 메서드
    private String getGameType(Integer queueId) {
        return QUEUE_TYPE_MAP.getOrDefault(queueId, "기타");
    }

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
    public List<MatchDTO> getRecentMatches(String puuid, int count) throws Exception {
        List<MatchDTO> matchList = new ArrayList<>();
        
        try {
            // 1. 최근 매치 ID 목록 가져오기
            String matchIdsUrl = "https://asia.api.riotgames.com/lol/match/v5/matches/by-puuid/" 
                + puuid + "/ids?start=0&count=" + count;
            
            HttpHeaders headers = new HttpHeaders();
            headers.set("X-Riot-Token", apiKey);
            HttpEntity<String> entity = new HttpEntity<>(headers);
            
            ResponseEntity<String[]> matchIdsResponse = restTemplate.exchange(
                matchIdsUrl, 
                HttpMethod.GET, 
                entity, 
                String[].class
            );
            
            String[] matchIds = matchIdsResponse.getBody();
            
            // 2. 각 매치의 상세 정보 가져오기
            for (String matchId : matchIds) {
                String matchUrl = "https://asia.api.riotgames.com/lol/match/v5/matches/" + matchId;
                
                ResponseEntity<Map> matchResponse = restTemplate.exchange(
                    matchUrl,
                    HttpMethod.GET,
                    entity,
                    Map.class
                );
                
                Map<String, Object> matchData = (Map<String, Object>) matchResponse.getBody();
                Map<String, Object> info = (Map<String, Object>) matchData.get("info");
                
                // 참가자 중 puuid와 일치하는 플레이어 찾기
                List<Map<String, Object>> participants = (List<Map<String, Object>>) info.get("participants");
                Map<String, Object> playerData = participants.stream()
                    .filter(p -> puuid.equals(p.get("puuid")))
                    .findFirst()
                    .orElse(null);
                
                if (playerData != null) {
                    MatchDTO match = new MatchDTO();
                    // 기본 정보 설정
                    match.setQueueType(getGameType((Integer) info.get("queueId")));
                    match.setChampionName((String) playerData.get("championName"));
                    if (playerData.get("championName").equals("FiddleSticks")) {
                        match.setChampionIcon("https://ddragon.leagueoflegends.com/cdn/15.8.1/img/champion/Fiddlesticks.png");
                    } else {
                        match.setChampionIcon("https://ddragon.leagueoflegends.com/cdn/15.8.1/img/champion/" 
                            + playerData.get("championName") + ".png");
                    }
                    match.setChampLevel((Integer) playerData.get("champLevel"));
                    
                    // KDA 설정
                    match.setKills((Integer) playerData.get("kills"));
                    match.setDeaths((Integer) playerData.get("deaths"));
                    match.setAssists((Integer) playerData.get("assists"));

                    // 스펠 정보 설정
                    int spell1Id = (Integer) playerData.get("summoner1Id");
                    int spell2Id = (Integer) playerData.get("summoner2Id");

                    // 스펠 아이콘 URL 설정
                    match.setSpell1Icon(String.format("https://ddragon.leagueoflegends.com/cdn/15.8.1/img/spell/%s.png", 
                        getSpellKey(spell1Id)));
                    match.setSpell2Icon(String.format("https://ddragon.leagueoflegends.com/cdn/15.8.1/img/spell/%s.png", 
                        getSpellKey(spell2Id)));

                    // 룬 정보 설정 부분 수정
                    Map<String, Object> perks = (Map<String, Object>) playerData.get("perks");
                    List<Map<String, Object>> styles = (List<Map<String, Object>>) perks.get("styles");

                    // 메인 룬
                    Map<String, Object> primaryStyle = styles.get(0);
                    List<Map<String, Object>> selections = (List<Map<String, Object>>) primaryStyle.get("selections");
                    int primaryRuneId = (Integer) selections.get(0).get("perk");  // 실제 선택한 키스톤 룬 ID
                    int subStyleId = (Integer) styles.get(1).get("style");        // 보조 룬 스타일 ID

                    // 룬 아이콘 URL 설정
                    match.setPrimaryRuneIcon(getPrimaryRuneIconPath(primaryRuneId));
                    match.setSecondaryRuneIcon(getSecondaryRuneIconPath(subStyleId));

                    System.out.println("Primary Rune ID (Keystone): " + primaryRuneId);
                    System.out.println("Secondary Style ID: " + subStyleId);

                    // 킬 관여율 계산
                    int teamId = (Integer) playerData.get("teamId");
                    int totalTeamKills = participants.stream()
                        .filter(p -> teamId == (Integer)p.get("teamId"))
                        .mapToInt(p -> (Integer)p.get("kills"))
                        .sum();

                    // 킬 관여율 계산 (반올림된 정수값)
                    int killParticipation = totalTeamKills > 0 
                        ? Math.round((match.getKills() + match.getAssists()) * 100.0f / totalTeamKills)
                        : 0;

                    match.setKillParticipation(killParticipation);
                    
                    // CS 설정
                    int minionsKilled = (Integer) playerData.get("totalMinionsKilled");
                    int neutralMinionsKilled = (Integer) playerData.get("neutralMinionsKilled");
                    match.setCs(minionsKilled + neutralMinionsKilled);
                    
                    // 골드, 시야점수
                    match.setGold((Integer) playerData.get("goldEarned"));
                    match.setVisionScore((Integer) playerData.get("visionScore"));
                    
                    // 게임 시간 설정
                    int gameDuration = (Integer) info.get("gameDuration");
                    match.setGameDuration(String.format("%d분 %d초", gameDuration / 60, gameDuration % 60));

                    // 여기에 게임 종료 시간 코드 추가
                    long gameCreation = ((Number) info.get("gameCreation")).longValue();
                    long gameEndTimestamp = gameCreation + (gameDuration * 1000L);

                    SimpleDateFormat sdf = new SimpleDateFormat("yy-MM-dd HH:mm");
                    String gameEndTime = sdf.format(new Date(gameEndTimestamp));
                    match.setGameEndTime(gameEndTime);
                    
                    // 승패 여부
                    match.setWin((Boolean) playerData.get("win"));
                    
                    // 아이템 정보 설정
                    Map<Integer, String> firstRowWithPositions = new LinkedHashMap<>();
                    Map<Integer, String> secondRowWithPositions = new LinkedHashMap<>();

                    // 모든 슬롯 위치 초기화 (빈 슬롯도 포함)
                    for(int i = 0; i <= 2; i++) {
                        firstRowWithPositions.put(i, null);
                    }
                    firstRowWithPositions.put(6, null);  // 첫 줄의 마지막 슬롯

                    for(int i = 3; i <= 5; i++) {
                        secondRowWithPositions.put(i, null);
                    }

                    // 실제 아이템 정보 채우기
                    for(int i = 0; i < 7; i++) {
                        String itemKey = "item" + i;
                        if(playerData.containsKey(itemKey)) {
                            Object itemObj = playerData.get(itemKey);
                            if(itemObj != null) {
                                int itemId = ((Number) itemObj).intValue();
                                if(itemId > 0) {
                                    String itemIconUrl = String.format("https://ddragon.leagueoflegends.com/cdn/15.8.1/img/item/%d.png", itemId);
                                    
                                    if(i <= 2 || i == 6) {
                                        firstRowWithPositions.put(i, itemIconUrl);
                                    } else {
                                        secondRowWithPositions.put(i, itemIconUrl);
                                    }
                                }
                            }
                        }
                    }

                    match.setFirstRowItems(new ArrayList<>(firstRowWithPositions.values()));
                    match.setSecondRowItems(new ArrayList<>(secondRowWithPositions.values()));
                    
                    matchList.add(match);
                }
            }
            
            return matchList;
            
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("매치 데이터 조회 중 오류 발생: " + e.getMessage());
        }
    }

    // 스펠 ID를 실제 키값으로 변환하는 메서드
    private String getSpellKey(int spellId) {
        Map<Integer, String> spellMap = Map.of(
            1, "SummonerBoost",     // 정화
            3, "SummonerExhaust",   // 탈진
            4, "SummonerFlash",     // 점멸
            6, "SummonerHaste",     // 유체화
            7, "SummonerHeal",      // 치유
            11, "SummonerSmite",    // 강타
            12, "SummonerTeleport", // 순간이동
            14, "SummonerDot",      // 점화
            21, "SummonerBarrier",  // 방어막
            32, "SummonerSnowball"  // 눈덩이
        );
        return spellMap.getOrDefault(spellId, "SummonerBoost");
    }

    // 메인 룬용 메서드 수정
    private String getPrimaryRuneIconPath(int runeId) {
        Map<Integer, String[]> primaryRuneMap = Map.ofEntries(
            Map.entry(8005, new String[]{"Precision", "PressTheAttack"}),    	// 집중 공격
            Map.entry(8010, new String[]{"Precision", "Conqueror"}),         	// 정복자
            Map.entry(8021, new String[]{"Precision", "FleetFootwork"}),     	// 기민한 발놀림
            Map.entry(8112, new String[]{"Domination", "Electrocute"}),      	// 감전
            Map.entry(8128, new String[]{"Domination", "DarkHarvest"}),      	// 어둠의 수확
            Map.entry(9923, new String[]{"Domination", "HailOfBlades"}),     	// 칼날비
            Map.entry(8214, new String[]{"Sorcery", "SummonAery"}),         	// 콩콩이
            Map.entry(8229, new String[]{"Sorcery", "ArcaneComet"}),       	 	// 신비한 유성
            Map.entry(8230, new String[]{"Sorcery", "PhaseRush"}),          	// 난입
            Map.entry(8437, new String[]{"Resolve", "GraspOfTheUndying"}), 	    // 착취의 손아귀
            Map.entry(8465, new String[]{"Resolve", "Guardian"}),               // 수호자
            Map.entry(8351, new String[]{"Inspiration", "GlacialAugment"}), 	// 빙결 강화
            Map.entry(8360, new String[]{"Inspiration", "UnsealedSpellbook"}),  // 봉인 풀린 주문서
            Map.entry(8369, new String[]{"Inspiration", "FirstStrike"})  		// 선제 공격
        );
        
        // 치속
        if (runeId == 8008) {
            return "https://opgg-static.akamaized.net/meta/images/lol/15.8.1/perk/8008.png?image=q_auto:good,f_webp,w_56,h_56&v=1508";
        }
        // 여진
        if (runeId == 8439) {
            return "https://opgg-static.akamaized.net/meta/images/lol/15.8.1/perk/8439.png?image=q_auto:good,f_webp,w_56,h_56&v=1508";
        }

        String[] runePath = primaryRuneMap.get(runeId);
        if (runePath != null) {
            return String.format("https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/%s/%s/%s.png", 
                runePath[0], runePath[1], runePath[1]);
        }
        return null;
    }

    // 서브 룬용 메서드
    private String getSecondaryRuneIconPath(int runeId) {
        Map<Integer, String> runeMap = Map.of(
            8100, "7200_Domination",    // 지배
            8300, "7203_Whimsy",        // 영감
            8000, "7201_Precision",     // 정밀
            8400, "7204_Resolve",       // 결의
            8200, "7202_Sorcery"        // 마법
        );
        return String.format("https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/%s.png", 
            runeMap.getOrDefault(runeId, "7200_Domination"));
    }

    private String getChampionIconUrl(String championName) {
        if ("FiddleSticks".equals(championName)) {
            return "https://ddragon.leagueoflegends.com/cdn/15.8.1/img/champion/Fiddlesticks.png";
        }
        return "https://ddragon.leagueoflegends.com/cdn/15.8.1/img/champion/" + championName + ".png";
    }

}