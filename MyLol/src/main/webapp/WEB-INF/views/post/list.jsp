<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<style>
	

		/* 사이드바 */
		.sidebar-l {
  		  position: fixed;
		  top: 7rem;
		  left: 0;
		  width: 12.5rem;
		  height: auto;
		  padding: 1rem;
		  border: 1px solid gray;
		  background: #f9f9f9;
		}
		
		/* 게시판 링크 */
		.board-link, .board-link2 {
		  font-size:1rem;
		  display: block;
		  padding: 8px 10px;
		  margin-bottom: 5px;
		  color: #333;
		  border-radius: 4px;
		  text-decoration: none;
		  transition: all 0.2s;
		}
		
		.board-link:hover, .board-link2:hover, .board-link.active, .board-link.active {
		  background-color: #28a745;
		  color: white;
		}
		@media (min-width: 1200px) {
			.pl-container, .btn-container{
			  margin-left: 7.5rem; 
			  padding: 1rem;
			}
			.pl-container{
			  min-height: 1000px;
			}
		}

	</style>
</head>
<body>

	
	<!-- 카테고리 버튼 -->
	<div class="btn-container">
		<button class="btn btn-outline-success btn-board" data-num="0">전체</button>
		<c:choose>
			<c:when test="${not empty boardList}">
				<c:forEach items="${boardList}" var="board">	
					<button class="btn btn-outline-success btn-board" data-num="${board.bo_key}">${board.bo_name}</button>	
				</c:forEach>
			</c:when>
			<c:otherwise>
				<h3>등록된 게시판이 없습니다.</h3>
			</c:otherwise>
		</c:choose>
	</div>
	<!-- 사이드바 -->
	<div class="sidebar-l d-none d-xl-block" id="sidebar-l">
		<h5 class="mt-2 mb-2">📂 게시판</h5>
		<a href="#" class="board-link" data-num="0">전체</a>
		<c:choose>
			<c:when test="${not empty boardList}">
				<c:forEach items="${boardList}" var="board">
					<a href="#" class="board-link btn-board" data-num="${board.bo_key}">${board.bo_name}</a>
				</c:forEach>
			    <a class="board-link2" href="<c:url value='/post/duo' />">듀오모집게시판1</a>
			    <a class="board-link2" href="<c:url value='/exampleTFT' />">TFT 배치 툴</a>
			</c:when>
			<c:otherwise>
				<h5>등록된 게시판이 없습니다.</h3>
			</c:otherwise>
		</c:choose>
	</div>
	
	
	
	<div class="d-flex justify-content-between mt-3 btn-container"><!-- 양쪽에 나눠서 배치 -->
	
		<!-- 검색 화면 추가(검색창, 검색타입, 버튼) -->
		
		<!-- 정렬방식 선택 -->
		<select class="form-control col-3 sel-type">
			<option value="ALL">ALL</option>
			<option value="LOL">LOL</option>
			<option value="TFT">TFT</option>
		</select>	
	
		<!-- 게시글 등록 버튼 -->
		<c:if test="${user ne null}">
			<a href="<c:url value="/post/insert"/>" class= "btn btn-outline-success ">게시글 등록</a>
		</c:if>
	</div>
	
	<!-- 게시글 목록을 보여주는 컨테이너 -->
	<div class="pl-container mt-3 mb-3">
	
	</div>
	    



	<script type="text/javascript">
		let ini_bo_key = ${num}; // controller에서 넘긴 board 번호
		let cri = {					// cri를 전역변수로 설정
				po_bo_key : ini_bo_key,
				page : 1,
				po_type : "ALL"
		}
	
	
		let data = getPostList(cri);
		$(".pl-container").html(data);	
	
	
	//게시판 클릭 이벤트
		$(document).on("click", ".btn-board, .board-link", function (e) {	
			e.preventDefault();
			
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
			cri.po_type = $(this).val();
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
			
			let res= '';
			
			$.ajax({
				async : false,	
				url : '<c:url value="/post/list"/>', 
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