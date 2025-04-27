package kr.kh.riot.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import kr.kh.riot.model.vo.TftPlayer;
import kr.kh.riot.service.StatsService;

@Controller
public class StatsController {

    @Autowired
    private StatsService statsService;

    @GetMapping("/stats")
    public String showStats(Model model) {
        List<TftPlayer> playerList = statsService.getTftPlayers();
        model.addAttribute("playerList", playerList);
        return "stats";
    }
}