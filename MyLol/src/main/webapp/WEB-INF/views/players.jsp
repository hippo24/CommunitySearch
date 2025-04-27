<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%request.setAttribute("pageType", "tft");%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>플레이어</title>
    <style>
    	table th {
            text-align: center;
        }
        table td, table th {
            padding: 8px;
        }
    </style>
</head>
<body>
	<br>
    <h2>플레이어</h2>
    <table border="2">
    <colgroup>
        <col style="width:50px">
	    <col style="width:500px">
	    <col style="width:120px">
	    <col style="width:60px">
	    <col style="width:110px">
	    <col style="width:200px">
	    <col style="width:100px">
    </colgroup>
    <tr>
        <th>ID</th>
        <th class="puuid">puuid</th>
        <th>소환사 이름</th>
        <th>태그</th>
        <th>날짜</th>
        <th>생성일</th>
        <th>BOT 여부</th>
    </tr>
    <c:forEach var="player" items="${playerList}">
        <tr>
            <td>${player.id}</td>
            <td class="puuid" style="word-break: break-all; white-space: normal;">
                ${player.puuid}
            </td>
            <td>${player.riotIdName}</td>
            <td>${player.riotIdTagline}</td>
            <td>${player.gameDate}</td>
            <td>${player.createdAt}</td>
            <td>
                <c:choose>
                    <c:when test="${player.bot}">봇</c:when>
                    <c:otherwise>유저</c:otherwise>
                </c:choose>
            </td>
        </tr>
    </c:forEach>
    </table>
</body>
</html>