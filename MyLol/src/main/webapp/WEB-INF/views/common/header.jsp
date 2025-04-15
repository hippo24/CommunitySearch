<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container-fluid">
    <a class="navbar-brand" href="<c:url value="/" />">Home</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#collapsibleNavbar">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="collapsibleNavbar">
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link" href="<c:url value="/"/>">전적검색 돌아가기</a>
        </li>
        <c:if test="${user == null}">
	        <li class="nav-item">
	          <a class="nav-link" href="<c:url value="/user/signup"/>">회원가입</a>
	        </li>
	        <li class="nav-item">
	          <a class="nav-link" href="<c:url value="/user/login"/>">로그인</a>	<!-- 차후 직접 로그인 메뉴를 여기에 가져오기 -> 입력한 정보를 login.jsp로 보냄-->
	        </li>  
        </c:if>
        <c:if test="${user != null }">
        	<li class="nav-item">
	          <a class="nav-link" href="<c:url value="/mypage"/>">마이 페이지</a>
	        </li>
        	<li class="nav-item">
	          <a class="nav-link" href="<c:url value="/logout"/>">로그아웃</a>
	        </li>
	    </c:if>
	    <li class="nav-item dropdown">
	      <a class="nav-link dropdown-toggle" href="#" id="navbardrop" data-toggle="dropdown">
	        게시판 목록
	      </a>
	      <div class="dropdown-menu">
	      	<!-- 인터셉터로 모든 페이지 갈 때마다 게시판 메뉴를 session에 뿌려주고 그걸 foreach로 받아옴(게시판 구분은 뒤에 숫자로) -> 이렇게 하는 이유는 각 게시판에도 좌측 메뉴에 띄울거기때문(듀오모집은 별개) -->
	        <a class="dropdown-item" href="<c:url value="/exampleboard/1" />">게시판1</a>
	        <a class="dropdown-item" href="<c:url value="/exampleboard/2" />">게시판2</a>
	        <a class="dropdown-item" href="<c:url value="/exampleDUO" />">듀오모집게시판1</a>
	        
	      </div>
	    </li>
        
        <c:if test="${user ne null && user.me_authority eq 'ADMIN' }">
	        <li class="nav-item dropdown">
		      <a class="nav-link dropdown-toggle" href="#" id="navbardrop" data-toggle="dropdown">
		        관리자
		      </a>
		      <div class="dropdown-menu">
		        <a class="dropdown-item" href="<c:url value="/admin/board" />">게시판</a>
		      </div>
		    </li>
        </c:if>
        
	    
	    
      </ul>
    </div>
  </div>
</nav>

</body>
</html>