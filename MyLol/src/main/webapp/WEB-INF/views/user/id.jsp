<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<style type="text/css">

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

	<div>	
		<h1>아이디찾기</h1>

		<div class="form-group mt-3">
			<label for="email" class="form-label">이메일주소</label> 
			<input type="email" class="form-control" id="email" placeholder="가입시 입력한 이메일 주소를 입력해 주세요.">	
		</div>
		<button type = "button" class="btn-find-id btn btn-outline-success mt-3 col-12">아이디찾기</button>
	</div>
	
	<div class="result-box mt-4"></div>

	<div class="spinner-box">
		<div class="d-flex justify-content-center align-items-center h-100">
			<div class="spinner-border text-light" role="status">
				<span class="sr-only">로딩중...</span>
			</div>
		</div>
	</div>
	
	
	
	<script type="text/javascript">
		function isValidEmail(email) {
			const regex = /^[^\s@]+@[^\s@]+$/;	// ___@___ 형식 검증
			return regex.test(email);
		}
	
	
		$(".btn-find-id").click(function(e){
			const email = $("#email").val().trim();

			if (!email) {
				alert("이메일을 입력하세요.");
				return;
			}

			if (!isValidEmail(email)) {
				alert("올바른 이메일 형식을 입력해주세요.");
				return;
			}

			$(".spinner-box").show();
			$(".btn-find-id").prop("disabled", true);

			$.ajax({
				url: "<c:url value='/user/find/id'/>",
				method: "post",
				data: { email: email },
				success: function (data) {
					let html = "";

					if (data && data.length > 0) {
						html += "<h5>이메일과 일치하는 아이디:</h5><ul class='list-group'>";
						data.forEach(function (id) {
							html += "<li class='list-group-item'>" + id + "</li>";
						});
						html += "</ul>";
					} else {
						html = "<div class='alert alert-warning mt-3'>해당 이메일로 등록된 아이디가 없습니다.</div>";
					}

					$(".result-box").html(html);
				},
				error: function () {
					alert("요청 중 오류가 발생했습니다.");
				},
				complete: function () {
					$(".spinner-box").hide();
					$(".btn-find-id").prop("disabled", false);
				}
			});
		});
	</script>
	

</body>
</html>