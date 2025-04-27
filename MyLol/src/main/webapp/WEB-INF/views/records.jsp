<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%request.setAttribute("pageType", "tft");%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <style>
    	table th {
            text-align: center;
        }
        table td, table th {
            padding: 8px;
        }
    </style>
</head>
<head>
    <meta charset="UTF-8" />
    <title>소환사 정보</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/TFT_Info_Styles.css">
    <style>
	    .form-group label {
	    margin-right: 10px; /* 라벨과 인풋 사이의 간격 조정 */
	    width: 75px; /* 라벨의 고정 너비 설정 */
	}
	</style>
</head>
<body>
	<h3 class="mt-3 mb-3">🔍 TFT 전적 상세 조회</h3>
	<p>
		소환사 이름을 <strong>게임이름#태그라인</strong> 형식으로 입력하세요 (예 : 바다새#KR1)
	</p>
	<form id="summonerForm" method="get" action="${pageContext.request.contextPath}/records">
	    <div class="form-group">
	        <label for="gameName">게임 이름 : </label>
	        <input type="text" id="gameName" name="gameName" required>
	    </div>
	    <div class="form-group">
	        <label for="tagLine">태그라인 : </label>
	        <input type="text" id="tagLine" name="tagLine" required>
	    </div>
	    <button class="btn-search" type="submit">조회</button>
	<br>
	<br>
	
    <h3>통계 요약</h3>
	<c:choose>
    	<c:when test="${not empty top3Units}">
    	<h3>가장 많이 쓴 유닛 TOP 3</h3>
        	<table border="2">
            <tr>
                <th>순위</th>
                <th>유닛 이름</th>
                <th>사용 횟수</th>
            </tr>
            <c:forEach var="unit" items="${top3Units}" varStatus="status">
                <tr>
                    <td>${status.index + 1}</td>
                    <td>${unit.unitName}</td>
                    <td>${unit.cnt}</td>
                </tr>
            </c:forEach>
        </table>
        <br>
        <h3>가장 많이 쓴 시너지 TOP 3</h3>
        <table border="2">
            <tr>
                <th>순위</th>
                <th>시너지 이름</th>
                <th>사용 횟수</th>
            </tr>
            <c:forEach var="trait" items="${top3Traits}" varStatus="status">
                <tr>
                    <td>${status.index + 1}</td>
                    <td>${trait.traitName}</td>
                    <td>${trait.cnt}</td>
                </tr>
            </c:forEach>
        </table>
    </c:when>
    <c:otherwise>
        <div>검색 후 결과가 표시됩니다.</div>
    </c:otherwise>
</c:choose>
</table>
</body>
</html>