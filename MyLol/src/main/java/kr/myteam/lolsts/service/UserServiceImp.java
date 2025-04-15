package kr.myteam.lolsts.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.myteam.lolsts.dao.UserDao;
import kr.myteam.lolsts.model.vo.UserVO;

@Service
public class UserServiceImp implements UserService{

	@Autowired
	private UserDao userDao;

	@Override
	public boolean signup(UserVO user) {
		
		if(user==null) return false;
		if(user.getUs_name()==null) {
			//여기에 아이디 + 랜덤 문자열을 붙여넣기
		}
		return userDao.insertUser(user);
	}

	@Override
	public boolean checkBy(String checker, String type) {
		UserVO user = userDao.selectUserBy(checker,type);
		return user == null;
	}


}
