<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<style type="text/css">
	.fixed{position : fixed; top : 0; bottom : 0; left : 0; right : 0; display: none}
	.my-bg-dark{background : rgba(0,0,0,0.3)}
	.all{ position: absolute; top:0; bottom: 0; left: 0; right: 0}
	/*.fixed .spinner{position : absolute; top : 50%; left : 50%;}  */
	.fixed .spinner{ margin-left : calc(50vw - 25px); margin-top : calc(50vh - 25px) }
</style>

</head>
<body>

	<!-- 로그인.jsp 복붙해옴 -->
	<div>	
		<h1>비번찾기</h1>
		<div class="form-group mt-3">
			<label for="id" class="form-label">아이디</label> 
			<input type="text" class="form-control" id="id">	<!-- 비동기 통신 할거기 때문에 name 필요없음 -->
		</div>
		<button type = "button" class="btn-find-pw btn btn-outline-success mt-3 col-12">비번찾기</button>
	</div>
	
	<div class="fixed">
		<div class="my-bg-dark all"></div>
		<div class="spinner spinner-border text-muted"></div>
	</div>
	<script type="text/javascript">
	
	
		$(".btn-find-pw").click(function(e){
			$(".fixed").show();
			$.ajax({
				async : true,
				url : '<c:url value="/user/find/pw"/>',
				method : "post",
				data : { id : $("#id").val()},
				success : function(data){
					$(".fixed").hide();
					//console.log(data);
					if(data)alert("새 비번을 메일로 전송했습니다.");
					else alert("일치하는 계정을 찾지 못했습니다.");
				}
				
			});
			
			
		});
	
	</script>

</body>
</html>