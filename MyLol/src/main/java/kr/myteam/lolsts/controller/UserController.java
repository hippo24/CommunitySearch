package kr.myteam.lolsts.controller;

import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.myteam.lolsts.model.vo.UserVO;
import kr.myteam.lolsts.service.UserService;

@Controller
@RequestMapping("/user")
public class UserController {

	@Autowired
	private UserService userService;
	
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	/*
	@Autowired
	private JavaMailSender mailSender;
*/
	

	@GetMapping("/signup")
	public String signup() {
		return "/user/signup";
	}
	
	
	@GetMapping("/login")
	public String login() {
		return "/user/login";
	}
	

	@PostMapping("/signup")
	public String signupPost(Model model, UserVO user) {
		
		if(userService.signup(user)) {				//성공시
			model.addAttribute("msg", "회원 가입을 했습니다.");
			model.addAttribute("url", "/");
			return "redirect:/";			//나중에 이부분 제거
		}else {
			model.addAttribute("url", "/user/signup?id=" + user.getUs_id());
			model.addAttribute("msg", "회원 가입에 실패했습니다.");
		}
		
		return "redirect:/signup";				//나중에 이부분 message로 
	}
	
	@ResponseBody
	@PostMapping("/check/id")
	public boolean checkId(@RequestParam("us_id") String us_id){
		return userService.checkBy(us_id, "us_id");
	}
	
	@ResponseBody
	@PostMapping("/check/name")
	public boolean checkName(@RequestParam("us_name") String us_name){
		return userService.checkBy(us_name, "us_name");
	}
	
	
}
