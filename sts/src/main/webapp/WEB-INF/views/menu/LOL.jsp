<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="container mt-5">
  <h1>롤 전적 검색</h1>
  <form action="${pageContext.request.contextPath}/LOL" method="post">
    <input type="text" id="riotId" name="riotId" placeholder="Riot ID (예: 아이디#KR1)" required />
    <button type="submit">검색</button>
  </form>

  <hr />

  <c:if test="${not empty result}">
    <h2>소환사 정보</h2>
    <pre>${result}</pre>
  </c:if>

	<c:if test="${not empty error}">
	    <p style="color:red">${error}</p>
	</c:if>
	
	<c:if test="${not empty summonerData}">
	    <p>Game Name: ${summoner.gameName}#${summoner.tagLine}</p>
	    <p>Level: ${summoner.summonerLevel}</p>
	</c:if>
	
	<form action="<c:url value='/LOL'/>" method="post">
	    <input type="text" name="riotId" placeholder="아이디#태그">
	    <button type="submit">조회</button>
	</form>
		


</div>
