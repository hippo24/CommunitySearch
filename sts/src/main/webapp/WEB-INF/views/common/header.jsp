<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
</head>
<body>

<nav class="navbar navbar-expand-sm bg-dark navbar-dark">
  <!-- Brand/logo -->
  <a class="navbar-brand" href="<c:url value="/"/>">
    <img src="<c:url value="/resources/img/Garen.jpg"/>" alt="logo" style="width:40px;">
  </a>
  
  <!-- Links -->
  <ul class="navbar-nav">

		<!-- Dropdown -->
	    <li class="nav-item dropdown">
	      <a class="nav-link dropdown-toggle" href="#" id="navbardrop" data-toggle="dropdown">
	        Dropdown link
	      </a>
      <div class="dropdown-menu">
	      <a class="dropdown-item" href="<c:url value="/LOL"/>">LOL</a>
	      <a class="dropdown-item" href="<c:url value="/LOL2"/>">LOL2</a>
    	  <a class="dropdown-item" href="<c:url value="/TFT"/>">TFT</a>
    	  <a class="dropdown-item" href="<c:url value="/TFT2"/>">TFT2</a>
    	  <a class="dropdown-item" href="<c:url value="/TFT3"/>">TFT3</a>
    	  <a class="dropdown-item" href="<c:url value="/TFT4"/>">TFT4</a>
    	  <a class="dropdown-item" href="<c:url value="/TFT5"/>">TFT5</a>
    	  <a class="dropdown-item" href="<c:url value="/naver1"/>">네이버지도1</a>
    	  <a class="dropdown-item" href="<c:url value="/naver2"/>">네이버지도2</a>
		</div>
	    <li class="nav-item">
	      <a class="nav-link" href="<c:url value="/signup"/>">회원가입</a>
	    </li>
	    <li class="nav-item">
	      <a class="nav-link" href="<c:url value="/login"/>">로그인</a>
	    </li>
	    <li class="nav-item">
    	  <a class="nav-link" href="<c:url value="/logout"/>">로그아웃</a>
    	</li>
  </ul>
</nav>
</body>
</html>
