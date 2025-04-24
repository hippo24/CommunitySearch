package kr.kh.riot.controller;

import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kr.kh.riot.model.vo.BoardVO;
import kr.kh.riot.service.PostService;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	@Autowired
	private PostService postService; 
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {

		return "/tft/profile2";
	}
	
	@GetMapping("/exampleTFT")
	public String toolTFT() {
	    return "/tool/tftTool"; 
	}
	

	
}
