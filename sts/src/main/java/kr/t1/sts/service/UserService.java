package kr.t1.sts.service;

import kr.t1.sts.model.vo.UserVO;

public interface UserService {

	boolean signup(UserVO user);

	UserVO login(UserVO user);

	boolean checkId(String id);
	
	
}
