<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%request.setAttribute("pageType", "tft");%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>소환사 정보</title>
    <style>
        table th { text-align: center; }
        table td, table th { padding: 8px; }
        .form-group label { margin-right: 10px; width: 75px; }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/TFT_Info_Styles.css">
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
    </form>
    <br>
    <br>
    <h3>통계 요약</h3>
    <c:choose>
        <c:when test="${not empty top3Units}">
            <!-- 유닛 TOP3 & 별 갯수 가로 배치 -->
            <div style="display: flex; gap: 40px; align-items: flex-start;">
                <div>
                    <h3>가장 많이 쓴 유닛 TOP 3</h3>
                    <table border="2">
                        <tr>
                            <th>순위</th>
                            <th>유닛 이름</th>
                            <th>사용 횟수</th>
                            <th>평균 등수</th>
                        </tr>
                        <c:forEach var="unit" items="${top3Units}" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td>${unit.unitName}</td>
                                <td>${unit.cnt}번</td>
                                <td><fmt:formatNumber value="${unit.avgPlacement}" maxFractionDigits="2"/>등</td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
                <div>
                    <h3>사용한 유닛들의 별 갯수</h3>
                    <table border="2">
                        <tr>
                            <th>별</th>
                            <th>사용 횟수</th>
                        </tr>
                        <c:forEach var="tier" items="${tierCount}">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${tier.tier == 1}">⭐</c:when>
                                        <c:when test="${tier.tier == 2}">⭐⭐</c:when>
                                        <c:when test="${tier.tier == 3}">⭐⭐⭐</c:when>
                                        <c:when test="${tier.tier == 4}">⭐⭐⭐⭐</c:when>
                                        <c:otherwise>${tier.tier}성</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${tier.cnt}번</td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>
            <br>
            <br>
            <!-- 시너지/아이템 TOP3 가로 배치 -->
            <div style="display: flex; gap: 40px; align-items: flex-start;">
                <div>
                    <h3>가장 많이 쓴 시너지 TOP 3</h3>
                    <table border="2">
                        <tr>
                            <th>순위</th>
                            <th>시너지 이름</th>
                            <th>사용 횟수</th>
                            <th>평균 등수</th>
                        </tr>
                        <c:forEach var="trait" items="${top3Traits}" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td>${trait.traitName}</td>
                                <td>${trait.cnt}번</td>
                                <td><fmt:formatNumber value="${trait.avgPlacement}" maxFractionDigits="2"/>등</td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
                <div>
                    <h3>가장 많이 쓴 아이템 TOP 3</h3>
                    <table border="2">
                        <tr>
                            <th>순위</th>
                            <th>아이템 이름</th>
                            <th>사용 횟수</th>
                            <th>평균 등수</th>
                        </tr>
                        <c:forEach var="item" items="${top3Items}" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td>${item.itemName}</td>
                                <td>${item.cnt}번</td>
                                <td><fmt:formatNumber value="${item.avgPlacement}" maxFractionDigits="2"/>등</td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>
            <br>
            <br>
            <h3>가장 많이 달성한 레벨 TOP 3</h3>
			<table border="2">
		    <tr>
		        <th>순위</th>
		        <th>레벨</th>
		        <th>달성 횟수</th>
		        <th>평균 등수</th>
		    </tr>
		    <c:forEach var="level" items="${top3Levels}" varStatus="status">
		        <tr>
		            <td>${status.index + 1}</td>
		            <td>${level.level}레벨</td>
		            <td>${level.cnt}번</td>
		            <td>
		                <fmt:formatNumber value="${level.avgPlacement}" maxFractionDigits="2"/>등
		            </td>
		        </tr>
		    </c:forEach>
		</table>
        </c:when>
        <c:otherwise>
            <div>검색 후 결과가 표시됩니다.</div>
        </c:otherwise>
    </c:choose>
</body>
</html>