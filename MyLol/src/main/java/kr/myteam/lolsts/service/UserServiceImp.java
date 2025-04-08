package kr.myteam.lolsts.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.myteam.lolsts.dao.UserDao;

@Service
public class UserServiceImp implements UserService{

	@Autowired
	private UserDao userDao;
}
