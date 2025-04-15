package kr.myteam.lolsts.model.vo;

import java.util.Date;

import lombok.Data;

@Data
public class UserVO {

	private String us_id;
	private String us_pw;
	private String us_name;
	private String us_email;
	private Date us_create;
	private String us_authority;
	private String us_cookie;
	private Date us_limit;
	private boolean auto;		//자동로그인을 위한 필드
	
}
