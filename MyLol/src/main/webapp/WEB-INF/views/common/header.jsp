<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<style>
		.dropdown-submenu {
		  position: relative;
		}
		
		.dropdown-submenu .dropdown-menu {
		  top: 0;
		  left: 100%;
		  margin-top: -1px;
		  margin-left : 3px;
		}
	</style>
	
	<style>
		/* 오른쪽에 숨겨진 사이드바 기본 설정 */
		.sidebar {
		  position: fixed;
		  top: 0;
		  right: -250px; /* 처음에는 화면 밖에 숨겨둠 */
		  width: 250px;
		  height: 100%;
		  background-color: #343a40;
		  transition: right 0.3s ease;
		  z-index: 1050; /* 네비바 위로 */
		}
		
		/* 사이드바가 열렸을 때 클래스 */
		.sidebar.show {
		  right: 0;
		}
	</style>

</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
		<div class="container-fluid">
		  <a class="navbar-brand" href="<c:url value="/" />">Home</a>
		
		  <!-- 햄버거 토글 버튼 -->
		  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
		    <span class="navbar-toggler-icon"></span>
		  </button>
		
		  <div class="collapse navbar-collapse" id="collapsibleNavbar">
		    <ul class="navbar-nav mr-auto">
	        <%-- <li class="nav-item">
	          <a class="nav-link" href="<c:url value="/"/>">전적검색 돌아가기</a>
	        </li> --%>
	        <!-- 좌측 로고 및 페이지 전환 -->
			<div class="d-flex align-items-center">
				<c:choose>
					<c:when test="${pageType != 'tft'}">
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
			  </ul>
	       	<!-- 사이드바 토글 버튼 (오른쪽 끝) -->
			<!-- 사이드바 토글 버튼 -->
			<button type="button" class="btn btn-outline-light ml-auto" id="sidebarToggle">
			  ☰
			</button>

			
	    </div>
	  </div>
	</nav>
	<!-- 오른쪽 사이드바 -->
	<div id="sidebar" class="sidebar">
 	  <div class="text-right p-2">
	    <button class="btn btn-sm text-white" id="sidebarClose">×</button>
	  </div>
	
	  <h5 class="text-white mt-4 ml-3">메뉴</h5>
	  <ul class="navbar-nav pl-3">
	    <c:if test="${user == null}">
	        <li class="nav-item">
	          <a class="nav-link text-blue" href="<c:url value="/user/signup"/>">회원가입</a>
	        </li>
	        <li class="nav-item">
	          <a class="nav-link text-blue" href="<c:url value="/user/login"/>">로그인</a>	<!-- 차후 직접 로그인 메뉴를 여기에 가져오기 -> 입력한 정보를 login.jsp로 보냄-->
	        </li>  
        </c:if>
	    <c:if test="${user != null}">
	      <li class="nav-item">
	        <a class="nav-link text-white" href="<c:url value='/user/mypage' />">마이 페이지</a>
	      </li>
	      <li class="nav-item">
	        <a class="nav-link text-white" href="<c:url value='/user/logout' />">로그아웃</a>
	      </li>
	    </c:if>
	
	    <li class="nav-item">
	      <a class="nav-link text-white" href="#">커뮤니티 게시판 목록</a>
	      <ul class="navbar-nav ml-3">
	        <li class="nav-item">
			  <a class="nav-link text-white" href="<c:url value='/post/list?num=0' />">전체 게시판</a>
			</li>
			<c:forEach items="${boardList}" var="board">
			  <li class="nav-item">
			    <a class="nav-link text-white" href="<c:url value='/post/list?num=${board.bo_key}' />">${board.bo_name}</a>
			  </li>
			</c:forEach>
		    <!-- 일반 메뉴 -->
	    	  <li class="nav-item">
			    <a class="nav-link text-white" href="<c:url value='/post/duo' />">듀오모집게시판1</a>
			  </li>
			  <li class="nav-item">			  
			    <a class="nav-link text-white" href="<c:url value='/exampleTFT' />">TFT 배치 툴</a>
			  </li>
	      </ul>
	    </li>
	
	    <c:if test="${user ne null && user.us_authority eq 'ADMIN'}">
		  <li class="nav-item mt-2">
		    <a class="nav-link text-white" href="#">관리자 메뉴</a>
		    <ul class="navbar-nav ml-3">
		      <li class="nav-item">
		        <a class="nav-link text-white" href="<c:url value='/admin/board' />">게시판 관리</a>
		      </li>
		      <li class="nav-item">
		        <a class="nav-link text-white" href="<c:url value='/admin/post' />">게시글 관리</a>
		      </li>
		    </ul>
		  </li>
		</c:if>

	  </ul>
	</div>



	<script>
	  $('.dropdown-submenu .dropdown-toggle').on("click", function(e) {
	    e.stopPropagation();
	    e.preventDefault();
	    $(this).next('.dropdown-menu').slideToggle();
	  });
	</script>
	
	<script>
	  $(function(){
	      $(document).on("click", "#sidebarToggle", function() {
		      $("#sidebar").toggleClass("show");
	      });
	      $(document).on('click', '#sidebarClose', function () {
	          $('#sidebar').removeClass('show');
	      });
	  });

	</script>

</body>
</html>