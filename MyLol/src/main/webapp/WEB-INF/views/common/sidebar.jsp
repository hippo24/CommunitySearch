<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
</head>

<body id="body">

<div class="card sidebar-sticky p-2">
  <div class="card-header">📁 게시판 목록</div>
  <div class="card-body">
    <button class="btn btn-outline-success w-100 mb-2 btn-board" data-num="0">전체</button>
    <c:forEach items="${boardList}" var="board">
      <button class="btn btn-outline-success w-100 mb-2 btn-board" data-num="${board.bo_key}">
        ${board.bo_name}
      </button>
    </c:forEach>
  </div>
</div>

	
	
</body>
</html>
