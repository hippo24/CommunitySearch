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

import kr.kh.riot.model.dto.SummonerDTO;
import kr.kh.riot.model.vo.BoardVO;
import kr.kh.riot.service.LOLApiService;
import kr.kh.riot.service.PostService;

@Controller
@RequestMapping("/lol")
public class LOLApiController {

    @Autowired
    LOLApiService lolApiService;

    @Autowired
    PostService postService;
    
    @GetMapping("/home")
    public String getSummoner(Model model) {
    	 model.addAttribute("pageType", "lol");
        return "/lol/summoner"; // JSP 파일 이름 (summoner.jsp)
    }
    
    @GetMapping("/summoner")
    public String getSummoner2(SummonerDTO dto, Model model) {
    	model.addAttribute("pageType", "lol");
        return "/lol/profile"; // JSP 파일 이름 (summoner.jsp)
    }
    
    // AJAX 요청을 처리하는 /searchPUUID 엔드포인트
    @GetMapping("/searchPUUID")
    @ResponseBody
    public Map<String, Object> searchSummoner(@RequestParam String gameName, @RequestParam String tagLine) {
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

			// 서비스에서 소환사 정보 가져오기
			Map<String, Object> summoner = lolApiService.getSummonerByPuuid(puuid);
			List<Map<String, Object>> leagueInfo = lolApiService.getLOLLeagueInfo(summonerId);

			// 가져온 데이터를 JSP에 보내기
			model.addAttribute("gameName", gameName);
			model.addAttribute("tagLine", tagLine);
			model.addAttribute("summoner", summoner);
			model.addAttribute("dto", leagueInfo.get(0)); // 첫 번째 데이터만 보낸다고 가정
		} catch (Exception e) {	
			e.printStackTrace();
		}
        return "lol/profile"; 
    }
    
    // PUUID로 LOL 경기 ID 가져오기
    @GetMapping("/recentLOLMatchIds")
    @ResponseBody
    public List<String> getRecentLOLMatchIds(@RequestParam String puuid, @RequestParam int start) {
        try {
        	return lolApiService.getRecentLOLMatchIds(puuid, start);
        } catch (Exception e) {
            return List.of("소환사 정보를 가져오는 중 오류가 발생했습니다.");
        }
    }
    // 경기 ID로 세부 내용 가져오기
    @GetMapping("/matchDetail")
    public String getLOLMatchDetail(@RequestParam String matchId, @RequestParam String puuid, Model model) {
        Map<String, Object> userInfo = lolApiService.getMatchDetail(matchId, puuid);
        model.addAttribute("user", userInfo);  // 유저 정보만 따로 넘겨줌
        return "lol/gameInfo"; 
    }
}