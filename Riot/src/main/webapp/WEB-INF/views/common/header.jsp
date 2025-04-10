<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>
	<nav class="navbar navbar-expand-sm bg-dark navbar-dark">
	  <div class="container-fluid">
	    <!-- 좌측 로고 및 페이지 전환 -->
		<div class="d-flex align-items-center">
			<c:choose>
				<c:when test="${pageType == 'lol'}">
					
					<a class="navbar-brand" href="<c:url value='/lol/home'/>">
						<img src="https://cdn.dak.gg/lol/images/header/ico-lol.svg" alt="LOL 홈" style="height: 30px;">
					</a>
					<a class="btn btn-sm ms-2" href="<c:url value='/tft/home'/>">
						<img src="https://cdn.dak.gg/tft/images2/gnb/family/ico-tft.svg" alt="TFT 홈" style="height: 30px;">
					</a>
				</c:when>
				<c:when test="${pageType == 'tft'}">
					<a class="navbar-brand" href="<c:url value='/tft/home'/>">
						<img src="https://cdn.dak.gg/tft/images2/gnb/family/ico-tft.svg" alt="TFT 홈" style="height: 30px;">
					</a>
					<a class="btn btn-sm ms-2" href="<c:url value='/lol/home'/>">
						<img src="https://cdn.dak.gg/lol/images/header/ico-lol.svg" alt="LOL 홈" style="height: 30px;">
					</a>
				</c:when>
			</c:choose>
		</div>
	    <div class="collapse navbar-collapse" id="collapsibleNavbar">
	      <ul class="navbar-nav">
	        <li class="nav-item">
	          <a class="nav-link" href="<c:url value="/tft/summoner"/>">롤체 전적 조회</a>
	        </li>
	        
	        <li class="nav-item dropdown">
		      <a class="nav-link dropdown-toggle" href="#" id="navbardrop" data-toggle="dropdown">게시글</a>
		      <div class="dropdown-menu">
		        <a class="dropdown-item" href="<c:url value="/lol/board"/>">LOL</a>
		        <a class="dropdown-item" href="<c:url value="/tft/board"/>">TFT</a>
		      </div>
		    </li>
	        <c:if test="${user != null && user.me_authority == 'ADMIN'}">
		        <li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" href="#" id="navbardrop" data-toggle="dropdown">관리자</a>
					<div class="dropdown-menu">
					<a class="dropdown-item" href="<c:url value="/admin/board"/>">게시판</a>
					</div>
		   	 	</li>
	        </c:if>
	      </ul>
	    </div>
	  </div>
	</nav>
</body>
</html>