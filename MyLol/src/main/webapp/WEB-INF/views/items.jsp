<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%request.setAttribute("pageType", "tft");%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>아이템 데이터</title>
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
    <h2>아이템 데이터</h2>
    <table border="2">
        <tr>
            <th>ID</th>
            <th>매치ID</th>
            <th>소환사 이름</th>
            <th>태그</th>
            <th>유닛 인덱스</th>
            <th>유닛 이름</th>
            <th>아이템 이름</th>
        </tr>
        <c:forEach var="item" items="${itemList}">
            <tr>
                <td>${item.id}</td>
                <td>${item.matchId}</td>
                <td>${item.riotIdName}</td>
                <td>${item.riotIdTagline}</td>
                <td>${item.unitIndex}</td>
                <td>${item.unitName}</td>
                <td>${item.itemName}</td>
            </tr>
        </c:forEach>
    </table>
</body>
</html>