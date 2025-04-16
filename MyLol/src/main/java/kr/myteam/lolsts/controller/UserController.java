package kr.myteam.lolsts.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
	public String signup(Model model, String id) {
		model.addAttribute("id", id);
		return "/user/signup";
	}
	
	
	@GetMapping("/login")
	public String login(Model model, String id, HttpServletRequest request) {
		String prevUrl = request.getHeader("Referer");
		if(prevUrl != null && !prevUrl.contains("/login")) {		
			request.getSession().setAttribute("prevUrl", prevUrl);	
		}
		model.addAttribute("id", id);
		return "/user/login";
	}
	

	@PostMapping("/signup")
	public String signupPost(Model model, UserVO user) {
		
		if(userService.signup(user)) {				//성공시
			model.addAttribute("msg", "회원 가입을 했습니다.");
			model.addAttribute("url", "/");
			//return "redirect:/";			//나중에 이부분 제거
		}else {
			model.addAttribute("url", "/user/signup?id=" + user.getUs_id());
			model.addAttribute("msg", "회원 가입에 실패했습니다.");
		}
		
		//return "redirect:/signup";				//나중에 이부분 message로 
		return "message";
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
	
	@PostMapping("/login")
	public String loginPost(Model model, UserVO user) {
		
		UserVO newUser = userService.login(user);
		
		if(newUser != null) {				//성공시
			model.addAttribute("msg", "로그인 성공.");
			model.addAttribute("url", "/");
			
			newUser.setAuto(user.isAuto());	
			model.addAttribute("user", newUser);
			System.out.println(newUser);
		}else {
			model.addAttribute("url", "/user/login?id=" + user.getUs_id());
			model.addAttribute("msg", "로그인에 실패했습니다.");
		}
		return "message";
	}
	
	@GetMapping("/logout")
	public String logout(Model model, HttpSession session) {	
		
		//회원정보에서 쿠키값을 null로 수정.
		UserVO newUser = (UserVO)session.getAttribute("user");
		if(newUser==null) return "redirect:/"; 
		newUser.setUs_cookie(null);
		newUser.setUs_limit(null);
		userService.updateUserCookie(newUser);
		
		session.removeAttribute("user");			
		
		model.addAttribute("url", "/");
		model.addAttribute("msg", "로그아웃 했습니다."); 
		
		return "message";
	}
	
	
}
