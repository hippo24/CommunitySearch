<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	
	<style>
		/* 사이드바 고정 위치 */
		.sidebar-sticky {
		  position: sticky;
		  top: 100px; 
		  max-height: 80vh;
		  overflow-y: auto;
		}
		
		/* 선택된 게시판 스타일 */
		.btn-board.active {
		  background-color: #28a745;
		  color: white;
		}
	</style>
	
</head>
<body>

	<h1 class="mt-3">게시글 목록</h1>
	
	<button class="btn btn-outline-success btn-board" data-num="0">전체</button>
		
	<c:if test="${not empty boardList}">
		<div class="board-container form-control">
			<c:forEach items="${boardList}" var="board">	
				<button class="btn btn-outline-success btn-board" data-num="${board.bo_key}">${board.bo_name}</button>	
			</c:forEach>
		</div>
	</c:if>
	
	<div class="d-flex justify-content-between mt-3"><!-- 양쪽에 나눠서 배치 -->

		
		<!-- 게시글 등록 버튼 -->
		<c:if test="${user ne null}">
			<a href="<c:url value="/post/insert"/>" class= "btn btn-outline-success ">게시글 등록</a>
		</c:if>
	
	</div>
	
	<div class="container-fluid">
	  <div class="row">
	    
	    <!-- 좌측 사이드바 -->
	   <div class="col-md-3">
	      <div class="sidebar-sticky border rounded p-3 bg-light">
	        <h5>게시판</h5>
	        <button class="btn btn-outline-success btn-board w-100 mb-2" data-num="0">전체</button>
	        <c:forEach items="${boardList}" var="board">	
	          <button class="btn btn-outline-success btn-board w-100 mb-2" data-num="${board.bo_key}">
	            ${board.bo_name}
	          </button>
	        </c:forEach>
	      </div>
	    </div>
	    
	    <!-- 우측 게시글 컨텐츠 -->
	    <div class="col-md-9">
	      <div class="d-flex justify-content-between mb-3">
	        <c:if test="${user ne null}">
	          <a href="<c:url value='/post/insert'/>" class="btn btn-outline-success">게시글 등록</a>
	        </c:if>
	      </div>
	      <div class="pl-container"></div>
	    </div>
	    
	  </div>
	</div>


	<!-- 페이지네이션x. -->
	<!-- 더보기 버튼을 추가 -->
	<!-- <button class = "btn btn-danger btn-more col-12">더보기</button> -->
	

	<script type="text/javascript">
		let cri = {					// cri를 전역변수로 설정
				po_bo_key : 0,
				page : 1,
				orderBy : "po_key desc"
		}
		//let str = "";
	
	
		//getPostList(cri);			//처음 실행시 전체 선택되게	->처음 정의라 po_bo_key 0으로 돼있음
		let data = getPostList(cri);
		//console.log(data);
		$(".pl-container").html(data);	
	
	
	//게시판 클릭 이벤트
		$(".btn-board").click(function(e){
			//alert(1);
			
			//let num = $(this).data("num");
			cri.po_bo_key = $(this).data("num");
			cri.page = 1; 			//게시판 바뀌면 1페이지로 초기화
			
			let data = getPostList(cri);
			$(".pl-container").html(data);		//1번 페이지 생성

		});

	//더보기 클릭 이벤트
		$(document).on("click", ".btn-more", function(e){
			$(this).remove();
			cri.page = cri.page + 1;
			let data = getPostList(cri);
			//console.log(data);
			$(".pl-container").append(data);			//1번 페이지 뒤에 계속 덧붙여줌			
		});
	
	//정렬방식 change 이벤트
		$(".sel-type").change(function(e){
			cri.orderBy = $(this).val();
			cri.page = 1;
			let data = getPostList(cri);
			$(".pl-container").html(data);
			
		})
	
		
		
		
		
		
		function checkBoardBtn(num){		//일부러 밖에 넣는 이유는 색상같은거 바꾸고 싶을때 여기서 한번에 바꾸면 되게

			//초기 설정
			$(".btn-board").addClass("btn-outline-success");
			$(".btn-board").removeClass("btn-success");
			//num에 따라 게시판 색상을 변경
			$(".btn-board").each(function(){		//반복문으로 num이 같은 녀석을 찾음
				if($(this).data("num") == num){
					$(this).removeClass("btn-outline-success");
					$(this).addClass("btn-success");
				}
			});
	
		}

		//function getPostList(num){
		function getPostList(cri){
			checkBoardBtn(cri.po_bo_key);
			
			//alert(num);
			/*
			비동기 통신으로 서버에 연결하여 빈 문자열을 받는 코드 작성
			url : /post/list
			method : post
			data : num을 전송 -> po_bo_key과 page를 전송
			po_bo_key과 page 번호에 맞는 게시글 목록을 가져오도록 수정
			*/
			let res= '';
			
			//object로 보내고 object로 받는 예제
			$.ajax({
				async : false,		//굳이 동기화 시킬 이유가 x -> 이제 동기화 할 이유가 생김(더보기 버튼 누를때마다 게시글 순서대로 가져와야하므로) 
				url : '<c:url value="/post/list"/>', 
				type : 'post', 
				data : JSON.stringify(cri),				//페이지 우선 임의로 
				contentType : "application/json; charset=utf-8",
				//dataType : "json",
				success : function (data){
					//console.log(data);
	
					//우선 아무 게시판 클릭하면 pl-container에 1 띄우도록
					//let str = `1`;
					res = data;		//data를 문자열로 받아옴
					
					//서버에서 sub.jsp를 가져와서 data로 뿌려줌
					//$(".pl-container").html(str);			//text로 넣어도 되지만 hmtl 이용할 거기 때문에
					
					
				}
			});
			return res;				//여기다 박아야 return 되는구나
		}
		

		
	</script>


</body>
</html>