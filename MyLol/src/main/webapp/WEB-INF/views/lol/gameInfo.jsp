<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page import="java.util.*" %>
<%
    ObjectMapper mapper = new ObjectMapper();
    String userJson = mapper.writeValueAsString(request.getAttribute("user"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .infoBox {
            background-color: #f8f9fa;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            border-radius: 12px;
            padding: 16px;
            margin-bottom: 20px;
        }
        .rune-img {
            width: 40px;
            margin-right: 5px;
        }
    </style>
</head>
<body>

<div id="summonerProfile" style="margin-top: 20px;">
    <div class="infoBox" id="userDetailBox">
        <div><strong>유저:</strong> ${user.riotIdGameName}#${user.riotIdTagline}</div>
        <div><strong>챔피언:</strong> ${user.championName}</div>
        <div><strong>라인:</strong> ${user.teamPosition}</div>
        <div><strong>K/D/A:</strong> ${user.kills} / ${user.deaths} / ${user.assists}</div>
        <div><strong>승리 여부:</strong> 
            <span style="color:${user.win ? 'blue' : 'red'}">
                ${user.win ? '승리' : '패배'}
            </span>
        </div>
        <div>
            <strong>게임 시간:</strong>
            <fmt:formatNumber value="${user.timePlayed / 60}" maxFractionDigits="0"/>분 
            <fmt:formatNumber value="${user.timePlayed % 60}" maxFractionDigits="0"/>초
        </div>
    </div>
</div>

<script>
    user = <%= userJson %>;

    Promise.all([
        fetch("https://ddragon.leagueoflegends.com/cdn/15.7.1/data/ko_KR/champion.json").then(res => res.json()),
        fetch("https://ddragon.leagueoflegends.com/cdn/15.6.1/data/ko_KR/summoner.json").then(res => res.json()),
        fetch("https://ddragon.leagueoflegends.com/cdn/15.6.1/data/ko_KR/runesReforged.json").then(res => res.json())
    ]).then(([championRes, spellRes, runeRes]) => {
        renderRunes(runeRes, user.perks);
    });

    function renderRunes(runeData, userPerks) {
        if (!userPerks || !userPerks.styles) return;

        let runeHtml = "<div class='infoBox'><strong>사용한 룬</strong><br><br>";

        const primaryStyleId = userPerks.styles[0].style;
        const subStyleId = userPerks.styles[1].style;

        const primaryStyle = runeData.find(r => r.id === primaryStyleId);
        const subStyle = runeData.find(r => r.id === subStyleId);

        const primaryRunes = userPerks.styles[0].selections.map(sel => {
            for (const slot of primaryStyle.slots) {
                const found = slot.runes.find(r => r.id === sel.perk);
                if (found) return found;
            }
            return null;
        }).filter(r => r !== null);

        const subRunes = userPerks.styles[1].selections.map(sel => {
            for (const slot of subStyle.slots) {
                const found = slot.runes.find(r => r.id === sel.perk);
                if (found) return found;
            }
            return null;
        }).filter(r => r !== null);

        runeHtml += `<div><strong>주 룬 (${primaryStyle.name})</strong><br>`;
        runeHtml += primaryRunes.map(r => `
            <img src="https://ddragon.leagueoflegends.com/cdn/img/${r.icon}" title="${r.name}" class="rune-img">
        `).join("") + "</div><br>";

        runeHtml += `<div><strong>보조 룬 (${subStyle.name})</strong><br>`;
        runeHtml += subRunes.map(r => `
            <img src="https://ddragon.leagueoflegends.com/cdn/img/${r.icon}" title="${r.name}" class="rune-img">
        `).join("") + "</div>";

        runeHtml += "</div>";
        document.getElementById("userDetailBox").innerHTML += runeHtml;
    }
</script>

</body>
</html>
