package kr.myteam.lolsts.interceptor;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.util.WebUtils;

import kr.myteam.lolsts.model.vo.UserVO;
import kr.myteam.lolsts.service.UserService;

public class AutoLoginInterceptor extends HandlerInterceptorAdapter{
	
	@Autowired
	private UserService userService;
	
	
	@Override
	public void postHandle(	//PostHadle은 컨트롤러에서 나올 때 가로채는 경우 호출
	    HttpServletRequest request, 
	    HttpServletResponse response, 
	    Object handler, 
	    ModelAndView modelAndView)
	    throws Exception {
		 //구현   

			
		
	}

	//컨트롤러로 들어가기전 가로채는 경우 호출이 됨
	//리턴이 true이면 가던 URL로 가서 실행
	//리턴이 false이면 가던 URL로 가지 못함. 보통 이 경우는 redirect로 다른 URL로 가라고 함.
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)	//preHandler 컨트롤러로 들어가기 전 가로채는 경우 호출
		throws Exception {																			//리턴 true이면 가던 url로 그대로 가서 실행. false이면 가던 url로 안감.(보통 이경우는 redirect로 다른 url로 보냄)(로그인 된 회원만 들어갈수 있는 페이지 같은 경우)
			
			//세션에 있는 회원 정보를 가져옴
			HttpSession session = request.getSession();
			UserVO newUser = (UserVO)session.getAttribute("user");

			//자동로그인 전에 이미 로그인되어 있으면
			if(newUser != null) return true;
			
			Cookie cookie = WebUtils.getCookie(request, "LC");	//로그인쿠키
			//LC쿠키가 없으면 => 자동로그인 체크한적 없으면
			if(cookie==null) return true;
			
			String cookieId = cookie.getValue();
			newUser = userService.getUserByCookie(cookieId);
			
			if(newUser != null) {					//쿠키 기한인 1주일이 지나면 
				session.setAttribute("user", newUser);
			}
		
			return true;
	}//이제 이걸 survlet에 url등록하면
}