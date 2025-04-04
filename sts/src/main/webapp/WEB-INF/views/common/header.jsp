<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>  
<!DOCTYPE html>  
<html>  
<head>
  <meta charset="UTF-8">
</head>  
<body>  

<nav class="navbar navbar-expand-sm navbar-dark bg-dark sticky-top">
  <a class="navbar-brand" href="<c:url value='/'/>">
    <img src="<c:url value='/resources/img/Garen.jpg'/>" alt="logo" style="width:40px;">
  </a>

  <!-- 메뉴 항목 -->
  <ul class="navbar-nav mr-auto">
    <li class="nav-item">
      <a class="nav-link" href="<c:url value='/LOL'/>">LOL</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="<c:url value='/TFT'/>">TFT</a>
    </li>
  </ul>

  <!-- 로그인 폼 (오른쪽 끝) -->
  <c:if test="${user == null}">
    <form class="form-inline" action="<c:url value='/login'/>" method="post">
      <input type="text" class="form-control mr-sm-2" name="username" placeholder="아이디">
      <input type="password" class="form-control mr-sm-2" name="password" placeholder="비밀번호">
      <button class="btn btn-outline-success my-2 my-sm-0" type="submit">로그인</button>
    </form>
  </c:if>
</nav>

</body>  
</html>

