<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/additional-methods.min.js"></script>
	<style type="text/css">
		.error, .red{color : red;} /* 에러코드 잘보이게 ->validate는 일치하지 않을 때 #id-error.error로 라벨태그 추가해줌 */
		.green{color : green;}
	</style>	
</head>
<body>

	<form action="<c:url value="/mypage"/>" method="post">
		<h1>회원가입</h1>

		<div class="form-group mt-3">
			<label for="pw" class="form-label">새 비밀번호</label> 
			<input type="password" class="form-control" id="pw" name="me_pw">
		</div>

		<div class="form-group mt-3">
			<label for="pw2" class="form-label">비밀번호 확인</label> 
			<input type="password" class="form-control" id="pw2" name="me_pw2">
		</div>
		
		<div class="form-group mt-3">
			<label for="email" class="form-label">이메일</label> 
			<input type="email" class="form-control" id="email" name="me_email" value = "${user.me_email }">
		</div>
		
		<button type="submit" class="btn btn-outline-success col-12 mb-3">회원가입</button>
	</form>
	
	
	<script type="text/javascript">
	
		$("form").validate({
			rules : {

				me_pw : {	
					//required : true,	//비번 입력 안하면 기존비번 사용
					regex : /^[a-zA-Z0-9!@#$]{8,20}$/ 
				},
				me_pw2 : {
					equalTo : pw		// 아이디값이라 me_pw아니라 pw(name은 중복될 수 있지만 id는 하나만 있을수 있어서)
				},
				me_email : {
					required : true,
					email : true
				}
			},	
			messages : {
				me_pw : {
					//required : "필수 항목입니다.",
					regex : "비번은 영문, 숫자, 특수문자(!@#$)만 가능하며, 8~15자입니다."
				},
				me_pw2 : {
					equalTo : "비번과 비번확인이 일치하지 않습니다."
				},
				me_email : {
					required : "필수 항목입니다.",
					email : "이메일 형식이 아닙니다."
				}

			},
			submitHandler : function(){	//submitHandler : 유효성 검사 후 전송하기 직전 확인하고 싶을때 : return true여야 전송.

				return checkId();
			}
		})
		$.validator.addMethod("regex", function(value, element, regex){
			var re = new RegExp(regex);	//정규표현식 생성자 RegEXP
			return this.optional(element) || re.test(value);
		}, "정규표현식을 확인하세요.")
		
		
	</script>
	

</body>
</html>