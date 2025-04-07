<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>소환사 정보</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<style>
		.champ-img {
		  width: 60px;
		  height: 60px;
		  object-fit: cover;
		  object-position: 90% top; 
		  border-radius: 5px;
		}
	</style>
</head>
<body>
    <h1>소환사 정보</h1>
    <form id="summonerForm">
        <label for="gameName">게임 이름:</label>
        <input type="text" id="gameName" name="gameName" required>
        <br>
        <label for="tagLine">태그라인:</label>
        <input type="text" id="tagLine" name="tagLine" required>
        <br>
        <button type="submit">조회</button>
    </form>
    <div id="summonerProfile" style="margin-top: 20px;">
        <!-- 소환사 정보가 여기에 표시됩니다. -->
    </div>
    <br>
    <div id="summonerInfo" style="margin-top: 20px;">
        <!-- 소환사 정보가 여기에 표시됩니다. -->
    </div>

    <script>
        $(function() {
        	//조회버튼을 눌렀을 때
            $('#summonerForm').on('submit', function(e) {
                e.preventDefault(); // 폼 제출 시 페이지 새로고침 방지

                var gameName = $('#gameName').val(); // ex)바다새
                var tagLine = $('#tagLine').val();   // ex)kr1

                // 소환사 정보를 요청
                $.ajax({
                    url: '<c:url value="/tft/searchPUUID"/>',
                    method: 'GET',
                    data: {
                        gameName: gameName,
                        tagLine: tagLine
                    },
                    success: function(response) {
                        if (response.error) {
                            $('#summonerInfo').html('<p style="color: red;">' + response.error + '</p>');
                        } else {
                            var puuid = response.puuid;
                            
                            // 소환사 정보 요청
                            $.ajax({
                                url: '<c:url value="/tft/getSummonerByPuuid"/>',
                                method: 'GET',
                                data: { puuid: puuid },
                                success: function(summonerProfile) {
                                	//소환사 id -> 소환사 정보 더 가져올 수 있음
                                	var id = summonerProfile.id;
                                	
                                	var profileIconId = summonerProfile.profileIconId;
                                	var revisionDate = summonerProfile.revisionDate;
                                	var summonerLevel = summonerProfile.summonerLevel;

                                	
                                    //ID로 티어, 점수, 판수 등 가져오기
                                    $.ajax({
                                        url: '<c:url value="/tft/getTFTLeagueInfo"/>',
                                        method: 'GET',
                                        data: { summonerId: id },
                                        success: function(summoners) {
                                        	var summoner = summoners[0];
                                        	console.log(summoner )
                                            var tier = summoner.tier;
                                            var rank = summoner.rank;
                                            var leaguePoints = summoner.leaguePoints;
                                            var wins = summoner.wins;
                                            var losses = summoner.losses;
                                            var totalGame = wins+losses;
                                            /* 이름#태그, 레벨 출력 */
                                        	var summonerPro = '<p>이름: ' + response.gameName + '#' + response.tagLine + '</p>';
                                        	summonerPro += '<img src="http://ddragon.leagueoflegends.com/cdn/14.6.1/img/profileicon/' 
                                        		+ profileIconId + '.png" alt="프로필 아이콘" width="50">';
                                        	summonerPro += '<p>레벨: ' + summonerLevel + '</p>';
                                        	summonerPro += '<p>티어: ' + tier + " " + rank + " " + leaguePoints + '</p>';
                                        	summonerPro += '<p>판수: ' + totalGame + '</p>';
                                        	summonerPro += '<p>순방: ' + wins + ' 패배: ' + losses + '</p>';
                                            $('#summonerProfile').html(summonerPro);
                                        },
                                        error: function() {
                                            $('#summonerInfo').append('<p style="color: red;">경기 ID를 가져오는 중 오류가 발생했습니다.</p>');
                                        }
                                    });
                                    
                                },
                                error: function() {
                                    $('#summonerInfo').append('<p style="color: red;">경기 ID를 가져오는 중 오류가 발생했습니다.</p>');
                                }
                            });

                            var summonerHtml = '<p>PUUID: ' + response.puuid + '</p>';
                            $('#summonerInfo').html(summonerHtml);

                            // TFT 경기 ID 요청
                            $.ajax({
                                url: '<c:url value="/tft/recentTftMatchIds"/>',
                                method: 'GET',
                                data: { puuid: puuid },
                                success: function(matchIdsResponse) {
                                    if (matchIdsResponse.length > 0) {
                                        // 경기 정보를 순차적으로 가져오기
                                        console.log(matchIdsResponse);
                                        fetchMatchDetails(matchIdsResponse, 0, puuid);
                                    } else {
                                        $('#summonerInfo').append('<p>최근 경기 데이터가 없습니다.</p>');
                                    }
                                },
                                error: function() {
                                    $('#summonerInfo').append('<p style="color: red;">경기 ID를 가져오는 중 오류가 발생했습니다.</p>');
                                }
                            });
                        }
                    },
                    error: function() {
                        $('#summonerInfo').html('<p style="color: red;">소환사 정보를 가져오는 중 오류가 발생했습니다.</p>');
                    }
                });
            });

            function fetchMatchDetails(matchIds, index, puuid) {
                if (index >= matchIds.length) return; // 모든 경기를 처리했으면 종료

                var matchId = matchIds[index];
                $.ajax({
                    url: '<c:url value="/tft/matchDetail"/>',
                    method: 'GET',
                    data: { matchId: matchId },
                    success: function(matchDetailResponse) {
                        if (matchDetailResponse.error) {
                            $('#summonerInfo').append('<p style="color: red;">경기 ID ' + matchId + ': ' + matchDetailResponse.error + '</p>');
                        } else {
                        	
                            var matchDetailHtml = '<h3>경기 상세 정보 (경기 ID: ' + matchId + ')</h3>';
                            matchDetailResponse.info.participants.forEach(function(player) {
                                // 입력한 유저의 정보만 표시
                                if (player.puuid === puuid) {
                                	player.companion
                                	
                                    matchDetailHtml += '<p>순위: ' + player.placement + '</p>';
                                    matchDetailHtml += '<p>사용 유닛:</p><ul>';
                                    
                                    //API에서 이름을 JSON과 다른 이름으로 가져오는 경우가 있음.
                                    const championImageNameMap = {"Chogath": "ChoGath"};
                                    player.units.forEach(function(unit) {
                                    	
                                    	//이미지 정보가 없는 유닛들은 표시하지 않기로 함.
                                    	if (unit.character_id.startsWith("TFT14_Summon")) {
                                    	    return;
                                    	}
                                    	
                                    	// "TFT14_" 제거해서 순수 챔피언 이름만 추출
                                        var rawName = unit.character_id.replace("TFT14_", "");
                                    	
                                    	// 매핑이 있으면 수정된 이름 사용 ex) Chogath => ChoGath
                                        var correctedName = championImageNameMap[rawName] || rawName;
                                    	
                                     	// 다시 "TFT14_" 붙여서 이미지 URL 생성
                                        var champImageUrl = "https://ddragon.leagueoflegends.com/cdn/15.7.1/img/tft-champion/TFT14_" 
                                            + correctedName + ".TFT_Set14.png";	
                                    	
                                    	var borderColor; //이미지만 감싸는 div 태그에 스타일 넣기 위함
                                    	switch (unit.rarity) {
	                                        case 0: borderColor = 'gray'; break;
	                                        case 1: borderColor = 'lightgreen'; break;
	                                        case 2: borderColor = 'skyblue'; break;
	                                        case 4: borderColor = 'purple'; break;
	                                        case 6: borderColor = 'gold'; break;
	                                        default: borderColor = 'transparent';
                                    	}	
                                        
                                    	matchDetailHtml += '<div style="display: inline-block; text-align: center; margin-right: 8px;">';
                                        matchDetailHtml += '<img src="' + champImageUrl + '" class="champ-img" alt="' + correctedName + '" width="55" style="border: 4px solid ' + borderColor + '; vertical-align: middle;">';
                                        matchDetailHtml += '<div>' + '★' + unit.tier + '</div>';
                                        matchDetailHtml += '</div>';
                                    });
                                    matchDetailHtml += '</ul><strong>시너지:</strong><ul>';
                                    const traitNameMap = { 
                                 		  "TFT14_Immortal": "황금 황소",
                                 		  "TFT14_Cutter": "처형자",
                                 		  "TFT14_Strong": "학살자",
                                 		  "TFT14_Marksman": "사격수",
                                 		  "TFT14_Techie": "기술광",
                                 		  "TFT14_Controller": "책략가",
                                 		  "TFT14_Armorclad": "요새",
                                 		  "TFT14_Supercharge": "증.폭.",
                                 		  "TFT14_HotRod": "니트로",
                                 		  "TFT14_Cyberboss": "사이버보스",
                                 		  "TFT14_Divinicorp": "신성기업",
                                 		  "TFT14_EdgeRunner": "엑소테크",
                                 		  "TFT14_Bruiser": "난동꾼",
                                 		  "TFT14_Thirsty": "다이나모",
                                 		  "TFT14_Mob": "범죄 조직",
                                 		  "TFT14_Netgod": "네트워크의 신",
                                 		  "TFT14_Swift": "속사포",
                                 		  "TFT14_StreetDemon": "거리의 악마",
                                 		  "TFT14_AnimaSquad": "동물특공대",
                                 		  "TFT14_Suits": "사이퍼",
                                 		  "TFT14_BallisTek": "폭발 봇",
                                 		  "TFT14_Vanguard": "선봉대",
                                 		  "TFT14_ViegoUniqueTrait": "영혼 살해자",
                                 		  "TFT14_Overlord": "군주",
                                 		  "TFT14_Virus": "바이러스"
                                 	};

                                    const stylePriority = {
                                    	    3: 1, // 고유특성
                                    	    5: 2, // 프리즘
                                    	    4: 3, // 골드
                                    	    2: 4, // 실버
                                    	    1: 5  // 브론즈
                                    };
                                   	const styleName = {
                                   	    1: "브론즈",
                                   	    2: "실버",
                                   	    3: "고유특성",
                                   	    4: "골드",
                                   	    5: "프리즘"
                                   	};
                                   	const filteredTraits = player.traits
                                   	    .filter(trait => trait.tier_current > 0 && trait.style > 0)
                                   	    .sort((a, b) => {
                                   	        const aPriority = stylePriority[a.style] || 999;
                                   	        const bPriority = stylePriority[b.style] || 999;
                                   	        return aPriority - bPriority;
                                   	    });

                                  	filteredTraits.forEach(function(trait) {
                                  	    const displayName = traitNameMap[trait.name] || trait.name;
                                  	    const grade = styleName[trait.style] || '';
                                  	    matchDetailHtml += '<p>' + displayName + ' (' + trait.num_units + ', ' + grade + ')</p>';
                                  	});        
                                  	matchDetailHtml += '</ul><hr>';
                                }
                            });
                            $('#summonerInfo').append(matchDetailHtml);
                        }
                        // 다음 경기 ID로 넘어가기
                        fetchMatchDetails(matchIds, index + 1, puuid);
                    },
                    error: function() {
                        $('#summonerInfo').append('<p style="color: red;">경기 ID ' + matchId + '의 데이터를 가져오는 중 오류가 발생했습니다.</p>');
                        // 다음 경기 ID로 넘어가기
                        fetchMatchDetails(matchIds, index + 1, puuid);
                    }
                });
            }
        });
    </script>
</body>
</html>