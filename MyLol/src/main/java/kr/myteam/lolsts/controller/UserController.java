package kr.myteam.lolsts.controller;

import java.util.Date;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.myteam.lolsts.model.vo.EmailVO;
import kr.myteam.lolsts.model.vo.UserVO;
import kr.myteam.lolsts.service.UserService;

@Controller
@RequestMapping("/user")
public class UserController {

	@Autowired
	private UserService userService;
	
	/*
	@Autowired
	private PasswordEncoder passwordEncoder;
	*/
	
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
		if(prevUrl != null && !prevUrl.contains("/user/login")) {		
			request.getSession().setAttribute("prevUrl", prevUrl);	
		}
		model.addAttribute("id", id);
		System.out.println(id);
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
	/*
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
	}*/
	
	@PostMapping("/login")
	public String loginPost(HttpServletRequest request, HttpServletResponse response, Model model, UserVO user) {
	    UserVO newUser = userService.login(user);

	    if (newUser != null) {
	        HttpSession session = request.getSession();

	        newUser.setAuto(user.isAuto());
	        session.setAttribute("user", newUser);
	        
	        // 자동 로그인 설정
	        if (user.isAuto()) {
	            Cookie cookie = new Cookie("LC", session.getId());
	            cookie.setPath("/");
	            cookie.setMaxAge(60 * 60 * 24 * 7); // 7일
	            response.addCookie(cookie);

	            newUser.setUs_cookie(session.getId());
	            Date date = new Date(System.currentTimeMillis() + 1000L * 60 * 60 * 24 * 7);
	            newUser.setUs_limit(date);
	            userService.updateUserCookie(newUser);
	        }
	        
	        model.addAttribute("url","/");
	        model.addAttribute("msg", "로그인 성공.");
	        return "message";  // 성공 시 메인으로
	    } else {
	        model.addAttribute("msg", "로그인에 실패했습니다.");
	        model.addAttribute("url", "/user/login?id=" + user.getUs_id());
	        return "message";  // 실패 시 메시지
	    }
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
	
	@GetMapping("/find/pw")
	public String findPw() {
		return "/user/pw";
	}

	@GetMapping("/find/id")
	public String findId() {
		return "/user/id";
	}
	
	@GetMapping("/find/howtofindpw")
	public String howToFindPw() {
		return "/user/howtofindpw";
	}
	
	@ResponseBody
	@PostMapping("/find/pw")
	public boolean findPwPost(@RequestParam String id, @RequestParam String email) {
		//System.out.println(id);
		return userService.findPw(id, email);
	}
	
	@ResponseBody
	@PostMapping("/find/id")
	public List<String> findIdPost(@RequestParam String email) {
		//System.out.println(email);
		return userService.findId(email);
	}
	
	@GetMapping("/mypage")
	public String mypage() {
		return "/user/mypage";		//이메일도 수정하게
	}
	
	@PostMapping("/mypage")
	public String mypagePost(Model model, UserVO newUser, HttpSession session) {
		UserVO user = (UserVO)session.getAttribute("user");
		if(userService.updateUser(user, newUser)) {
			model.addAttribute("msg","회원 정보 변경.");
		}else {
			model.addAttribute("msg","회원 정보 변경 실패.");
		}
		model.addAttribute("url","/user/mypage");
		
		return "message";		//알림창 띄우기 위해 msg.jsp로
	}
	
    @PostMapping("/email/send")
    @ResponseBody
    public String sendEmail(@RequestParam String email) {
        EmailVO newEmail = new EmailVO();
        newEmail.setEv_email(email);
        System.out.println(email);
        int evKey = userService.sendEmail(newEmail);
        System.out.println(evKey);
        if(evKey < 1) return null;
        return Integer.toString(evKey);
    }
    
    
    @PostMapping("/email/check")
    @ResponseBody
    public boolean checkEmail(@RequestParam int ev_key, @RequestParam String code) {
        EmailVO newEmail = new EmailVO();
        newEmail.setEv_key(ev_key);
        newEmail.setEv_authCode(code);
        return userService.checkEmail(newEmail);
    }
	
	
}
