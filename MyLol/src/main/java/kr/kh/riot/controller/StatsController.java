package kr.kh.riot.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

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
}