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
										작성일 : <fmt:formatDate pattern="yy.MM.dd" value="${post.po_upd}"/>
									</div>
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
								작성일 : <fmt:formatDate pattern="yy.MM.dd" value="${post.po_upd}"/>
								<c:if test="${post.po_time ne post.po_upd}">
									<span class="text-muted">(수정됨)</span>
								</c:if>
							</div>
						</div>
					</div>
				</a>
			</c:otherwise>
		</c:choose>
	</c:forEach>

	<c:if test="${postList.size() eq 0}">
		<div class="form-control text-center">등록된 게시글이 없습니다.</div>
	</c:if>
	
	
	<!-- 더보기 버튼을 추가 -->
	<c:if test="${pm.next}">
		<button class="btn btn-danger btn-more col-12">더보기</button>
	</c:if>	
		
	

</body>
</html>