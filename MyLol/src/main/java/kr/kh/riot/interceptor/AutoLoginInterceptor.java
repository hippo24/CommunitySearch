package kr.kh.riot.interceptor;

import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.util.WebUtils;

import kr.kh.riot.model.vo.BoardVO;
import kr.kh.riot.model.vo.UserVO;
import kr.kh.riot.service.PostService;
import kr.kh.riot.service.UserService;

public class AutoLoginInterceptor extends HandlerInterceptorAdapter{
	
	@Autowired
	private UserService userService;
	

	@Autowired
	private PostService postService;
	
	
	@Override
	public void postHandle(	
	    HttpServletRequest request, 
	    HttpServletResponse response, 
	    Object handler, 
	    ModelAndView modelAndView)
	    throws Exception {
		 //구현   

			
		
	}

	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {																			
			
			//세션에 있는 회원 정보를 가져옴
			HttpSession session = request.getSession();
			

			//페이지 넘어갈때 게시판 정보 넘겨주기
			//HttpSession session = request.getSession();
			List<BoardVO> boardList = postService.getBoardList();
			if(!boardList.isEmpty())session.setAttribute("boardList", boardList);		
			
			
			UserVO newUser = (UserVO)session.getAttribute("user");

			//자동로그인 전에 이미 로그인되어 있으면
			if(newUser != null) return true;
			
			Cookie cookie = WebUtils.getCookie(request, "LC");	//로그인쿠키
			//LC쿠키가 없으면 => 자동로그인 체크한적 없으면
			if(cookie==null) return true;
			System.out.println(cookie);
			String cookieId = cookie.getValue();
			newUser = userService.getUserByCookie(cookieId);
			System.out.println(newUser);
			if(newUser != null) {					//쿠키 기한인 1주일이 지나면 
				session.setAttribute("user", newUser);
			}
		
			return true;
	}//이제 이걸 survlet에 url등록하면
}