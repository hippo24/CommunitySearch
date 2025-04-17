<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-bs4.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-bs4.min.js"></script>
    
	<style type="text/css">

	
	</style>

</head>
<body>
			<h1>게시글 등록</h1>
			<form action="<c:url value="/post/insert"/>" method="post" enctype="multipart/form-data"> 
				<div class="form-group mt-3">
					<label for="board" class="form-label">게시판</label> 
					<select class="form-control" id="board" name="po_bo_num">
					  	<c:forEach items="${boardList}" var="board">
					  		<option value="${board.bo_key}" <c:if test="${board.bo_key eq bo_key }">selected</c:if> >
					  			${board.bo_name }
					  		</option>
					  	</c:forEach>
					</select>		
				</div>
		
				<div class="form-group mt-3">
					<label for="title" class="form-label">제목</label> 
					<input type="text" class="form-control" id="title" name="po_title">	
				</div>
		
				<div class="form-group">
				  <label for="content">내용:</label>
				  <textarea class="form-control" id="content" name="po_content"></textarea>
				</div>
		
				<div class="form-group">
					<input type="file" name="fileList" class="form-control">
					<input type="file" name="fileList" class="form-control">
					<input type="file" name="fileList" class="form-control">
				</div>	
		
		
				<button type = "submit" class="btn btn-outline-sucess mt-3 col-12">게시글 등록</button>
						
			</form>


	<script type="text/javascript">
		$("[name=fileList]").change(function(e){
			const $this = $(this);
			const file = this.files[0];
			if(file){
				const reader = new FileReader();
				reader.onload = function(e){		//이벤트 등록
					$this.prev().attr("src", e.target.result).show();			//이 객체의 전-이미지태그 str로 바꿔서 결과를 보여주고
					$this.prevAll(".base-img").hide();
				}
				reader.readAsDataURL(file);
			}else{
				$this.prev().hide();
				$this.prevAll(".base-img").show();
			}
			
		});
		
		
		
		
	</script>
	
	<script>
      $('[name=po_content]').summernote({
        placeholder: '내용을 입력하세요.',
        tabsize: 2,
        height: 400
      });
      $("form").submit(function(e) {
    	  let obj = $("[name=po_title]");
	      let title = obj.val().trim();
	      
	      if(title.length == 0){
	    	  alert("제목을 입력하세요.");
	    	  obj.focus();
	    	  return false;
	      }
	      
	    //첨부파일 1개 이상인지 확인
		let count = 0;
		$("[name=fileList]").each(function(e){
			count += this.files.length;
		})
		//console.log(count);
		
		if(count == 0) {
			alert("이미지는 1개 이상 선택하세요.")
			return false;
		}
    	  
      })
		
		
    </script>
</body>
</html>