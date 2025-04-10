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

        .profile-card, .match-card {
            border: 1px solid #ccc;
            border-radius: 12px;
            padding: 1rem;
            margin: 1rem 0;
            background: #f9f9f9;
        }

        #loadMoreBtn {
            margin: 1rem auto;
            display: block;
        }
    </style>
</head>
<body>
    <h1>소환사 정보</h1>

    <!-- 폼 -->
    <form id="summonerForm">
        <label for="gameName">게임 이름:</label>
        <input type="text" id="gameName" name="gameName" required>
        <br>
        <label for="tagLine">태그라인:</label>
        <input type="text" id="tagLine" name="tagLine" required>
        <br>
        <button type="submit" id="searchBtn">조회</button>
    </form>

    <!-- JSTL로 기본 URL 세팅 (쿼리 X) -->
    <c:url var="searchPUUIDUrl" value="/tft/searchPUUID" />
    <c:url var="getSummonerUrl" value="/tft/getSummonerByPuuid" />
    <c:url var="getLeagueUrl" value="/tft/getTFTLeagueInfo" />
    <c:url var="getMatchIdsUrl" value="/tft/getMatchIds" />
    <c:url var="getMatchDetailUrl" value="/tft/getMatchDetail" />

    <!-- 결과 표시 영역 -->
    <div id="summonerProfile"></div>
    <div id="summonerInfo"></div>
    <button id="loadMoreBtn" style="display: none;">더 보기</button>

    <script>
    console.log("getMatchDetailUrl:", '${getMatchDetailUrl}');

        document.addEventListener("DOMContentLoaded", () => {
            const form = document.getElementById("summonerForm");
            const loadMoreBtn = document.getElementById("loadMoreBtn");
            let matchIndex = 0;
            let matchIds = [];

            // JSTL에서 전달된 URL 변수
            const searchPUUIDUrl = '${searchPUUIDUrl}';
            const getSummonerUrl = '${getSummonerUrl}';
            const getLeagueUrl = '${getLeagueUrl}';
            const getMatchIdsUrl = '${getMatchIdsUrl}';
            const getMatchDetailUrl = '${getMatchDetailUrl}';

            form.addEventListener("submit", async (e) => {
                e.preventDefault();

                const gameName = document.getElementById("gameName").value;
                const tagLine = document.getElementById("tagLine").value;
                matchIndex = 0;
                matchIds = [];

                try {
                    const puuid = await fetchPUUID(gameName, tagLine);
                    const summonerInfo = await fetchSummonerInfo(puuid);
                    const leagueInfo = await fetchLeagueInfo(summonerInfo.id);
                    displaySummonerProfile(summonerInfo, leagueInfo);

                    matchIds = await fetchMatchIds(puuid);
                    document.getElementById("summonerInfo").innerHTML = "";
                    await loadMatchDetails();
                } catch (error) {
                    console.error("전체 흐름 에러:", error);
                }
            });

            loadMoreBtn.addEventListener("click", loadMatchDetails);

            async function fetchPUUID(gameName, tagLine) {
                const url = `${searchPUUIDUrl}?gameName=${encodeURIComponent(gameName)}&tagLine=${encodeURIComponent(tagLine)}`;
                const res = await fetch(url);
                const data = await res.json();
                return data.puuid;
            }

            async function fetchSummonerInfo(puuid) {
                const res = await fetch(`${getSummonerUrl}?puuid=${encodeURIComponent(puuid)}`);
                return await res.json();
            }

            async function fetchLeagueInfo(summonerId) {
                const res = await fetch(`${getLeagueUrl}?summonerId=${encodeURIComponent(summonerId)}`);
                return await res.json();
            }

            async function fetchMatchIds(puuid) {
                const res = await fetch(`${getMatchIdsUrl}?puuid=${encodeURIComponent(puuid)}`);
                return await res.json();
            }

            async function fetchMatchDetail(matchId) {
                const res = await fetch(`${getMatchDetailUrl}?matchId=${encodeURIComponent(matchId)}`);
                return await res.json();
            }

            async function loadMatchDetails() {
                const container = document.getElementById("summonerInfo");
                const batch = matchIds.slice(matchIndex, matchIndex + 3);

                for (const matchId of batch) {
                    const matchData = await fetchMatchDetail(matchId);
                    const html = renderMatchHTML(matchData);
                    container.insertAdjacentHTML("beforeend", html);
                }

                matchIndex += 3;
                loadMoreBtn.style.display = matchIndex < matchIds.length ? "block" : "none";
            }

            function displaySummonerProfile(info, league) {
                const tierInfo = league.tier || "Unranked";
                const rank = league.rank || "";
                const lp = league.leaguePoints || "";

                const profileHTML = `
                    <div class="profile-card">
                        <h2>${info.name} (${info.tagLine})</h2>
                        <p>레벨: ${info.summonerLevel}</p>
                        <p>티어: ${tierInfo} ${rank} (${lp} LP)</p>
                    </div>
                `;
                document.getElementById("summonerProfile").innerHTML = profileHTML;
            }

            function renderMatchHTML(data) {
                const participant = data.info.participants.find(p => p.placement);
                const placement = participant.placement;
                const units = participant.units.map(unit => unit.character_id.replace("TFT14_", "")).join(", ");
                const traits = participant.traits
                    .filter(t => t.tier_current > 0)
                    .map(t => `${traitNameMap[t.name] || t.name} (${t.tier_current})`)
                    .join(", ");

                return `
                    <div class="match-card">
                        <h3>${placement}등</h3>
                        <p><strong>유닛:</strong> ${units}</p>
                        <p><strong>시너지:</strong> ${traits}</p>
                    </div>
                `;
            }

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
        });
    </script>
</body>
</html>
