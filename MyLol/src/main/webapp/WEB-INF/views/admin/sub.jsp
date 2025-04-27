<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<c:forEach items="${postList}" var="post">
		<fmt:formatDate var="postTimeDate" pattern="yyyyMMdd" value="${post.po_time}" />
		<fmt:formatDate var="updTimeDate" pattern="yyyyMMdd" value="${post.po_upd}" />
		
	
		<c:choose>
			<c:when test="${post.po_upd.time gt now.time}">
				<c:choose>
					<c:when test="${user.us_authority eq 'admin'}">
						<a class="form-group" href="<c:url value='/post/detail/${post.po_key}'/>">
							<div class="form-control input-group bg-warning text-dark" style="min-height:auto; height:auto">
								<img width="100" height="120" alt="" src="<c:url value='/resources/img/base.png'/>" style="opacity: 0.5;">
								<div class="ml-3">
									<div>🛠️ [관리자용] 삭제된 글</div>
									<div>작성자 : ${post.po_us_name}</div>
									<div>
										작성일 : 
										<c:choose>
											<c:when test="${postTimeDate eq today}">
												작성시각 : <fmt:formatDate pattern="HH:mm" value="${post.po_time}" />
											</c:when>
											<c:otherwise>
												작성일 : <fmt:formatDate pattern="yy.MM.dd" value="${post.po_time}" />
											</c:otherwise>
										</c:choose>
									</div>
									<div>내용 : ${post.summary }</div>
								</div>
							</div>
						</a>
					</c:when>
	
					<c:otherwise>
						<div class="form-control input-group bg-light text-muted" style="min-height:auto; height:auto; cursor: not-allowed;">
							<img width="100" height="120" alt="" src="<c:url value='/resources/img/base.png'/>" style="opacity: 0.5;">
							<div class="ml-3">
								<div>🗑️ 삭제된 글입니다</div>
							</div>
						</div>
					</c:otherwise>
				</c:choose>
			</c:when>
	
			<c:otherwise>
				<a class="form-group" href="<c:url value='/post/detail/${post.po_key}'/>">
					<div class="form-control input-group" style="min-height:auto; height:auto">
						<c:choose>
							<c:when test="${post.po_fi_name ne null}">
								<img alt="" width="100" height="120" src="<c:url value='/download${post.po_fi_name}'/>">
							</c:when>
							<c:otherwise>
								<img width="100" height="120" alt="" src="<c:url value='/resources/img/base.png'/>">
							</c:otherwise>
						</c:choose>
						<div class="ml-3">
							<div>${post.po_title}</div>
							<div>작성자 : ${post.po_us_name}</div>
							<div>
								 
								<c:choose>
									<c:when test="${postTimeDate eq today}">
										작성시각 : <fmt:formatDate pattern="HH:mm" value="${post.po_time}" />
									</c:when>
									<c:otherwise>
										작성일 : <fmt:formatDate pattern="yy.MM.dd" value="${post.po_time}" />
									</c:otherwise>
								</c:choose>
								<!-- 수정됨 -->
								<c:if test="${post.po_time ne post.po_upd}">
									(
									<c:choose>
										<c:when test="${updTimeDate eq today}">
											<fmt:formatDate pattern="HH:mm" value="${post.po_upd}" />
										</c:when>
										<c:otherwise>
											<fmt:formatDate pattern="yy.MM.dd" value="${post.po_upd}" />
										</c:otherwise>
									</c:choose>
									수정됨)
								</c:if>
							</div>
							<div>내용 : ${post.summary }</div>
						</div>
					</div>
				</a>
			</c:otherwise>
		</c:choose>
	</c:forEach>

	<c:if test="${postList.size() eq 0}">
		<div class="form-control text-center">등록된 게시글이 없습니다.</div>
	</c:if>
	
	
	<!-- 페이지네이션 -->
	<!-- 페이지네이션 -->
	<ul class="pagination justify-content-center">
	    <li class="page-item ${!pm.prev ? 'disabled' : ''}">
	        <a class="page-link btn-page" href="#" data-page="${pm.startPage - 1}">이전</a>
	    </li>
	
	    <c:forEach begin="${pm.startPage}" end="${pm.endPage}" var="i">
	        <li class="page-item ${pm.cri.page == i ? 'active' : ''}">
	            <a class="page-link btn-page" href="#" data-page="${i}">${i}</a>
	        </li>
	    </c:forEach>
	
	    <li class="page-item ${!pm.next ? 'disabled' : ''}">
	        <a class="page-link btn-page" href="#" data-page="${pm.endPage + 1}">다음</a>
	    </li>
	</ul>

	<script type="text/javascript">
		$(document).off("click", ".btn-page");
		$(document).on("click", ".btn-page", function(e){
		    e.preventDefault();
		    let page = $(this).data("page");
		    cri.page = page;
		    let data = getPostList(cri); // 이건 네가 이미 구현한 Ajax 함수
		    $(".pl-container").html(data);
		});
	</script>

		
	

</body>
</html>