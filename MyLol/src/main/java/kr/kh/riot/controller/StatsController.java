package kr.kh.riot.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import kr.kh.riot.model.vo.TftPlayers;
import kr.kh.riot.service.StatsService;

@Controller
public class StatsController {

    @Autowired
    private StatsService statsService;

    @GetMapping("/players")
    public String showStats(Model model) {
        List<TftPlayers> playerList = statsService.getTftPlayers();
        model.addAttribute("playerList", playerList);
        return "players";
    }
}