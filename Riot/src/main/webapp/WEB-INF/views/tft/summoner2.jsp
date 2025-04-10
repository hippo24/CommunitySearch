<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%request.setAttribute("pageType", "lol");%>
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
                                    matchDetailHtml += '<strong>사용 유닛:</strong><ul>';
                                    
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
                                    matchDetailHtml += '</ul><strong>시너지:</strong><div style="display: flex; flex-wrap: wrap; gap: 8px;">';

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

                                    const stylePriority = {
                                        3: 1,
                                        5: 2,
                                        4: 3,
                                        2: 4,
                                        1: 5
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

                                    matchDetailHtml += '</div><hr>';

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