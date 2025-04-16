package kr.myteam.lolsts.service;

import kr.myteam.lolsts.model.vo.UserVO;

public interface UserService {

	boolean signup(UserVO user);

	boolean checkBy(String checker, String type);

	UserVO login(UserVO user);

	boolean updateUserCookie(UserVO newUser);

	UserVO getUserByCookie(String cookieId);

}
