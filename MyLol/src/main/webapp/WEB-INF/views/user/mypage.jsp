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
		.error, .red{color : red;} 
		.green{color : green;}
		.spinner-box {
			display: none;
			position: fixed;
			top: 0; left: 0; right: 0; bottom: 0;
			background: rgba(0, 0, 0, 0.3);
			z-index: 1000;
			justify-content: center;
			align-items: center;
		}
	</style>	
</head>
<body>

	<form action="<c:url value="/user/mypage"/>" method="post">
		<h1>회원 정보 변경</h1>

		<div class="form-group mt-3">
			<label for="pw" class="form-label">새 비밀번호</label> 
			<input type="password" class="form-control" id="pw" name="us_pw">
		</div>

		<div class="form-group mt-3">
			<label for="pw2" class="form-label">비밀번호 확인</label> 
			<input type="password" class="form-control" id="pw2" name="us_pw2">
		</div>
		
		<div class="form-group mt-3">
			<label for="us_name" class="form-label">유저명</label> 
			<input type="text" class="form-control" id="us_name" name="us_name" value = "${user.us_name }" placeholder="미입력 시 임의의 이름으로 등록됩니다.">
			<label id="checkName" class="red"></label>
		</div>
		
		<div class="form-group mt-3">
			<label for="email" class="form-label">이메일</label> 
			<input type="email" class="form-control" id="email" name="us_email" value = "${user.us_email }">
			<button type="button" class="btn btn-sm btn-outline-primary email-send-btn">인증번호 보내기</button>
			<div class="mt-2 email-check-form">
			    <input type="text" class="form-control input-check-email" placeholder="인증번호 입력" />
			    <button type="button" class="btn btn-sm btn-outline-success mt-1 email-check-btn">인증 확인</button>
			    <div class="text-muted small mt-1 timer"></div>
			    <div class="mt-1 email-result"></div>
			</div>
		</div>
		
		<button type="submit" class="btn btn-outline-success col-12 mb-3">회원 정보 변경</button>
	</form>
	
	<div class="spinner-box">
		<div class="d-flex justify-content-center align-items-center h-100">
			<div class="spinner-border text-light" role="status">
				<span class="sr-only">로딩중...</span>
			</div>
		</div>
	</div>
	
	<!-- 세션에서 값 받아오기 -->
	<script type="text/javascript">
	  const oriName = "${user.us_name}";
	  const oriEmail = "${user.us_email}";
	</script>
	
	
	
	<!-- 이메일 인증 -->
	<script type="text/javascript">
		let ev_key = -1;
	
		let timer;
		let timeNow = 180; // 3분
		let emailCheck = true;
		
		
		
		
		$(".email-check-form").hide();
		
		
		$("#email").on("input", function () {
			  const email = $(this).val().trim();
			  $(this).val(email);
			  if (email === oriEmail) {
			    $(".email-send-btn").prop("disabled", true);
			    $(".email-check-form").hide();
			    emailCheck = true; 
			  } else {
			    $(".email-send-btn").prop("disabled", false);
			    emailCheck = false;
			  }
			});
		
		
		function startTimer() {
		    clearInterval(timer);
		    timeNow = 180;
	
		    timer = setInterval(() => {
		        timeNow--;
		        const m = Math.floor(parseInt(timeNow) / 60);
		        const s = parseInt(timeNow) % 60;
		        
		        //console.log("minutes:", minutes, "seconds:", seconds); 
		        
		        const time = ("남은 시간 : " + String(m).padStart(2,"0") + ":" + String(s).padStart(2,"0"));
		        $(".timer").text(time);
		        //console.log(m, s, time, timeNow);
		        
		        //$(".timer").text(`남은 시간: ${minutes}:${seconds < 10 ? '0' : ''}${seconds}`);
		        if (timeNow <= 0) {
		            clearInterval(timer);
		            $(".timer").text("인증 시간이 만료되었습니다.");
		        }
		        
		        //console.log(timeNow);
		        
		    }, 1000);
		}

		$(".email-send-btn").click(function () {
			if(emailCheck) return;
			
		    const email = $("#email").val().trim();
		    let res = false;
		    if (!email) return alert("이메일을 입력하세요.");
		    
		    $(".spinner-box").show();
			$(".email-send-btn").prop("disabled", true);
		    
		    $.ajax({
		    	async: false,
				url: "<c:url value='/user/find/id'/>",
				method: "post",
				data: { email: email },
				success: function (data) {
					if (data && data.length > 0) {
						alert("해당 이메일 주소는 이미 사용중입니다.");
						res = true;
						return;
					} else {
						//res = true;
					}
				},
				error: function () {
					res = true;
					alert("요청 중 오류가 발생했습니다.");
				}
			});
		    if(res){
		    	alert("이메일 발송 실패")
		    	$(".spinner-box").hide();
				$(".email-send-btn").prop("disabled", false);
		    	return;
		    }
		   
			
		    $.ajax({
		    	async: true,
				url: "<c:url value='/user/email/send'/>",
				method: "post",
				data: { email: email },
				success: function (data) {
					if (data && data.length > 0) {
						alert("인증 번호를 보냈습니다.");
						ev_key = data;
						$("#email").prop("readonly", true);
						startTimer();
						return;
					} else{
						alert("인증 번호를 보내지 못했습니다.");
					}
				},
				error: function () {
					alert("요청 중 오류가 발생했습니다.");
				},
				complete: function(){
					
					$(".spinner-box").hide();
					$(".email-check-form").show();
				}
			});
		  
		
		});
		
	
		$(".email-check-btn").click(function () {
		    const email = $("#email").val().trim();
		    const code = $(".input-check-email").val().trim();
	
		    if (!code) return alert("인증번호를 입력하세요.");
	
		    if (timeNow <= 0) {
		    	clearInterval(timer);
		    	$(".timer").text("인증 시간이 만료되었습니다.");
		    	emailCheck = false;
		    	return;
		    }
		    
		    $.ajax({
		        async: false,
		        url: '<c:url value="/user/email/check"/>',
		        type: 'post',
		        data: { ev_key : ev_key , code : code },
		        success: function(data) {
		            if (data) {
		            	clearInterval(timer);
			            $(".email-result").text("이메일 인증되었습니다.").addClass("green").removeClass("red");
			            emailCheck = true;
			        } else {
			            $(".email-result").text("인증 번호가 다릅니다.").addClass("red").removeClass("green");
			        }
		        },
				error: function () {
					alert("요청 중 오류가 발생했습니다.");
				},
				complete: function(){
					
				}
		    });

		    
		});
		
	</script>
	
	
	<!-- 유저명 검사 -->
	<script type="text/javascript">
		let nameCheck = true;
	
		function checkName(value){
			value = value.trim();
			$("#checkName").text("");	
			
			if (value === oriName) {
				nameCheck = true;
				$("#checkName").text("기존 이름입니다.").addClass("green").removeClass("red");
				return true;
			}
			
			let res2 = false;		
			$.ajax({	
				async : false,  
				url : '<c:url value="/user/check/name"/>', 
				type : 'post', 
				data : { us_name : value }, 
				success : function (data){
					res2 = data === true;
					nameCheck = res2;
					
					let str2 = res2 ? "사용 가능한 유저명입니다." : "이미 사용중인 유저명입니다.";
					$("#checkName").removeClass("green red").addClass(res2 ? "green" : "red").text(str2);
					
				}, 
				error : function(jqXHR, textStatus, errorThrown){
					res2 = false;
				}
				
			});
			
			return res2;
		}
			
		
		$("#us_name").on("blur", function () {
			  const name = $(this).val().trim();
			  
			  checkName(name);
			  
			});

		
		
	</script>
	
	
	<!-- 표현식 검사 -->
	<script type="text/javascript">
	
		$("form").validate({
			rules : {

				us_pw : {	
					//required : true,	//비번 입력 안하면 기존비번 사용
					regex : /^[a-zA-Z0-9!@#$]{8,20}$/ 
				},
				us_pw2 : {
					equalTo : pw		
				},
				us_name: {
	                chkDup: true,
	                noSpace : true
	            },
	            us_email: {
	                required: {
	                  depends: function(elem) {
	                    return $(elem).val() !== oriEmail;
	                  }
	                },
	                email: {
	                  depends: function(elem) {
	                    return $(elem).val() !== oriEmail;
	                  }
	                },
	                noSpace : true
              }
			},	
			messages : {
				us_pw : {
					//required : "필수 항목입니다.",
					regex : "비번은 영문, 숫자, 특수문자(!@#$)만 가능하며, 8~20자입니다."
				},
				us_pw2 : {
					equalTo : "비번과 비번확인이 일치하지 않습니다."
				},
				us_name: {
	                chkDup: "중복된 유저명입니다."
	            },
				us_email : {
					required : "필수 항목입니다.",
					email : "이메일 형식이 아닙니다."
				}

			},
			submitHandler : function(){
				
				
	            
	            if (!emailCheck) {
	        		alert("이메일 인증을 완료해주세요.");
	        		return false;
	        	}
	            
	            const nameTrimmed = $("#us_name").val().trim();
	            $("#us_name").val(nameTrimmed); 
	            return checkName(nameTrimmed);
	        }
		});
		
		
		$.validator.addMethod("regex", function(value, element, regex){
			var re = new RegExp(regex);	//정규표현식 생성자 RegEXP
			return this.optional(element) || re.test(value);
		}, "정규표현식을 확인하세요.");
		
		$.validator.addMethod("chkDup", function(value, element) {
		        if(nameCheck) return true;
			 	return checkName(value);
		}, "이미 사용 중인 유저명입니다."); 
		
		$.validator.addMethod("noSpace", function(value, element) {
			return value.trim().length > 0;
		}, "공백만 입력할 수 없습니다.");
		
	</script>
	

</body>
</html>