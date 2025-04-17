<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
	<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
</head>

<body id="body"><!-- 기존거 가져와서 html만 남김 -->
<!-- 썸머노트 대신 스위퍼로 -->
	<c:choose>
		<c:when test="${post ne null}">
		<h1>게시글 상세</h1>
			<div>
			
				<div class="form-group mt-3">
					<label class="form-label">게시판</label> 
					<input type="text" class="form-control" value="${post.po_bo_name}" readonly>	<!-- 보낼거 아니기때문에 name 불필요 -->
				</div>
		
				<div class="form-group mt-3">
					<label class="form-label">제목</label> 
					<input type="text" class="form-control" value="${post.po_title}" readonly>	
				</div>
		
				<div class="form-group mt-3">
					<label class="form-label">작성자</label> 
					<input type="text" class="form-control" value="${post.po_us_key}" readonly>	
				</div>
		
				<div class="form-group mt-3">
					<label class="form-label">작성일</label> 
					<input type="text" class="form-control" value="<fmt:formatDate value="${post.po_date}" pattern="yyyy-MM-dd HH:mm:ss" />" readonly>	
				</div>
				
		
				<div class="form-group mt-3">
					<label class="form-label">조회수</label> 
					<input type="text" class="form-control" value="${post.po_view}" readonly>	
				</div>
				<div class="form-group mt-3 d-flex justify-content-center" id="btns">
					<button class="btn btn<c:if test="${like.li_state ne 1}">-outline</c:if>-success btn-up" data-state="1">추천(<span>${post.po_up}</span>)</button>
					<button class="btn btn<c:if test="${like.li_state ne -1}">-outline</c:if>-danger ml-3 btn-down" data-state="-1">비추천(<span>${post.po_down}</span>)</button>	<!-- 추천 비추천 한번에 처리하려고!! -->
				</div>
		


				<!-- ${fileList}  -->
				<c:if test="${fileList.size() != 0 }">
					<div class="mb-3">
						<!-- Swiper -->
						<div class="swiper mySwiper">
						  <div class="swiper-wrapper">
						  	<c:forEach items="${fileList}" var="file">
							    <div class="swiper-slide" style="background: #fff; text-align: center;">
									<img alt="첨부파일" width="auto" height="300" src="<c:url value="/download${file.fi_name }"/>">
							    </div>
							</c:forEach>
						  </div>
						  <div class="swiper-button-next"></div>
						  <div class="swiper-button-prev"></div>
						  <div class="swiper-pagination"></div>
						</div>
					</div>
				</c:if>
				
				</div>

		</c:when>
		<c:otherwise>
			<h1>등록되지 않았거나 삭제된 게시글입니다.</h1>
		</c:otherwise>
	</c:choose>
		
	<div class="d-flex justify-content-between">	<!-- display flex 이용해서 목록 수정 삭제 뒤쪽에 붙이려고 -->
		<a href="<c:url value="/post/list"/>" class="btn btn-outline-success">목록으로 돌아가기</a>
		<c:if test="${user.us_key eq post.po_us_key}">
			<div class="btns">
				<a href="<c:url value="/post/update/${post.po_key}"/>" class="btn btn-outline-info">수정</a>
				<a href="<c:url value="/post/delete/${post.po_key}"/>" class="btn btn-outline-danger">삭제</a>
			</div>
		</c:if>
	</div>
	<hr>
	<h3>댓글</h3>
	<div class="comment-container"></div>
	
	
	
	
	
	<script>
		var swiper = new Swiper(".mySwiper", {
		  spaceBetween: 30,
		  effect: "fade",
		  navigation: {
		    nextEl: ".swiper-button-next",
		    prevEl: ".swiper-button-prev",
		  },
		  pagination: {
		    el: ".swiper-pagination",
		    clickable: true,
		  },
		});
	</script>
	

	
	
</body>
</html>
