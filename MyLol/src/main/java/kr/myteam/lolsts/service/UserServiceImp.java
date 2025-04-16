package kr.myteam.lolsts.service;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import kr.myteam.lolsts.dao.UserDao;
import kr.myteam.lolsts.model.vo.UserVO;

@Service
public class UserServiceImp implements UserService{

	@Autowired
	private UserDao userDao;

	@Autowired
	BCryptPasswordEncoder passwordEncoder;
	
	@Override
	public boolean signup(UserVO user) {
		
		if(user==null) return false;
		if(user.getUs_name().trim()==null||user.getUs_name().trim().equals("")) {
			//여기에 아이디 + 랜덤 문자열을 붙여넣기
			user.setUs_name("익명_"+ UUID.randomUUID().toString().replace("-", "").substring(0, 12));
			System.out.println(user.getUs_name());
		}
		
		//비번 암호화
		String encPw = passwordEncoder.encode(user.getUs_pw());
		user.setUs_pw(encPw);

		try {
			return userDao.insertUser(user);
		}catch (Exception e) {	//가입된 아이디로 가입한 경우
			e.printStackTrace();		
			return false;
		}
	}

	@Override
	public boolean checkBy(String checker, String type) {
		UserVO user = userDao.selectUserBy(checker,type);
		return user == null;
	}

	@Override
	public UserVO login(UserVO user) {
		if(user==null) return null;

		UserVO newUser = userDao.selectUserBy(user.getUs_id(), "us_id");
		
		if(newUser==null) return null;
		
		if(!passwordEncoder.matches(user.getUs_pw(), newUser.getUs_pw() )) return null;
		
		return newUser;
	}

	@Override
	public boolean updateUserCookie(UserVO user) {

		if(user==null) return false;
		
		System.out.println("쿠키 존재");
		return userDao.updateUserCookie(user);
		
	}

	@Override
	public UserVO getUserByCookie(String us_cookie) {
		if(us_cookie == null) return null;
		
		return userDao.selectUserByCookie(us_cookie);
	}


}
