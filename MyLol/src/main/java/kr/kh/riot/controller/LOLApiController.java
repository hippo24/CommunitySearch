package kr.kh.riot.controller;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.kh.riot.model.dto.MatchDTO;
import kr.kh.riot.model.dto.SummonerDTO;
import kr.kh.riot.service.LOLApiService;

@Controller
@RequestMapping("/lol")
public class LOLApiController {

    @Autowired
    LOLApiService lolApiService;

    @GetMapping("/home")
    public String getSummoner(Model model) {
    	 model.addAttribute("pageType", "lol");
        return "/lol/summoner"; // JSP 파일 이름 (summoner.jsp)
    }
    
    @GetMapping("/summoner")
    public String getSummoner2(SummonerDTO dto, Model model) {
    	model.addAttribute("pageType", "lol");
        return "/lol/summoner"; // JSP 파일 이름 (summoner.jsp)
    }
    
    // AJAX 요청을 처리하는 /searchPUUID 엔드포인트
    @GetMapping("/searchPUUID")
    @ResponseBody
    public Map<String, Object> searchSummoner(@RequestParam String gameName, @RequestParam String tagLine) {
        System.out.println(gameName);
        System.out.println(tagLine);
    	try {
            return lolApiService.getSummonerByRiotId(gameName, tagLine);
        } catch (Exception e) {
            return Collections.singletonMap("error", "소환사 정보를 가져오는 중 오류가 발생했습니다.");
        }
    }
    @GetMapping("/getSummonerByPuuid")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getSummonerByPuuid(@RequestParam String puuid) {
        try {
            Map<String, Object> summoner = lolApiService.getSummonerByPuuid(puuid);
            return ResponseEntity.ok(summoner);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    //소환사 정보 출력 막말로 puuid로 부터 시작해서 따로 둘까 생각중이기도 함.
    @GetMapping("/getSummonerProfile")
    public String listPost(@RequestParam String puuid, @RequestParam String summonerId, @RequestParam String gameName, 
    		@RequestParam String tagLine, Model model) {
		try {
			System.out.println(puuid);
			System.out.println(summonerId);
			System.out.println(gameName + '#' + tagLine);
			model.addAttribute("gameName", gameName);
			model.addAttribute("tagLine", tagLine);
			// 서비스에서 소환사 정보 가져오기
			Map<String, Object> summoner = lolApiService.getSummonerByPuuid(puuid);
			model.addAttribute("summoner", summoner);
			List<Map<String, Object>> leagueInfo = lolApiService.getLOLLeagueInfo(summonerId);
			System.out.println(summoner);
			System.out.println(leagueInfo);
			// 가져온 데이터를 JSP에 보내기
			model.addAttribute("dto", leagueInfo.get(0)); // 첫 번째 데이터만 보낸다고 가정

            // 새로 추가된 코드 (초록색으로 표시)
            // 매치 데이터 가져오기
			List<MatchDTO> matchList = lolApiService.getRecentMatches(puuid, 10); // 최근 10게임
			model.addAttribute("matchList", matchList);
        
		} catch (Exception e) {	
			e.printStackTrace();
		}
        return "lol/profile"; 
    }

    // 게임 타입 변환을 위한 Map 선언
    private static final Map<Integer, String> QUEUE_TYPE_MAP = Map.of(
        420, "솔로랭크",
        430, "일반 게임",
        440, "자유랭크",
        450, "칼바람"
    );
    
    // 게임 타입 변환 메서드
    private String getGameType(int queueId) {
        return QUEUE_TYPE_MAP.getOrDefault(queueId, "기타");
    }

}