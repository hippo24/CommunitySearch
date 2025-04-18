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

	<form action="<c:url value="/user/signup"/>" method="post">
		<h1>회원가입</h1>
		
		<div>여기에 아이디 regex 확인하는 친구를 넣겠습니다.</div>
		
		<div class="form-group mt-3">
		  <label for="id">아이디</label>
		  <input type="text" class="form-control" id="id" name="us_id" value="${id}" placeholder="아이디는 변경이 불가하니 신중히 입력해 주세요.">	
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
			  <input type="text" class="form-control" id="name" name="us_name" placeholder="미입력 시 임의의 이름으로 등록됩니다.">	
			  <label id="checkName" class="red"></label>	
			</div>
			
			
			<div class="form-group mt-3">
				<label for="email" class="form-label">이메일</label> 
				<input type="email" class="form-control" id="email" name="us_email">
				<button type="button" class="btn btn-sm btn-outline-primary email-send-btn">인증번호 보내기</button>
				
				<div class="mt-2 email-check-form">
				    <input type="text" class="form-control input-check-email" placeholder="인증번호 입력" />
				    <button type="button" class="btn btn-sm btn-outline-success mt-1 email-check-btn">인증 확인</button>
				    <div class="text-muted small mt-1 timer"> </div>
				    <div class="mt-1 email-result"></div>
				</div>
				
			</div>
			
			<button type="submit" class="btn btn-outline-success col-12 mb-3">회원가입</button>
		</c:if>
		
	</form>
	
	<div class="spinner-box">
		<div class="d-flex justify-content-center align-items-center h-100">
			<div class="spinner-border text-light" role="status">
				<span class="sr-only">로딩중...</span>
			</div>
		</div>
	</div>
	
	
		
	
	<!-- 이메일 인증 -->
	<script type="text/javascript">
		let ev_key = -1;
	
		let timer;
		let timeNow = 180; // 3분
		let emailCheck = false;
		
		
		$(".email-check-form").hide();
	
		
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
		    const email = $("#email").val().trim();
		    $("#email").val(email);
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
	
	<!-- 표현식 검사 -->
	<script type="text/javascript">
	
		function checkId() {
		    $("#checkId").text("");
		    let id = $("#id").val().trim();
		    $("#id").val(id);
		    if (!/^[a-zA-Z0-9]{5,13}$/.test(id)) {
		    	$("#checkId").hide();	
		    	return false;
		    }
	
		    let res = false;
	
		    $.ajax({
		        async: false,
		        url: '<c:url value="/user/check/id"/>',
		        type: 'post',
		        data: { us_id: id },
		        success: function(data) {
		            if (data) {
		                res = true;
		            }
		        }
		    });
	
		    let str = res ? "사용 가능한 아이디입니다." : "이미 사용중인 아이디입니다.";
		    
		    $("#checkId").css("color", res?"green":"red").text(str);
		    $("#checkId").show();		    	
	    
		    return res;
		}
				
		function checkName(value){
			$("#checkName").text("");	
			
			let res2 = false;		
			$.ajax({	
				async : false,  
				url : '<c:url value="/user/check/name"/>', 
				type : 'post', 
				data : { us_name : value }, 
				success : function (data){
					if(data){
						res2 = true;
					}
				}, 
				error : function(jqXHR, textStatus, errorThrown){
				}
			});
			
				

			let str2 = res2 ? "사용 가능한 유저명입니다." : "이미 사용중인 유저명입니다.";
			$("#checkName").removeClass("green red").addClass(res2 ? "green" : "red").text(str2);
			
			
			return res2;
		}
			
		
		
		$(document).ready(function() {

		    // 아이디 중복 확인 
		    $("#id").on("input", function() {
		        checkId();
		    });

		    // 유저명 중복 확인
		    $("#name").on("blur", function() {
		    	const name = $(this).val().trim();
		        $(this).val(name); 
		        checkName(name);
		    });

		    // Validate
		    $("form").validate({
		        rules: {
		            us_id: {
		                required: true,
		                regex: /^[a-zA-Z0-9]{5,13}$/,
		            },
		            us_pw: {
		                required: true,
		                regex: /^[a-zA-Z0-9!@#$]{8,20}$/
		            },
		            us_pw2: {
		                equalTo: "#pw"
		            },
		            us_name: {
		                chkDup: true
		            },
		            us_email: {
		                required: true,
		                email: true
		            }
		        },
		        messages: {
		            us_id: {
		                required: "필수 항목입니다.",
		                regex: "아이디는 영문, 숫자만 가능하며, 5~13자입니다."
		            },
		            us_pw: {
		                required: "필수 항목입니다.",
		                regex: "비번은 영문, 숫자, 특수문자(!@#$)만 가능하며, 8~20자입니다."
		            },
		            us_pw2: {
		                equalTo: "비번과 비번확인이 일치하지 않습니다."
		            },
		            us_name: {
		                chkDup: "중복된 유저명입니다."
		            },
		            us_email: {
		                required: "필수 항목입니다.",
		                email: "이메일 형식이 아닙니다."
		            }
		        },
		        submitHandler: function() {
		        	["#id", "#pw", "#pw2", "#name", "#email"].forEach(sel => {
		                const el = $(sel);
		                el.val(el.val().trim());
		            });

		            let idOk = checkId();
		            let nameOk = checkName($("#name").val());

		            if (!emailCheck) {
		                alert("이메일 인증을 완료해주세요.");
		                return false;
		            }

		            return idOk && nameOk;
		        }
		    });

		    $.validator.addMethod("regex", function(value, element, regex) {
		    	
		        return this.optional(element) || new RegExp(regex).test(value);
		    });

		   $.validator.addMethod("chkDup", function(value, element) {
		        return checkName(value);
		    }, "이미 사용 중인 유저명입니다."); 
		});

	
	</script>
	
</body>
</html>