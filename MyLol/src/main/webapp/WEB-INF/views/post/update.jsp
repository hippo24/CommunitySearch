<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<link href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-bs4.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-bs4.min.js"></script>
</head>
<body>
	<form action="<c:url value="/post/update"/>" method="post"  enctype="multipart/form-data">
		<h1>게시글 수정</h1>
		<input type="hidden" name="po_key" value="${post.po_key}">
		<div class="form-group mt-3">
			<label for="title" class="form-label">게시판</label> 
			<select class="form-control" id="board" name="po_bo_key">
				<c:forEach items="${boardList}" var="board">
					<!-- bonum과 pobonum이 같으면 옵션태그에 selected추가(옵션에 selected 들어가면 해당 옵션값이 선택됨. -->
					<option value="${board.bo_key}" <c:if test="${board.bo_key == post.po_bo_key}">selected</c:if> >${board.bo_name}</option>
				</c:forEach>
			</select>	
		</div>
		<div class="form-group">
		  <label for="title">제목:</label>
		  <input type="text" class="form-control" id="title" name="po_title" value="${post.po_title}">
		</div>
		<div class="form-group">
			<label for="content">내용:</label>
			<textarea class="form-control" id="content" name="po_content">${post.po_content}</textarea>
		</div>
	    <div class="form-group att">
	    	<label>첨부파일(최대 10mb)</label>
			<c:forEach items="${fileList}" var="file">
				<div class="form-control d-flex justify-content-between">
					<span>${file.fi_ori_name }</span> 
					<a href="javascript:void(0)" data-num="${file.fi_key}" class="del" >&times;</a>
				</div>
			</c:forEach>	
	    	<c:forEach begin="1" end="${3 - fileList.size()}">
	    		<input type="file" class="form-control" name="fileList"  accept="image/*"/>
	    	</c:forEach>

	    
	    </div>

		<button type="submit" class="btn btn-outline-success col-12 mb-3">게시글 수정</button>
	
	</form>
	 <script type="text/javascript">
      $('[name=po_content]').summernote({
        placeholder: '글을 입력해 주세요.',
        tabsize: 2,
        height: 100
      });
      $("form").submit(function(e){
    	  let obj = $("[name=po_title]");
    	  let title = $("[name=po_title]").val().trim();
    	  if(title.length == 0){
    		  alert("제목을 입력하세요.");
    		  obj.focus();
    		  return false;
    	  }
      })
      
      
		$(".del").click(function(e){
			//삭제할 첨부파일 번호 가져옴
			let fi_key = $(this).data("num");
			
			let str = `	<input type="file" class="form-control" name="fileList"/>
						<input type="hidden" name="delNums" value="\${fi_key}"/>
						`;
			
			$(".att").append(str);
			$(this).parent().remove();
			
		});
    </script>
    
</body>
</html>
