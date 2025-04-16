package kr.kh.riot.Controller;

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

import kr.kh.riot.Service.TFTApiService;

@Controller
@RequestMapping("/tft")
public class TFTApiController {

    @Autowired
    TFTApiService tftApiService;
    
    @GetMapping("/home")
    public String home(Model model) {
    	 model.addAttribute("pageType", "tft");
        return "/tft/summoner"; // JSP 파일 이름 (summoner.jsp)
    }
    
    @GetMapping("/summoner")
    public String getSummoner(Model model) {
    	 model.addAttribute("pageType", "tft");
        return "/tft/summoner"; // JSP 파일 이름 (summoner.jsp)
    }

    // AJAX 요청을 처리하는 /searchPUUID 엔드포인트
    @GetMapping("/searchPUUID")
    @ResponseBody
    public Map<String, Object> searchSummoner(@RequestParam String gameName, @RequestParam String tagLine) {
        try {
            return tftApiService.getSummonerByRiotId(gameName, tagLine);
        } catch (Exception e) {
            return Collections.singletonMap("error", "소환사 정보를 가져오는 중 오류가 발생했습니다.");
        }
    }

    // PUUID로 최근 TFT 경기 ID 가져오기 -> 10개 이후 또 10개 가져오게 하는 법 필요함.
    @GetMapping("/recentTftMatchIds")
    @ResponseBody
    public List<String> getRecentTftMatchIds(@RequestParam String puuid, @RequestParam int start) {
        try {
        	return tftApiService.getRecentTftMatchIds(puuid, start);
        } catch (Exception e) {
            return List.of("소환사 정보를 가져오는 중 오류가 발생했습니다.");
        }
    }

    // 경기 상세 정보 가져오기
    @GetMapping("/matchDetail")
    @ResponseBody
    public Map<String, Object> getMatchDetail(@RequestParam String matchId) {
        try {
            return tftApiService.getMatchDetail(matchId);
        } catch (Exception e) {
            return Collections.singletonMap("error", "경기 정보를 가져오는 중 오류가 발생했습니다.");
        }
    }
    
    @GetMapping("/getSummonerByPuuid")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getSummonerByPuuid(@RequestParam String puuid) {
        try {
            Map<String, Object> summoner = tftApiService.getSummonerByPuuid(puuid);
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
			// 서비스에서 소환사 정보 가져오기
			Map<String, Object> summoner = tftApiService.getSummonerByPuuid(puuid);
			// 나중에 puuid로 가져오는 api로 수정하기(결과 자체는 똑같음)
			List<Map<String, Object>> leagueInfo = tftApiService.getTFTLeagueInfo(summonerId);
			
			// 가져온 데이터를 JSP에 보내기
			model.addAttribute("dto", leagueInfo.get(0)); // 첫 번째 데이터만 보낸다고 가정
			model.addAttribute("gameName", gameName);
			model.addAttribute("tagLine", tagLine);
			model.addAttribute("summoner", summoner);
		} catch (Exception e) {	
			e.printStackTrace();
		}
        return "tft/profile"; 
    }
    
}

