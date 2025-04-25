<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>듀오 모집 게시판</title>

</head>
<body class="container mt-5">



	<div class="d-flex justify-content-between mt-3">
		<!-- 게시글 등록 버튼 -->
		<c:if test="${user ne null}">
			<a href="<c:url value="/post/insert"/>" class= "btn btn-outline-success ">게시글 등록</a>
		</c:if>
	</div>
	
	<!-- 게시글 목록을 보여주는 컨테이너 -->
	<div class="pl-container mt-3 mb-3">
	
	</div>	

<script type="text/javascript">
	let cri = {					// cri를 전역변수로 설정
			//po_bo_key : 0,
			page : 1,
			ps_line : ""
	}
	
	
	let data = getDuoList(cri);
	$(".pl-container").html(data);	
	
	//더보기 클릭 이벤트
	$(document).on("click", ".btn-more", function(e){
		$(this).remove();
		cri.page = cri.page + 1;
		let data = getDuoList(cri);
		//console.log(data);
		$(".pl-container").append(data);			//1번 페이지 뒤에 계속 덧붙여줌			
	});

	//정렬방식 change 이벤트
	$(".sel-type").change(function(e){
		//cri.po_type = $(this).val();
		cri.page = 1;
		let data = getDuoList(cri);
		$(".pl-container").html(data);
		
	})
	
	
	function getDuoList(cri){
		
		
		let res= '';
		
		$.ajax({
			async : false,	
			url : '<c:url value="/post/duo/list"/>', 
			type : 'post', 
			data : JSON.stringify(cri),			
			contentType : "application/json; charset=utf-8",
			//dataType : "json",
			success : function (data){
				
				res = data;		
				
			}
		});
		return res;			
	}
		




</script>


</body>
</html>
