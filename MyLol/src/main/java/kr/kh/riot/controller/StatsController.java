package kr.kh.riot.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.kh.riot.model.vo.TftItems;
import kr.kh.riot.model.vo.TftMatches;
import kr.kh.riot.model.vo.TftPlayers;
import kr.kh.riot.model.vo.TftRank;
import kr.kh.riot.service.StatsService;

@Controller
public class StatsController {

    @Autowired
    private StatsService statsService;

    @GetMapping("/players")
    public String showPlayer(Model model) {
        List<TftPlayers> playerList = statsService.getTftPlayers();
        model.addAttribute("playerList", playerList);
        return "players";
    }
    @GetMapping("/rank")
    public String showRank(Model model) {
        List<TftRank> rankList = statsService.getTftRank();
        model.addAttribute("rankList", rankList);
        return "rank";
    }
    @GetMapping("/matches")
    public String showMatches(Model model) {
        List<TftMatches> matchList = statsService.getTftMatches();
        model.addAttribute("matchList", matchList);
        return "matches";
    }
    @GetMapping("/items")
    public String showItems(Model model) {
        List<TftItems> itemList = statsService.getTftItems();
        model.addAttribute("itemList", itemList);
        return "items";
    }
    @GetMapping("/records")
    public String showRecords(
        @RequestParam(value="gameName", required=false) String gameName,
        @RequestParam(value="tagLine", required=false) String tagLine,
        Model model) {

        List<Map<String, Object>> top3Units = null;
        if (gameName != null && tagLine != null && !gameName.isEmpty() && !tagLine.isEmpty()) {
            // 검색한 유저의 유닛 TOP 3만 조회
            top3Units = statsService.getTop3UnitsByRiotId(gameName, tagLine);
            model.addAttribute("gameName", gameName);
            model.addAttribute("tagLine", tagLine);
        }
        model.addAttribute("top3Units", top3Units);
        
        List<Map<String, Object>> top3Traits = null;
        if (gameName != null && tagLine != null && !gameName.isEmpty() && !tagLine.isEmpty()) {
            top3Traits = statsService.getTop3TraitsByRiotId(gameName, tagLine);
        }
        model.addAttribute("top3Traits", top3Traits);
        return "records";
    }
}