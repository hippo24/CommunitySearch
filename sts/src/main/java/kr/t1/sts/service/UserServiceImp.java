package kr.t1.sts.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import kr.t1.sts.dao.UserDao;
import kr.t1.sts.model.vo.UserVO;

@Service
public class UserServiceImp implements UserService{

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
		String encPw = passwordEncoder.encode(user.getUs_pw());
		user.setUs_pw(encPw);
		
		try {
			
			return userDao.insertUser(user);
			
		}catch(Exception e){	//가입된 아이디로 가입한 경우
			e.printStackTrace();		// 에러문구 뜨는게 거술리면 주석처리
			return false;
		}
		
	}

	@Override
	public UserVO login(UserVO member) {
		if(member==null) return null;
		//아이디 비번 유효성검사할필요 x -> 같은지 다른지만 비교하면 됨
		
		UserVO user = userDao.selectMember(member.getUs_id());	//널체크 굳이 안하고 넘겨도 됨(어차피 아이디랑 일치 안해서 뱉어짐)
		
		if(user == null) {	//아이디가 다른 경우의 처리
			return null;
		}
		
		if(!passwordEncoder.matches(member.getUs_pw(), user.getUs_pw())) {	//비밀번호가 다른 경우의 처리	->순서 바뀌면 안됨. 왼쪽이 암호화 안된 문자열 오른쪽이 암호화 된 문자열.
			return null;
		}
		
		return user;
	}

	@Override
	public boolean checkId(String id) {
		// TODO Auto-generated method stub
		return false;
	}

	
}
