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

import kr.kh.riot.Model.vo.Trait;
import kr.kh.riot.Service.TFTApiService;

@Controller
@RequestMapping("/tft")
public class TFTApiController {

    @Autowired
    TFTApiService tftApiService;

    @GetMapping("/summoner")
    public String getSummoner() {
        return "/tft/summoner"; // JSP 파일 이름 (summoner.jsp)
    }
    
    @GetMapping("/summoner2")
    public String getSummoner2() {
        return "/tft/summoner2"; // JSP 파일 이름 (summoner.jsp)
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

    // PUUID로 최근 TFT 경기 ID 가져오기
    @GetMapping("/recentTftMatchIds")
    @ResponseBody
    public List<String> getRecentTftMatchIds(@RequestParam String puuid) {
        try {
        	return tftApiService.getRecentTftMatchIds(puuid);
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
    
    //이건 리스트형식이였음
    @GetMapping("/getTFTLeagueInfo")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getTFTLeagueInfo(@RequestParam String summonerId) {
        try {
        	List<Map<String, Object>> leagueInfo = tftApiService.getTFTLeagueInfo(summonerId);
            return ResponseEntity.ok(leagueInfo);
        } catch (Exception e) {
        	e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
	/*
	 * //JSON으로부터 시너지 이미지 가져오기
	 * 
	 * @GetMapping("/trait") public String getTrait(@RequestParam("name") String
	 * name, Model model) { Trait trait = tftApiService.getTraitByKoreanName(name);
	 * model.addAttribute("trait", trait); return "/tft/trait"; // trait.jsp로 연결 }
	 * 
	 * @RequestMapping("/tft/traits") public String showTraits(Model model) {
	 * List<Trait> traitList = tftApiService.getTraitList();
	 * model.addAttribute("traitList", traitList); return "tft/trait"; // 또는
	 * "tft/traits" }
	 */
}

