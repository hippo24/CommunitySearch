package kr.myteam.lolsts.service;

import java.util.List;
import java.util.UUID;

import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import kr.myteam.lolsts.dao.UserDao;
import kr.myteam.lolsts.model.vo.EmailVO;
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
		System.out.println("cookie:"+us_cookie);
		return userDao.selectUserByCookie(us_cookie);
	}

	@Override
	public boolean findPw(String id, String email) {
		UserVO user = userDao.selectUserBy(id, "us_id");
		if(user == null || !user.getUs_email().equals(email)) return false;
		
		try {
			//새 비번을 생성
			String newPw = createPw(16, true);
			//System.out.println(newPw);
			//새 비번을 이메일로 전송
			boolean res = mailSend(user.getUs_email(), "새 비밀번호입니다." , "새 비밀번호는 <b>" + newPw + "</b> 입니다.");
			
			if(!res) return false; //이메일이 잘못됐거나 받는사람이 없는경우 실패
			//새 비번으로 db의 회원정보 업데이트
				//비밀번호 암호화 해서 전송
				newPw = passwordEncoder.encode(newPw);
				user.setUs_pw(newPw);
			return userDao.updateUser(user);
		
		}catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	private String createPw(int size, boolean isPw) {
		if(size<8 && isPw) return null;		//비번 정규표현식보다는 커야함
		String pw = "";
		while(pw.length() < size) {
			//랜덤 정수 생성(0~61)
			
			int r = (int)(Math.random()*(62)); //int r = (int)(Math.random()*(61 - 0 + 1) + 0);
			
			//0~9면 문자 0~9로 맵핑 후 이어붙임
			if(r < 10) pw += r;
			
			//10~35면 a~z로 맵핑 후 이어붙임
			else if (r < 36) pw += (char)(r - 10 + 'a');	//a부터 z까지의 문자
			//36~61이면 A~Z로 맵핑 후 이어붙임
			else pw += (char)(r - 36 + 'A');	//A부터 Z까지의 문자
		}
		return pw;
	}
	
	//메일 보내는 메소드
	@Autowired
	private JavaMailSender mailSender;

	private boolean mailSend(String to, String title, String content) {

		String setfrom = "jaewon8469@gmail.com";
		try{
	        MimeMessage message = mailSender.createMimeMessage();
	        MimeMessageHelper messageHelper
	            = new MimeMessageHelper(message, true, "UTF-8");			

	        messageHelper.setFrom(setfrom);// 보내는사람 생략하거나 하면 정상작동을 안함
	        messageHelper.setTo(to);// 받는사람 이메일
	        messageHelper.setSubject(title);// 메일제목은 생략이 가능하다
	        messageHelper.setText(content, true);// 메일 내용
	     							//,true가 있느냐 없느냐로 html 태그로 전송되느냐 아니냐가
	        mailSender.send(message);
	        return true;
	    } catch(Exception e){
	        e.printStackTrace();
	        return false;
	    }
	}


	@Override
	public boolean updateUser(UserVO user, UserVO newUser) {
		
		if(user==null || newUser==null) return false;
		user.setUs_email(newUser.getUs_email());
		user.setUs_name(newUser.getUs_name());
		
		//비번이 있으면(비번이 제대로 입력됐으면) 비번을 암호화해서 회원정보에 저장
		if(newUser.getUs_pw().length() != 0) {
			String encPw = passwordEncoder.encode(newUser.getUs_pw());
			user.setUs_pw(encPw);
		}
		return userDao.updateUser(user);
		
	}

	@Override
	public List<String> findId(String email) {
		// TODO Auto-generated method stub
		List<String> list = userDao.selectIdByEmail(email);
		
		for(int i = 0; i < list.size(); i++) {
			if(list.get(i).length()>4)
			list.set(i, "***" + list.get(i).substring(3)); 
			else 
			list.set(i, "너무 짧은 이메일 주소입니다."); 
		}
		
		return list;
	}

	@Override
	public int sendEmail(EmailVO email) {
		if(email == null || email.getEv_email().length() < 1) return 0;
		
		try {
			//코드 생성
			String code = createPw(6, false);
			boolean res = mailSend(email.getEv_email(), "이메일 인증." , "인증 번호는 <b>" + code + "</b> 입니다. 유출되지 않도록 해 주세요.");
			
			if(!res) return 0; //이메일이 잘못됐거나 받는사람이 없는경우 실패
			
			code = passwordEncoder.encode(code);
			email.setEv_authCode(code);

			userDao.insertEV(email);
			
			//System.out.println(email);
			
			return email.getEv_key();
			
		}catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
		
	}

	@Override
	public boolean checkEmail(EmailVO email) {
		
		if(email==null)return false;
		
		String encCode = userDao.selectEVCode(email.getEv_key());
		
		return passwordEncoder.matches(email.getEv_authCode(),encCode);
	}
	


}
