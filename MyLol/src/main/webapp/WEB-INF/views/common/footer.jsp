<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사이트맵</title>
<style>
  html, body {
    height: 100%;
    margin: 0;
    padding: 0;
  }
  .sitemap-container {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
  }
  .content {
    flex: 1;
  }
  footer {
    background-color: #343a40;
    color: white;
    padding: 1rem;
  }
  .footer-section {
    margin-bottom: 1.5rem;
  }
  .footer-section h5 {
    margin-bottom: 1rem;
  }
  .footer-section ul {
    list-style: none;
    padding-left: 0;
  }
  .footer-section ul li a {
    color: white;
    text-decoration: none;
  }
  .footer-section ul li a:hover {
    text-decoration: underline;
  }
  
  .footer div:last-child:hover {
	  filter: brightness(1.2);
	  cursor: pointer;
   	  position: absolute;
	  bottom: 0;
	  right: 0;
	  width: 300px; /*  */
	  height: 200px; /*  */
	  background-image: url('이미지_경로.jpg');
	  background-size: cover;
	  background-repeat: no-repeat;
	  background-position: center;
	  opacity: 0.8; /*  */
	  pointer-events: none; /*  */
	  z-index: -1; /*  */
	}
</style>
</head>
<body>
<div class="sitemap-container">
  <div class="content container">
  </div>

  <footer>
    <div class="container">
      <div class="row">
        <div class="col-md-4 footer-section">
          <h5>유저 관련</h5>
          <ul>
	          <c:if test="${user == null}">
	            <li><a href="<c:url value='/user/signup'/>">회원가입</a></li>
	            <li><a href="<c:url value='/user/login'/>">로그인</a></li>
	          </c:if>
              <c:if test="${user != null}">
	            <li><a href="<c:url value='/user/mypage'/>">마이페이지</a></li>
	            <li><a href="<c:url value='/user/logout'/>">로그아웃</a></li>
		      </c:if>
          </ul>
        </div>

        <div class="col-md-4 footer-section">
          <h5>커뮤니티</h5>
          <ul>
            <li><a href="<c:url value='/post/list?num=0'/>">전체 게시판</a></li>
            <c:forEach items="${boardList}" var="board">
              <li><a href="<c:url value='/post/list?num=${board.bo_key}'/>">${board.bo_name}</a></li>
            </c:forEach>
            <li><a href="<c:url value='/post/duo'/>">듀오모집 게시판</a></li>
          </ul>
        </div>

        <div class="col-md-4 footer-section">
          <h5>기타 기능</h5>
          <ul>
            <li><a href="<c:url value='/exampleTFT'/>">TFT 배치 툴</a></li>
          </ul>
        </div>
        <c:if test="${user ne null && user.us_authority eq 'ADMIN'}">
	        <div class="col-md-4 footer-section">
	          <h5>관리자</h5>
	          <ul>
	              <li><a href="<c:url value='/admin/board'/>">게시판 관리</a></li>
	              <li><a href="<c:url value='/admin/post'/>">게시글 관리</a></li>
    	      </ul>
	        </div>
        </c:if>
      </div>
    </div>
  </footer>
</div>

<footer class="text-center">
  ⓒ 2025 KH TaskGroup1. All rights reserved.
  
</footer>


</body>
</html>
