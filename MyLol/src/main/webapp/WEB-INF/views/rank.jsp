<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%request.setAttribute("pageType", "tft");%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>랭크</title>
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
    <h2>랭크</h2>
    <table border="2">
    <tr>
        <th>ID</th>
        <th>닉네임</th>
        <th>태그</th>
        <th>티어</th>
        <th>랭크</th>
        <th>LP</th>
        <th>승</th>
        <th>패</th>
    </tr>
    <c:forEach var="rank" items="${rankList}">
        <tr>
            <td>${rank.id}</td>
            <td>${rank.riotIdName}</td>
			<td>${rank.riotIdTagline}</td>
            <td>${rank.tier}</td>
            <td>${rank.rankDivision}</td>
            <td>${rank.leaguePoints}</td>
            <td>${rank.wins}</td>
            <td>${rank.losses}</td>
        </tr>
    </c:forEach>
</table>
</body>
</html>