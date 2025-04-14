package kr.kh.riot.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.kh.riot.Model.dto.SummonerDTO;
import kr.kh.riot.Service.TFTApiService;

@Controller
@RequestMapping("/lol")
public class LOLApiController {

    @Autowired
    TFTApiService tftApiService;

    @GetMapping("/home")
    public String getSummoner(Model model) {
    	 model.addAttribute("pageType", "lol");
        return "/tft/summoner2"; // JSP 파일 이름 (summoner.jsp)
    }
    
    @GetMapping("/summoner")
    public String getSummoner2(SummonerDTO dto, Model model) {
    	model.addAttribute("pageType", "lol");
        return "/tft/profile"; // JSP 파일 이름 (summoner.jsp)
    }
}

