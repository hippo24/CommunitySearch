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

.champ-img {
	width: 60px;
	height: 60px;
	object-fit: cover;
	object-position: 90% top;
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
	        fetch("https://ddragon.leagueoflegends.com/cdn/15.8.1/data/ko_KR/tft-item.json").then(res => res.json())
	    ]).then(([tacticianRes, itemRes]) => {
	        tacticianData = tacticianRes.data;
	        itemData = itemRes.data;
			console.log(tacticianData);
			console.log(tacticianData);
	        // 데이터를 다 불러온 후, 이제 경기를 출력
	        //fetchMatchDetails(matchIds, 0, puuid);
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
    	console.log(matchId);
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
                	
                    var matchDetailHtml = '<div class="infoBox form-control mt-3 mb-3">'+
                    '<h3>경기 상세 정보 (경기 ID: ' + matchId + ')</h3>';
                    matchDetailResponse.info.participants.forEach(function(player) {
                        
	                   	// 입력한 유저의 정보만 표시
	                   	if (player.puuid === puuid) {
	                        	
	              			//전설이 이미지 url
					    	playerUrl ="https://ddragon.leagueoflegends.com/cdn/15.8.1/img/tft-tactician/" + tacticianData[player.companion.item_ID].image.full;
		
						    matchDetailHtml += '<div style="display: flex; align-items: center; margin-bottom: 10px;">';
							matchDetailHtml += '<figure><img src="' + playerUrl + '" alt="dkz" class="rounded-circle" style="width: 50px; height: 50px; margin-right: 10px;" />';
							matchDetailHtml += '<span>레벨 : ' + player.level + ' / </span>';
							matchDetailHtml += '<span>등수 : ' + player.placement + '</span>';
							matchDetailHtml += '</figure></div>';
								
                           	matchDetailHtml += '<strong>사용 유닛:</strong><ul>';
                            
                            //API에서 이름을 JSON과 다른 이름으로 가져오는 경우가 있음.
                            const championImageNameMap = {"Chogath": "ChoGath"};
                            if (player.units && player.units.length > 0) {
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
                            } else {
                                matchDetailHtml += '<ol>유닛 정보가 없습니다.</ol>';
                            }
	
                            matchDetailHtml += '</ul>';
                            matchDetailHtml += '<strong>시너지:</strong><div style="display: flex; flex-wrap: wrap; gap: 8px;">';
	
                            const styleBgMap = {
                                1: "https://cdn.dak.gg/tft/images2/tft/traits/background/bronze.svg",
                                2: "https://cdn.dak.gg/tft/images2/tft/traits/background/silver.svg",
                                3: "https://cdn.dak.gg/tft/images2/tft/traits/background/unique.svg",
                                4: "https://cdn.dak.gg/tft/images2/tft/traits/background/gold.svg",
                                5: "https://cdn.dak.gg/tft/images2/tft/traits/background/chromatic.svg"
                            };
	
                            const traitMetaMap = {
                                "TFT14_Immortal": { name: "황금 황소", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_14_goldenox.tft_set14.png" },
                                "TFT14_Cutter": { name: "처형자", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_4_executioner.png" },
                                "TFT14_Strong": { name: "학살자", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_4_slayer.png" },
                                "TFT14_Marksman": { name: "사격수", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_14_marksman.tft_set14.png" },
                                "TFT14_Techie": { name: "기술광", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_14_techie.tft_set14.png" },
                                "TFT14_Controller": { name: "책략가", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_9_strategist.png" },
                                "TFT14_Armorclad": { name: "요새", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_9_bastion.png" },
                                "TFT14_Supercharge": { name: "증.폭.", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_14_amp.tft_set14.png" },
                                "TFT14_HotRod": { name: "니트로", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_14_nitroforge.tft_set14.png" },
                                "TFT14_Cyberboss": { name: "사이버보스", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_14_cyberbosses.tft_set14.png" },
                                "TFT14_Divinicorp": { name: "신성기업", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_14_divinicorp.tft_set14.png" },
                                "TFT14_EdgeRunner": { name: "엑소테크", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_14_exotech.tft_set14.png" },
                                "TFT14_Bruiser": { name: "난동꾼", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_14_bruiser.tft_set14.png" },
                                "TFT14_Thirsty": { name: "다이나모", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_14_dynamo.tft_set14.png" },
                                "TFT14_Mob": { name: "범죄 조직", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_14_mob.tft_set14.png" },
                                "TFT14_Netgod": { name: "네트워크의 신", icon: "https://cdn.metatft.com/file/metatft/traits/netgod.png" },
                                "TFT14_Swift": { name: "속사포", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_10_rapidfire.png" },
                                "TFT14_StreetDemon": { name: "거리의 악마", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_14_streetdemon.tft_set14.png" },
                                "TFT14_AnimaSquad": { name: "동물특공대", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_14_animasquad.tft_set14.png" },
                                "TFT14_Suits": { name: "사이퍼", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_14_cypher.tft_set14.png" },
                                "TFT14_BallisTek": { name: "폭발 봇", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_14_boombots.tft_set14.png" },
                                "TFT14_Vanguard": { name: "선봉대", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_12_vanguard.tft_set12.png" },
                                "TFT14_ViegoUniqueTrait": { name: "영혼 살해자", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_14_soulkiller.tft_set14.png" },
                                "TFT14_Overlord": { name: "군주", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_14_overlord.tft_set14.png" },
                                "TFT14_Virus": { name: "바이러스", icon: "https://raw.communitydragon.org/latest/game/assets/ux/traiticons/trait_icon_14_virus.tft_set14.png" }
                            };
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
                	/* .finally(res=>{
                		$(".btn-more").remove();
	                		const btn = '<button class="btn btn-outline-success btn-more">더보기</button>';
	    	     	 	   	$('#gameInfo').append(btn);
                	
                   	}); */
        			//내용들 막 우겨넣은 matchDetailHtml 화면에 출력시키기.
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

	<script type="text/javascript">
	    
	   
    </script>
</body>
</html>