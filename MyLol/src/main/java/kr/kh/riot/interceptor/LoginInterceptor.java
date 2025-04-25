package kr.kh.riot.interceptor;

import java.util.Date;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import kr.kh.riot.model.vo.UserVO;
import kr.kh.riot.service.UserService;

public class LoginInterceptor extends HandlerInterceptorAdapter{
	
	@Autowired
	private UserService userService;
	
	
	@Override
	public void postHandle(	
	    HttpServletRequest request, 
	    HttpServletResponse response, 
	    Object handler, 
	    ModelAndView modelAndView)
	    throws Exception {
		System.out.println(123);
		 //구현   
	/*
		UserVO newUser = (UserVO)modelAndView.getModel().get("user");			
		
		HttpSession session = request.getSession();
		if(newUser == null) return;		
		session.setAttribute("user", newUser);
		
		//자동로그인이 체크되어 있지 않으면 종료
		if(!newUser.isAuto()) return;
		
		//자동로그인이 체크돼있으면 쿠키 생성해서 클라이언트에게 전송
		Cookie cookie = new Cookie("LC", session.getId());
		cookie.setPath("/");	
		int time = 60 * 60 * 24 * 7;		
		cookie.setMaxAge(time);		
			
		response.addCookie(cookie);
		
		//db에 자동 로그인 정보를 저장
		newUser.setUs_cookie(session.getId());
		//1주일 뒤 밀리초
		Date date = new Date(System.currentTimeMillis() + time * 1000);	//System.currentTimeMillis() : 현재 시간을 밀리초로 반환 -> time *1000 하면 1주일분의 밀리초
		newUser.setUs_limit(date);
		userService.updateUserCookie(newUser);
		System.out.println("쿠키 " +  cookie);	
		*/
	}

	//컨트롤러로 들어가기전 가로채는 경우 호출이 됨
	//리턴이 true이면 가던 URL로 가서 실행
	//리턴이 false이면 가던 URL로 가지 못함. 보통 이 경우는 redirect로 다른 URL로 가라고 함.
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)	//preHandler 컨트롤러로 들어가기 전 가로채는 경우 호출
			throws Exception {																			//리턴 true이면 가던 url로 그대로 가서 실행. false이면 가던 url로 안감.(보통 이경우는 redirect로 다른 url로 보냄)(로그인 된 회원만 들어갈수 있는 페이지 같은 경우)
			
			//구현
			return true;
	}
}