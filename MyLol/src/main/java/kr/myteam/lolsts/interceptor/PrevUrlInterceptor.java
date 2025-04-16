package kr.myteam.lolsts.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import kr.myteam.lolsts.model.vo.UserVO;

public class PrevUrlInterceptor extends HandlerInterceptorAdapter{

	@Override
	public void postHandle(	//PostHadle은 컨트롤러에서 나올 때 가로채는 경우 호출
	    HttpServletRequest request, 
	    HttpServletResponse response, 
	    Object handler, 
	    ModelAndView modelAndView)
	    throws Exception {
		 //구현   


		HttpSession session = request.getSession();
		UserVO newUser = (UserVO)modelAndView.getModel().get("user");				

		if(newUser == null) return;		

		//이전 url
		String prevUrl = (String)session.getAttribute("prevUrl");
		
		if(prevUrl == null) return;		//이전 url정보가 없으면
		
		response.sendRedirect(prevUrl);			// 이전 url로 보내고
		session.removeAttribute("prevUrl");		// 이전 url정보 지움
		
		
			
		
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