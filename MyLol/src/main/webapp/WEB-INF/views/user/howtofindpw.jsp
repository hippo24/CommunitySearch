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
	<div>
		<h1>비번찾기</h1>

		<a href = "<c:url value="/user/find/pw"/>" class="btn-find-pw btn btn-outline-success mt-3 col-12">아이디와 이메일로 비번찾기</a>

	</div>
	

</body>
</html>