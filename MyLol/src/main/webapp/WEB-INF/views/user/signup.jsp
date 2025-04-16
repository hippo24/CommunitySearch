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
			  <input type="text" class="form-control" id="name" name="us_name">	
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
	
	
		function checkId() {
		    $("#checkId").text("");
		    let id = $("#id").val();
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
		        checkName($("#name").val());
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
		        	let idOk = checkId();
		            let nameOk = checkName($("#name").val());
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