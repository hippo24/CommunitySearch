<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/additional-methods.min.js"></script>
	<style type="text/css">
		.error, .red{color : red;} 
		.green{color : green;}
	</style>	
</head>
<body>

	<form action="<c:url value="/user/signup"/>" method="post">
		<h1>회원가입</h1>
		
		<div>여기에 아이디 regex 확인하는 친구를 넣겠습니다.</div>
		
		<div class="form-group mt-3">
		  <label for="id">아이디</label>
		  <input type="text" class="form-control" id="id" name="us_id" value="${id}">	
		  <label id="checkId" class="red"></label>	
		</div>
		<!-- button type="button" class="btn btn-outline-success col-12" id="check">아이디 중복 확인</button -->
		

		<div class="form-group mt-3">
			<label for="pw" class="form-label">비밀번호</label> 
			<input type="password" class="form-control" id="pw" name="us_pw">
		</div>

		<div class="form-group mt-3">
			<label for="pw2" class="form-label">비밀번호 확인</label> 
			<input type="password" class="form-control" id="pw2" name="us_pw2">
		</div>
		
		<!-- 이 밑의 내용은 아이디 중복검사, 비밀번호 비밀번호 확인 regex가 통과된 뒤에 c:if로 띄울 것임 -->
		
		<c:if test="${true}">
			
			<div class="form-group mt-3">
			  <label for="name">유저명</label>
			  <input type="text" class="form-control" id="name" name="us_name" value="${name}">	
			  <label id="checkName" class="red"></label>	
			</div>
			
			
			<div class="form-group mt-3">
				<label for="email" class="form-label">이메일</label> 
				<input type="email" class="form-control" id="email" name="us_email">
			</div>
			
			<button type="submit" class="btn btn-outline-success col-12 mb-3">회원가입</button>
		</c:if>
		
	</form>
	
	
	<script type="text/javascript">
	
		$("#id").on("input", function(e){	//#check -> #id : 중복체크 버튼 없애려고
			checkId();			//중복체크는 나중에
		});	
		function checkId(){			// 유효성검사에도 필요한 기능이기 때문에 외부에 함수로 만들어서 나중에 재사용 가능하게
			// 입력한 아이디를 가져옴
			$("#checkId").text("");	//시작 전 빈문자열로
			let id = $("#id").val();
			
			if(!/^[a-zA-Z0-9]{5,13}$/.test(id)){	//정규표현식 맞지 않으면 체크자체를 안 돌림
				return false;
			}
			
			let res = false;		
			
			$.ajax({
				async : false, 
				url : '<c:url value="/user/check/id"/>', 
				type : 'post', 
				data : { us_id : id }, 
				success : function (data){
					if(data){
						res = true;
					}
				}, 
				error : function(jqXHR, textStatus, errorThrown){
				}
			});
			let str;
			
			if(res){	
				str = "사용 가능한 아이디입니다.";	

				$("#checkId").removeClass("green red").addClass(res ? "green" : "red");
			}else{
				str = "이미 사용중인 아이디입니다.";
				
				$("#checkId").removeClass("green red").addClass(res ? "green" : "red");
			}
			$("#checkId").text(str);	
			
			return res;
			}
			
			$("#name").on("input", function(e){	//#check -> #id : 중복체크 버튼 없애려고
				let us_name = $("#name").val();
				checkName(us_name);			//중복체크는 나중에
			});
			
			function checkName(value){
				// 입력한 아이디를 가져옴
				$("#checkName").text("");	//시작 전 빈문자열로
			
				let res = false;		
				//비동기 통신으로 아이디를 전송하고, 서버에서 보낸 결과를 이용하여 처리
				$.ajax({	//여기는 j쿼리 코드
					async : false, // true(비동기), false(동기)	//중복검사 마친 뒤에 회원가입 해야 하니 동기로 
					//비동기로 하면 이거 이뤄지기 전에 다음꺼 해버리니 무조건 있는 아이디라고 출력됨
					url : '<c:url value="/user/check/name"/>', 
					type : 'post', 
					data : { us_name : value }, 
					success : function (data){
						if(data){
							res = true;
						}
					}, 
					error : function(jqXHR, textStatus, errorThrown){
					}
				});
				let str;
				
				if(res){	
					str = "사용 가능한 유저명입니다.";	
	
					$("#checkName").removeClass("green red").addClass(res ? "green" : "red");
				}else{
					str = "이미 사용중인 유저명입니다.";
					
					$("#checkName").removeClass("green red").addClass(res ? "green" : "red");
				}
				$("#checkName").text(str);	
				
				return res;
			}
			
			
			
			
			
			$("form").validate({			//23.회원가입_validate 가져옴
				rules : {
					us_id : {
						required : true,
						regex : /^[a-zA-Z0-9]{5,13}$/ 
	
					},	
					us_pw : {	
						required : true,
						regex : /^[a-zA-Z0-9!@#$]{8,20}$/ 
					},
					us_pw2 : {
						equalTo : pw		// 아이디값이라 us_pw아니라 pw(name은 중복될 수 있지만 id는 하나만 있을수 있어서)
					},
					us_name : {	
						required : false,				//필수는 아닌게 .trim()이 ""이면 service에서 소환사(10자리 랜덤 문자열) 로 넣어줄 예정 -> 빈 문자열인 유저명은 없으니 중복검사에 안 걸림
						chkDup : true
					},
					us_email : {
						required : true,
						email : true
					}
				},	
				messages : {
					us_id : {
						required : "필수 항목입니다.",
						regex : "아이디는 영문, 숫자만 가능하며, 5~13자입니다."
					},
					us_pw : {
						required : "필수 항목입니다.",
						regex : "비번은 영문, 숫자, 특수문자(!@#$)만 가능하며, 8~20자입니다."
					},
					us_pw2 : {
						equalTo : "비번과 비번확인이 일치하지 않습니다."
					},
					us_name : {
						chkDup : "중복된 아이디입니다."
					},
					us_email : {
						required : "필수 항목입니다.",
						email : "이메일 형식이 아닙니다."
					}
	
				},
				submitHandler : function(){	//submitHandler : 유효성 검사 후 전송하기 직전 확인하고 싶을때 : return true여야 전송.
	
					//return checkId();		//일단 회원가입 기능 구현만 하고 체크는 나중에
					return true;
				}
			})
			$.validator.addMethod("regex", function(value, element, regex){
				var re = new RegExp(regex);	//정규표현식 생성자 RegEXP
				return this.optional(element) || re.test(value);
			}, "정규표현식을 확인하세요.")
			
			$.validator.addMethod("chkDup", function(value, element) {
	        	return checkName(value);
				
			}, "이미 사용 중인 유저명입니다.");
		});
			
	</script>
	
	
	<script type="text/javascript">
		$(document).ready(function() {
		    // 아이디 칸에서 빠져나가면 중복 체크
		    $("#id").on("blur", function() {
		        checkId();
		    });
	
		    // 이름 칸에서도 같은 방식 적용
		    $("#name").on("blur", function() {
		        checkName($("#name").val());
		    });
		});
	
	</script>
	
</body>
</html>