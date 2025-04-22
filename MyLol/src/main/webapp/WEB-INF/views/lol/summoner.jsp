<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
request.setAttribute("pageType", "lol");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>소환사 정보</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/TFT_Info_Styles.css">

</head>

<body>
	<h3>🔍 LOL 전적 상세 조회</h3>
	<p>
		소환사 이름을 <strong>게임이름#태그라인</strong> 형식으로 입력하세요 (예 : Hide on bush#KR1)
	</p>
	<form id="summonerForm">
		<div>
			<label for="gameName">게임 이름:</label> <input type="text" id="gameName"
				name="gameName" required>
		</div>
		<div>
			<label for="tagLine">태그라인:</label> <input type="text" id="tagLine"
				name="tagLine" required>
		</div>
		<button class="btn-search" type="submit">조회</button>
	</form>
	<div id="summonerProfile" style="margin-top: 20px;">
		<!-- 소환사 정보가 여기에 표시됩니다. -->
	</div>

	<div id="gameInfo" style="margin-top: 20px;">
		<!-- 게임 정보가 여기에 표시됩니다. -->
	</div>

	<script type="text/javascript">
		let tacticianData = null;
	    let itemData = null;
	
	    // 챔피언과 스펠 json을 미리 한 번만 불러오기
	    Promise.all([
	        fetch("https://ddragon.leagueoflegends.com/cdn/15.7.1/data/ko_KR/champion.json").then(res => res.json()),
	        fetch("https://ddragon.leagueoflegends.com/cdn/15.6.1/data/ko_KR/summoner.json").then(res => res.json()),
	        fetch("https://ddragon.leagueoflegends.com/cdn/15.6.1/data/ko_KR/runesReforged.json").then(res => res.json())
	    ]).then(([championRes, spellRes, runeRes]) => {
	        championData = championRes.data;
	        spellData = spellRes.data;
	        console.log(championData);
			console.log(spellData);
			console.log(runeRes);

    		let start = 0;
	    	$('#summonerForm').on('submit', function (e) {
	    		$('#summonerProfile').html('');
			    $('#gameInfo').html('');
		        e.preventDefault();
		        
		        gameName = $('#gameName').val();
		        tagLine = $('#tagLine').val();
		        start = 0;
		        
		        // 1. PUUID, Summoner ID 조회
		        $.ajax({
		        	url: '<c:url value="/lol/searchPUUID"/>',
		            method: 'GET',
		            data: { gameName: gameName, tagLine: tagLine },
		            success: function (response) {
		                const puuid = response.puuid;
		
		                getSummonerProfile(puuid, gameName, tagLine); // 소환사 정보
		                getGameInfo(puuid, start);
		            }
		        });
		      	/* //더보기 누르면 start +10 해주고 getMatchInfo 호출
		        $(document).on("click", ".btn-more", function () {
		            start += 10;
		            console.log(start);
		            searchMore(start, gameName, tagLine); // 값 전달
		        }); */
		    });
	    });    
    </script>
    
	<!-- 2. 소환사 정보 출력 함수 -->
	<script type="text/javascript">
	    function getSummonerProfile(puuid, gameName, tagLine) {
	        $.ajax({
	        	async : false,
	            url: '<c:url value="/lol/getSummonerByPuuid"/>',
	            method: 'GET',
	            data: { puuid: puuid },
	            success: function (summonerProfile) {
	                const id = summonerProfile.id;
	                const iconId = summonerProfile.profileIconId;
	                const level = summonerProfile.summonerLevel;
	                console.log(puuid);
	                console.log(id);

	                $.ajax({
	                    url: '<c:url value="/lol/getSummonerProfile"/>',
	                    method: 'GET',
	                    data: { puuid : puuid, summonerId: id, gameName : gameName, tagLine : tagLine},
	                    success: function (summoner) {
	                        $('#summonerProfile').html(summoner);
	                    }
	                });
	            }
	        });
	    }
    </script>
    
    <script type="text/javascript">
	    function getGameInfo(puuid, start) {
	        $.ajax({
	            url: '<c:url value="/lol/recentLOLMatchIds"/>',
	            method: 'GET',
	            data: { puuid: puuid, start: start },
	            success: function (matchIds) {
	                if (matchIds.length > 0) {
	                    $('#matchList').html(''); // 초기화
	                    fetchLOLMatchDetails(matchIds, 0, puuid);
	                } else {
	                    $('#matchList').html('<p>최근 경기 데이터가 없습니다.</p>');
	                }
	            }
	        });
	    }
	
	    function fetchLOLMatchDetails(matchIds, index, puuid) {
	        if (index >= matchIds.length) return;
	        const matchId = matchIds[index];
	
	        $.ajax({
	            url: '<c:url value="/lol/matchDetail"/>',
	            method: 'GET',
	            data: { matchId: matchId, puuid: puuid }, // puuid도 넘기기
	            success: function (matchHTML) {
	                $('#gameInfo').append(matchHTML); // JSP 조각 append
	                fetchLOLMatchDetails(matchIds, index + 1, puuid); // 다음 경기
	            },
	            error: function () {
	                $('#gameInfo').append('<p style="color:red;">경기 정보를 불러오는 데 실패했습니다. (' + matchId + ')</p>');
	                fetchLOLMatchDetails(matchIds, index + 1, puuid); // 에러 나도 다음으로
	            }
	        });
	    }
	</script>
</body>
</html>