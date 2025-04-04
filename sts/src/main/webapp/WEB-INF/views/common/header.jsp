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
      <a class="btn btn-outline-success form-inline my-2 my-sm-0" href="<c:url value="/login"/>">로그인</a>
      <a class="btn btn-outline-success form-inline my-2 my-sm-0" href="<c:url value="/signup"/>">회원가입</a>
  </c:if>
  <c:if test="${user != null}">
      <a class="btn btn-outline-info form-inline my-2 my-sm-0" href="<c:url value="/logout"/>">로그아웃</a>
  </c:if>
</nav>

</body>  
</html>

