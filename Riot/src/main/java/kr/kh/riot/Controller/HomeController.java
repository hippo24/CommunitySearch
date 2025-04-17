package kr.kh.riot.Controller;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		model.addAttribute("pageType", "tft");
		return "home";
	}
	
	@GetMapping("/lol/board")
	public String lolBoard(Model model) {
		model.addAttribute("pageType", "lol");
		return "/lol/board";
	}
	@GetMapping("/tft/board")
	public String tftBoard(Model model) {
		model.addAttribute("pageType", "tft");
		return "/tft/board";
	}
}
