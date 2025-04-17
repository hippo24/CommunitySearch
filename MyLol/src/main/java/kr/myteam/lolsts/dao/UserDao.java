package kr.myteam.lolsts.dao;

import org.apache.ibatis.annotations.Param;

import kr.myteam.lolsts.model.vo.UserVO;

public interface UserDao {

	boolean insertUser(@Param("user")UserVO user);

	UserVO selectUserBy(@Param("checker")String checker, @Param("type")String type);

	boolean updateUserCookie(@Param("user")UserVO user);

	UserVO selectUserByCookie(@Param("us_cookie")String us_cookie);

	boolean updateUser(@Param("user")UserVO user);

}
