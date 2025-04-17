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
<style>
body {
	font-family: "Segoe UI", sans-serif;
}
figure {
    position: relative; /* 레벨 텍스트를 이미지에 오버랩하기 위해 위치 설정 */
    display: inline-block; /* 인라인 블록으로 여러 개를 나란히 배치 가능 */
    /* margin: 10px; */ /* 여백 설정 */
    bottom: -8px;
}
.legend {
	
    width: 65px; /* 이미지 너비 설정 */
    height: 65px; /* 이미지 높이 설정 */
    border-radius: 50%; /* 원형으로 만들기 위한 설정 */
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.3); /* 그림자 추가 */
}

.level {
    position: absolute; /* 이미지 위에 오버랩하기 위해 절대 위치 설정 */
    bottom: 0px; /* 이미지 하단에서의 위치 */
    right: 2px; /* 이미지 오른쪽에서의 위치 */
    background-color: black; /* 배경색 (브라운 계열) */
    color: #8B5A3A; /* 글자 색상 */
    border: 1px solid;
    border-color: #8B5A3A;
    border-radius: 50%; /* 원형 배경 */
    width: 27px; /* 배경 너비 */
    height: 27px; /* 배경 높이 */
    display: flex; /* 중앙 정렬을 위해 flex 사용 */
    justify-content: center; /* 가로 중앙 정렬 */
    align-items: center; /* 세로 중앙 정렬 */
    font-size: 16px; /* 글자 크기 */
    font-weight: bold; /* 글자 두께 */
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.3); /* 그림자 추가 */
}
.unit-container {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 10px;
}

.unit-box {
  width: 70px;
  text-align: center;
  position: relative;
}

.unit-star {
  position: absolute;
  top: -20px;
  left: 0;
  right: 0;
  font-size: 14px;
  font-weight: bold;
  /* color: gold; */
  text-align: center;
}

.unit-image {
  border: 3px solid;
  border-radius: 8px;
  overflow: hidden;
  width: 60px;
  height: 60px;
  margin: 0 auto;
}

.unit-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.unit-items {
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  gap: 2px;
  margin-top: 4px;
}

.unit-items img {
  width: 17px;
  height: 17px;
  border-radius: 4px;
}

.champ-img {
	width: 60px;
	height: 60px;
	object-fit: cover;
	object-position: 75% top;
	border-radius: 5px;
}

.infoBox {
	min-height: auto;
	height: auto;
	background-color: #f8f9fa;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	border-radius: 12px;
} 
</style>
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
	
	    // 전설이와 아이템 json을 미리 한 번만 불러오기
	    Promise.all([
	        fetch("https://ddragon.leagueoflegends.com/cdn/15.8.1/data/en_US/tft-tactician.json").then(res => res.json()),
	        fetch("https://ddragon.leagueoflegends.com/cdn/15.8.1/data/ko_KR/tft-item.json").then(res => res.json()),
	        fetch("https://ddragon.leagueoflegends.com/cdn/15.7.1/data/ko_KR/tft-trait.json").then(res => res.json()),
	        fetch("https://ddragon.leagueoflegends.com/cdn/15.7.1/data/ko_KR/tft-champion.json").then(res => res.json())
	    ]).then(([tacticianRes, itemRes, traitRes, championRes]) => {
	        tacticianData = tacticianRes.data;
	        itemData = itemRes.data;
	        traitData = traitRes.data;
	        championData = championRes.data;
			//console.log(itemData);
				
	        // 데이터를 다 불러온 후, 이제 경기를 출력
			let start = 0;
		    let gameName = "";
		    let tagLine = "";
	    	$('#summonerForm').on('submit', function (e) {
			    $('#summonerProfile').html('');
			    $('#gameInfo').html('');
		        e.preventDefault();
		        
		        gameName = $('#gameName').val();
		        tagLine = $('#tagLine').val();
		        start = 0; // 처음부터 시작
	
		        // 1. PUUID, Summoner ID 조회
		        $.ajax({
		        	url: '<c:url value="/tft/searchPUUID"/>',
		            method: 'GET',
		            data: { gameName: gameName, tagLine: tagLine },
		            success: function (response) {
		                const puuid = response.puuid;
		
		                getSummonerProfile(puuid, gameName, tagLine); // 소환사 정보
		                getMatchInfo(puuid, start); // 경기 정보
		            }
		        });
		    });
	      	//더보기 누르면 start +10 해주고 getMatchInfo 호출
	        $(document).on("click", ".btn-more", function () {
	            start += 10;
	            console.log(start);
	            searchMore(start, gameName, tagLine); // 값 전달
	        });
	    });    
    </script>

	<script type="text/javascript">
	    function searchMore(start, gameName, tagLine) {
	        console.log(gameName);
	    	$.ajax({
	            url: '<c:url value="/tft/searchPUUID"/>',
	            method: 'GET',
	            data: { gameName: gameName, tagLine: tagLine },
	            success: function (response) {
	                const puuid = response.puuid;
	                getMatchInfo(puuid, start);
	            }
	        });
	    }
    </script>


	<!-- 2. 소환사 정보 출력 함수 -->
	<script type="text/javascript">
	    function getSummonerProfile(puuid, gameName, tagLine) {
	        $.ajax({
	        	async : false,
	            url: '<c:url value="/tft/getSummonerByPuuid"/>',
	            method: 'GET',
	            data: { puuid: puuid },
	            success: function (summonerProfile) {
	                const id = summonerProfile.id;
	                const iconId = summonerProfile.profileIconId;
	                const level = summonerProfile.summonerLevel;
	                console.log(id);

	                $.ajax({
	                    url: '<c:url value="/tft/getSummonerProfile"/>',
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
   		 // TFT 경기 ID 요청
    	function getMatchInfo(puuid, start) {	 	    
   			$.ajax({
		    	async : false,
		        url: '<c:url value="/tft/recentTftMatchIds"/>',
		        method: 'GET',
		        data: { puuid: puuid, start : start },
		        success: function(matchIds) {
		            if (matchIds.length > 0) {
		                // 경기 정보를 순차적으로 가져오기
		                console.log(matchIds);
		                fetchMatchDetails(matchIds, 0, puuid);
		            } else {
		                $('#summonerMatchInfo').append('<p>최근 경기 데이터가 없습니다.</p>');
		            }
		        },
		        error: function() {
		            $('#summonerMatchInfo').append('<p style="color: red;">경기 ID를 가져오는 중 오류가 발생했습니다.</p>');
		        }
		    });
    	}
   		// 유닛 아이디가 TFT14로 시작하지않으면 14시즌 게임이 아님
    	function isSet14Game(matchInfo) {
    	    return matchInfo.participants.some(p =>
    	        p.units.some(unit => unit.character_id.startsWith("TFT14_"))
    	    );
    	}
    </script>
    
	<script type="text/javascript">
    function fetchMatchDetails(matchIds, index, puuid) {
        if (index >= matchIds.length) return; // 모든 경기를 처리했으면 종료

        var matchId = matchIds[index];
        $.ajax({
        	async : false,
            url: '<c:url value="/tft/matchDetail"/>',
            method: 'GET',
            data: { matchId: matchId },
            success: function(matchDetailResponse) {
                if (matchDetailResponse.error) {
                    $('#summonerMatchInfo').append('<p style="color: red;">경기 ID ' + matchId + ': ' + matchDetailResponse.error + '</p>');
                } else {
                	if (!isSet14Game(matchDetailResponse.info)) {
                        console.log("13시즌 경기이므로 제외: " + matchId);
                        $(".btn-more").remove();
                        return;
                    }
                	
                    var matchDetailHtml = '<div class="infoBox form-control mt-3 mb-3">'
                    
                    ;
                    matchDetailResponse.info.participants.forEach(function(player) {
                        
	                   	// 입력한 유저의 정보만 표시
	                   	if (player.puuid === puuid) {
	                        	
	              			//전설이 이미지 url
					    	playerUrl ="https://ddragon.leagueoflegends.com/cdn/15.8.1/img/tft-tactician/" + tacticianData[player.companion.item_ID].image.full;
					    	matchDetailHtml += '<h3>#' + player.placement + '</h3>'+' <h3>경기 상세 정보 (경기 ID: ' + matchId + ')</h3>';
						    matchDetailHtml += '<div class="legend ml-3 mt-3" style="display: flex; align-items: center; margin-bottom: 10px;">'+
													'<figure>'+
														'<img src="' + playerUrl + '" alt="'+ tacticianData[player.companion.item_ID] +'" class="legend"/>'+
														'<span class="level">' + player.level + '</span>'+
													'</figure>'+
													
												'</div>';
								
                           	matchDetailHtml += '<div class="mt-6 mb-3 ml-2">';
                           	
                           	const championMetaMap = {}; //챔피언
                           	const itemDataById = {};	//아이템
                           	for (const key in championData) {
                           	    const champ = championData[key];
                           	    championMetaMap[champ.id] = champ;
                           	}
                           	for (const key in itemData) {
                           	    const item = itemData[key];
                           	    if (item.id) {
                           	        itemDataById[item.id] = item;
                           	    }
                           	}
                           	matchDetailHtml += '<div class="unit-container">';
                            if (player.units && player.units.length > 0) {
                                player.units.forEach(function(unit) {
	                            	// 소환수는 0 코스트 취급. 테두리는 1코스트처럼 두기.
	                            	if (unit.character_id.startsWith("TFT14_Summon")){unit.rarity = 0; };

								  	// championMetaMap에서 유닛 데이터 찾기
								  	const champMeta = championMetaMap[unit.character_id];
								  	if (!champMeta) return; // 매칭 안 되면 스킵
								
								  	const champName = champMeta.name;
								  	//const champTier = champMeta.tier;
								  	const champImageUrl = "https://ddragon.leagueoflegends.com/cdn/15.7.1/img/tft-champion/" + champMeta.image.full;
		                            	
	                            	var borderColor; //이미지만 감싸는 div 태그에 스타일 넣기 위함
	                            	switch (unit.rarity) {
	                                    case 0: borderColor = 'gray'; break;
	                                    case 1: borderColor = 'lightgreen'; break;
	                                    case 2: borderColor = 'skyblue'; break;
	                                    case 4: borderColor = 'purple'; break;
	                                    case 6: borderColor = 'gold'; break;
	                                    default: borderColor = 'transparent';
	                            	}	
		                                
	                            	matchDetailHtml += '<div class="unit-box mt-3">'+
							                            	//별
							                                '<div class="unit-star">★'+ unit.tier+ '</div>'+
							                                '<div class="unit-image" style="border-color: '+ borderColor + '">'+
		                            							//챔피언
		                            							'<img src="' + champImageUrl + '" class="champ-img" alt="' + champName + '" />'+
                            								'</div>'+
                                    						'<div class="unit-items">';
	                             	// 아이템 이미지들 출력
	                                if (unit.itemNames && unit.itemNames.length > 0) {
	                                    unit.itemNames.forEach(function(itemId) {
	                                        const itemMeta = itemDataById[itemId];
	                                        if (!itemMeta) return;

	                                       	const itemImgUrl = "https://ddragon.leagueoflegends.com/cdn/15.8.1/img/tft-item/" + itemMeta.image.full;;
	                                        //아이템
	                                       	matchDetailHtml += '<img src="' + itemImgUrl + '" alt="' + itemMeta.name + '" />';
	                                    });
	                                }
	                                matchDetailHtml += '</div></div>';
                                });
                            } else {
                                matchDetailHtml += '<ol>유닛 정보가 없습니다.</ol>';
                            }
                            matchDetailHtml += '</div>'; 
                            matchDetailHtml += '</div>';
                            matchDetailHtml += '<div style="display: flex; flex-wrap: wrap; gap: 8px;">';
	
                            const styleBgMap = {
                                1: "https://cdn.dak.gg/tft/images2/tft/traits/background/bronze.svg",
                                2: "https://cdn.dak.gg/tft/images2/tft/traits/background/silver.svg",
                                3: "https://cdn.dak.gg/tft/images2/tft/traits/background/unique.svg",
                                4: "https://cdn.dak.gg/tft/images2/tft/traits/background/gold.svg",
                                5: "https://cdn.dak.gg/tft/images2/tft/traits/background/chromatic.svg"
                            };
	
                            const traitMetaMap = {};
                            for (const key in traitData) {
                                const trait = traitData[key];
                                traitMetaMap[key] = {
                                    name: trait.name,
                                    icon: "https://ddragon.leagueoflegends.com/cdn/15.7.1/img/tft-trait/"+ trait.image.full
                                };
                            }
							//시너지
                            const stylePriority = {
                                3: 1, //유니크
                                5: 2, //프리즘
                                4: 3, //골드
                                2: 4, //실버
                                1: 5  //브론즈
                            };
	
                            const styleName = {
                                1: "브론즈",
                                2: "실버",
                                3: "고유특성",
                                4: "골드",
                                5: "프리즘"
                            };
							//표시해주는 우선순위 설정
                            const filteredTraits = player.traits
                            .filter(trait => trait.tier_current > 0 && trait.style > 0)
                            .sort((a, b) => {
                                    const aPriority = stylePriority[a.style] || 999;
                                    const bPriority = stylePriority[b.style] || 999;
                                    return aPriority - bPriority;
                            });
							//화면에 표시하기
                            filteredTraits.forEach(function(trait) {
                                const meta = traitMetaMap[trait.name];
                                const displayName = meta ? meta.name : trait.name;
                                const imageUrl = meta ? meta.icon : '';
                                const bgUrl = styleBgMap[trait.style] || '';
                                const grade = styleName[trait.style] || '';

                                if (imageUrl) {
                                    matchDetailHtml += 
                                    '<div style="display: inline-block; width: 86px; text-align: center;">' + 
                                        '<div style="position: relative; width: 32px; height: 32px; margin: 0 auto;">' +
                                            '<img src="' + bgUrl + '" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;">' +
                                            '<img src="' + imageUrl + '" alt="' + displayName + '" style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 18px; height: 18px; filter: invert(1);" />' +
                                        '</div>' +
                                        '<div style="font-size: 12px; margin-top: 2px;">' + trait.num_units + ' ' + displayName + '</div>' +
                                    '</div>';
                                }
                            });
                            matchDetailHtml += '</div></div>';
		                    $('#gameInfo').append(matchDetailHtml);
                       	}
                   	})
                }
                // 다음 경기 ID로 넘어가기
                fetchMatchDetails(matchIds, index + 1, puuid);

            },
            error: function() {
                $('#gameInfo').append('<p style="color: red;">경기 ID ' + matchId + '의 데이터를 가져오는 중 오류가 발생했습니다.</p>');
                // 다음 경기 ID로 넘어가기
                fetchMatchDetails(matchIds, index + 1, puuid);
            },
            complete: function() {
                $(".btn-more").remove();
                const btn = '<button class="btn btn-outline-success btn-more">더보기</button>';
                $('#gameInfo').append(btn);
            }
        });  
    }
    </script>
</body>
</html>