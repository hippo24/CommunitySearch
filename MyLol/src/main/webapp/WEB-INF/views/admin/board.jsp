<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	
</head>
<body>
	<h1>관리자-게시판 관리</h1>

	<div class="board-list">
		<c:forEach items="${boardList}" var="board">
			<form class="input-group mb-3 update" action="<c:url value="/admin/board/update"/>" method="post">
				<input type="hidden" name="bo_key" value="${board.bo_key}">
				<input type="text" class="form-control" placeholder="${board.bo_name}" name="bo_name" value="${board.bo_name}">
				<button type="submit" class="form-control btn btn-outline-warning">수정</button>
				<a href="<c:url value="/admin/board/delete?num=${board.bo_key}"/>" class="form-control btn btn-outline-danger del">삭제</a>
			</form>
		</c:forEach>
	
	</div>
	
	<div class="board-insert">
		<form action="<c:url value="/admin/board/insert"/>" method="post" id="insert">
			<div class="input-group mb-3">
				<input type="text" class="form-control" placeholder="게시판을 입력하세요." name="name">
				<button class="form-control btn btn-outline-success">등록</button>
			</div>
		</form>
	</div>
	
	<script type="text/javascript">
		$("#insert").submit(function(e){
			
			let obj = $("#insert [name=name]");				
			let bo_name = obj.val().trim();
			if(bo_name.length == 0){
				alert("게시판 이름을 입력해 주세요.");
				obj.focus();
				return false;
			}
			obj.val(bo_name);	
		});
		
		$(".update").submit(function(e){
				
				let obj = $(this).find("[name=bo_name]");		
				let bo_name = obj.val().trim();
				if(bo_name.length == 0){
					alert("게시판 이름을 입력해 주세요.");
					obj.focus();
					return false;
				}
				obj.val(bo_name);
			});
		
		$(".del").click(function(e){
			if(!confirm("삭제하시겠습니까?")){
				e.preventDefault();
			}
			});
	</script>

</body>
</html>
