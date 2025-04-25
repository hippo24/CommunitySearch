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

<body id="body">
	<c:choose>
		<c:when test="${post ne null}">
		<h1>게시글 상세</h1>
			<div>
				<div class="form-group mt-3">
					<label class="form-label">게시판</label> 
					<div class="form-control" value="${post.po_bo_name}" >${post.po_bo_name}</div>	<!-- 보낼거 아니기때문에 name 불필요 -->
				</div>
				<div class="form-group mt-3">
					<label class="form-label">제목</label> 
					<div class="form-control" value="${post.po_title}">${post.po_title}</div>
				</div>
				<div class="form-group mt-3">
					<label class="form-label">작성자</label> 
					<div class="form-control" value="${post.po_us_name}">${post.po_us_name}</div>	
				</div>
				
				
				<!-- post.po_date -> post.po_time  -->
				<div class="form-group mt-3">
					<label class="form-label">작성일</label> 
					<div type="text" class="form-control"><fmt:formatDate value="${post.po_time}" pattern="yyyy-MM-dd HH:mm" /></div>	
				</div>
				
				<div class="form-group mt-3">
				    <label class="form-label">내용</label>
				    <div class="form-control" id="content" style="min-height: 400px;">
				        <c:out value="${post.po_content}" escapeXml="false"/>
				    </div>
				</div>
		        
				<c:if test="${fileList.size() != 0 }">
				    <!-- 탭 버튼 -->
					<ul class="nav nav-tabs mb-2" id="fileTab" role="tablist">
					  <li class="nav-item">
					    <a class="nav-link active" id="list-tab" data-toggle="tab" href="#list" role="tab" aria-controls="list" aria-selected="true">파일 목록</a>
					  </li>
					  <li class="nav-item">
					    <a class="nav-link" id="preview-tab" data-toggle="tab" href="#preview" role="tab" aria-controls="preview" aria-selected="false">이미지 미리보기</a>
					  </li>
					</ul>
					
					<!-- 탭 콘텐츠 -->
					<div class="tab-content" id="fileTabContent">
					  <!-- 파일 목록 -->
					  <div class="tab-pane fade show active" id="list" role="tabpanel" aria-labelledby="list-tab">
					    <c:forEach items="${fileList}" var="file">
					      <a class="form-control mb-1" href="<c:url value='/download${file.fi_name}'/>" download="${file.fi_ori_name}">
					        ${file.fi_ori_name}
					      </a>
					    </c:forEach>
					  </div>
					
					  <!-- 이미지 미리보기 -->
					  <div class="tab-pane fade" id="preview" role="tabpanel" aria-labelledby="preview-tab">
					    <div class="swiper mySwiper mt-2">
					      <div class="swiper-wrapper">
					        <c:forEach items="${fileList}" var="file">
					          <c:if test="${file.fi_ori_name.endsWith('.jpg') or file.fi_ori_name.endsWith('.png') or file.fi_ori_name.endsWith('.jpeg') or file.fi_ori_name.endsWith('.gif')}">
					            <div class="swiper-slide text-center" style="background: #fff;">
					              <img alt="첨부파일" width="auto" height="200px" src="<c:url value='/download${file.fi_name}'/>">
					            </div>
					          </c:if>
					        </c:forEach>
					      </div>
					      <div class="swiper-button-next"></div>
					      <div class="swiper-button-prev"></div>
					      <div class="swiper-pagination"></div>
					    </div>
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
	<div class="comment-container">
		<!-- 여기에 댓글들 불러오게 함 -->
	</div>


	<script>
	  let swiper; 
	
	  $(document).ready(function () {
	   
	    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
	      if ($(e.target).attr('href') === '#preview') {
	        if (!swiper) {
	          swiper = new Swiper(".mySwiper", {
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
	        } else {
	          swiper.update(); 
	        }
	      }
	    });
	
	    // 기본적으로 Swiper가 보이게 하고 싶다면 아래 코드 활성화
	    // $('#preview-tab').tab('show');
	  });
	</script>
	

</body>
</html>
