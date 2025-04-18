<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%request.setAttribute("pageType", "lol");%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<style>
		.infoBox{
			min-height: auto; height: auto; 
			background-color: #f8f9fa; 
			box-shadow: 0 4px 8px rgba(0,0,0,0.1); 
			border-radius: 12px;
		}
	</style>
</head>
<body>
    <div id="summonerProfile" style="margin-top: 20px;">
        <div class="infoBox form-control mt-3 mb-3 d-flex align-items-center">
        	<img class="mr-3 rounded-circle me-3" src="http://ddragon.leagueoflegends.com/cdn/14.6.1/img/profileicon/${summoner.profileIconId}.png" alt="프로필 아이콘" width="64" height="64">
			<div>
			    <div class="fw-bold fs-5 mb-1">${gameName}#${tagLine}</div>
			    <div>레벨: <strong>${summoner.summonerLevel}</strong></div>
			    <div>티어: <strong>${dto.tier} ${dto.rank}</strong> (${dto.leaguePoints} LP)</div>
			    <div>판수: <strong>${dto.wins + dto.losses}</strong></div>
			    <div>
			    	승리: <strong>${dto.wins}</strong> 
			    	패배: <strong>${dto.losses}</strong>
			    	승률: <strong><fmt:formatNumber value="${(dto.wins / (dto.wins + dto.losses)) * 100}" type="number" maxFractionDigits="1" />%</strong>
			    </div>
			</div>
      </div>
    </div>
</body>
<script type="text/javascript">
	/* //챔피언과 스펠 json을 미리 한 번만 불러오기
	Promise.all([
	    fetch("https://ddragon.leagueoflegends.com/cdn/15.7.1/data/ko_KR/champion.json").then(res => res.json()),
	    fetch("https://ddragon.leagueoflegends.com/cdn/15.6.1/data/ko_KR/summoner.json").then(res => res.json())
	]).then(([championRes, spellRes]) => {
	    championData = championRes.data;
	    spellData = spellRes.data;
	    console.log(championData);
		console.log(spellData);
	}); */
</script>
</html>