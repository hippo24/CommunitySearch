<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%request.setAttribute("pageType", "tft");%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>통계</title>
</head>
<body>
    <h2>유저 통계</h2>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>puuid</th>
            <th>소환사 이름</th>
            <th>태그</th>
            <th>날짜</th>
            <th>생성일</th>
            <th>BOT 여부</th>
        </tr>
        <c:forEach var="player" items="${playerList}">
            <tr>
                <td>${player.id}</td>
                <td>${player.puuid}</td>
                <td>${player.riotIdName}</td>
                <td>${player.riotIdTagline}</td>
                <td>${player.gameDate}</td>
                <td>${player.createdAt}</td>
                <td>
                    <c:choose>
                        <c:when test="${player.bot}">BOT</c:when>
                        <c:otherwise>유저</c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </c:forEach>
    </table>
</body>
</html>