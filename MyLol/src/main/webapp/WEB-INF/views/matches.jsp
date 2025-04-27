<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%request.setAttribute("pageType", "tft");%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>매치 데이터</title>
    <style>
    	table th {
            text-align: center;
        }
        table td, table th {
            padding: 8px;
        }
    </style>
</head>
<body style="text-align: left;">
	<br>
    <h2>매치 데이터</h2>
    <table border="2">
    <tr>
        <th>매치ID</th>
        <th>등수</th>
        <th>레벨</th>
        <th>남은 골드</th>
        <th>탈락 라운드</th>
        <th>죽인 플레이어 수</th>
        <th>탈락 시간</th>
        <th>총 데미지</th>
        <th>게임 시간</th>
        <th>꼬마 전설이</th>
        <th>시너지</th>
        <th>유닛</th>
    </tr>
    <c:forEach var="match" items="${matchList}">
        <tr>
            <td>${match.matchId}</td>
            <td>${match.placement}</td>
            <td>${match.level}</td>
            <td>${match.goldLeft}</td>
            <td>${match.lastRound}</td>
            <td>${match.playersEliminated}</td>
            <td>${match.timeEliminated}</td>
            <td>${match.totalDamageToPlayers}</td>
            <td>${match.gameLength}</td>
            <td>${match.companion}</td>
            <td>${match.traits}</td>
            <td>${match.units}</td>
        </tr>
    </c:forEach>
</table>
</body>
</html>