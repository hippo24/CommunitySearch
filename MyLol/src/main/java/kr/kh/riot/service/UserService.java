package kr.kh.riot.service;

import java.util.List;

import kr.kh.riot.model.vo.EmailVO;
import kr.kh.riot.model.vo.UserVO;

public interface UserService {

	boolean signup(UserVO user);

	boolean checkBy(String checker, String type);

	UserVO login(UserVO user);

	boolean updateUserCookie(UserVO newUser);

	UserVO getUserByCookie(String cookieId);

	boolean findPw(String id, String email);

	boolean updateUser(UserVO user, UserVO newUser);

	List<String> findId(String email);

	int sendEmail(EmailVO email);

	boolean checkEmail(EmailVO email);

}
