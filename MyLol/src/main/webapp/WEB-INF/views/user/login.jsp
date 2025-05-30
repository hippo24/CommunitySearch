<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/additional-methods.min.js"></script>
</head>
<body>
	<form action="<c:url value="/user/login"/>" method="post">	

		<h1>로그인</h1>
		<div class="form-group mt-3">
			<label for="id" class="form-label">아이디</label> 
			<input type="text" class="form-control" id="id" name="us_id" value="${id}">	
		</div>

		<div class="form-group mt-3">
			<label for="pw" class="form-label">비밀번호</label> 
			<input type="password" class="form-control" id="pw" name="us_pw">
		</div>
		
		<div class="form-check">
			<label for="auto" class="form-check-label"> 
				<input type="checkbox" class="form-check-input" id="auto" name="auto" value="true">자동로그인
			</label>
		</div>

		<button type = "submit" class="btn btn-outline-success mt-3 col-12">로그인</button>
	</form>
	<a href="<c:url value="/user/find/id"/>" class="d-inline">아이디 찾기</a>
	<div class="d-inline">/</div>
	<a href="<c:url value="/user/find/howtofindpw"/>" class="d-inline">비밀번호 찾기</a>

</body>
</html>