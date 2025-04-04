package kr.t1.sts.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import kr.t1.sts.dao.UserDao;
import kr.t1.sts.model.vo.UserVO;

@Service
public class UserServiceImp {

	@Autowired
	UserDao userDao;
	
	@Autowired
	BCryptPasswordEncoder passwordEncoder;
	
	@Override
	public boolean signup(UserVO user) {
		if(user==null) {
			return false;
		}
		//아이디 비번 유효성검사(했다치고)
		
		
		//비번 암호화
		String encPw = passwordEncoder.encode(user.getMe_pw());
		user.setMe_pw(encPw);
		
		try {
			
			return userDao.insertUser(user);
			
		}catch(Exception e){	//가입된 아이디로 가입한 경우
			e.printStackTrace();		// 에러문구 뜨는게 거술리면 주석처리
			return false;
		}
		
	}

	
}
