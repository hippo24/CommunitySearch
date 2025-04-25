<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%request.setAttribute("pageType", "tft");%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h3>🔍 TFT 전적 상세 조회</h3>
	<p>
		소환사 이름을 <strong>게임이름#태그라인</strong> 형식으로 입력하세요 (예 : 바다새#KR1)
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
		<input type="hidden" name="puuid">
		<button class="btn-search" type="submit">조회</button>
	</form>
	<script type="text/javascript">
		$('#summonerForm').on('submit', function (e) {
		    $('#summonerProfile').html('');
		    $('#gameInfo').html('');
	        
	        gameName = $('#gameName').val();
	        tagLine = $('#tagLine').val();
	        start = 0; // 처음부터 시작
	
	        // 1. PUUID, Summoner ID 조회
	        $.ajax({
	        	async : false,
	        	url: '<c:url value="/tft/searchPUUID"/>',
	            method: 'GET',
	            data: { gameName: gameName, tagLine: tagLine },
	            success: function (response) {
	                const puuid = response.puuid;
					$("[name=puuid]").val(puuid)
	            }
	        });
	    });
	</script>
</body>
</html>