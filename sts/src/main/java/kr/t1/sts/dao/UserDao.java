package kr.t1.sts.dao;

import org.apache.ibatis.annotations.Mapper;

import kr.t1.sts.model.vo.UserVO;

//@Mapper
public interface UserDao {

	boolean insertUser(UserVO user);

	UserVO selectMember(String us_id);

}
