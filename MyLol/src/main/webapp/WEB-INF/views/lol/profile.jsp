<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%request.setAttribute("pageType", "tft");%>
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
		.champion-spell-container {
			display: flex;
			align-items: center;
			gap: 4px;
		}

		.champion-icon {
			width: 48px;
			height: 48px;
		}

		.spell-icons {
			display: flex;
			flex-direction: column;
			gap: 2px;
		}

		.spell-icon {
			width: 24px;
			height: 24px;
		}

		.spell-rune-container {
			display: flex;
			gap: 2px;
		}

		.items {
			display: flex;
			flex-direction: column;
			gap: 4px;
		}

		.first-row, .second-row {
			display: flex;
			gap: 4px;
		}

		.primary-rune-icon {
			width: 26px;
			height: 26px;
		}

		.secondary-rune-icon {
			width: 19px;
			height: 19px;
			margin-left: 3px;
		}

		.rune-icons {
			display: flex;
			flex-direction: column;  /* 세로 정렬 */
			gap: 2px;
		}
	</style>
</head>
<body>
    <div id="summonerProfile" style="margin-top: 20px;">
      <!-- 소환사 정보가 여기에 표시됩니다. -->
      <div class="infoBox form-control mt-3 mb-3 d-flex align-items-center">
      	<img class="mr-3 rounded-circle me-3" src="http://ddragon.leagueoflegends.com/cdn/14.8.1/img/profileicon/${summoner.profileIconId}.png" alt="프로필 아이콘" width="64" height="64">
	<div>
	    <div class="fw-bold fs-5 mb-1">${gameName}#${tagLine}</div>
	    <div>레벨: <strong>${summoner.summonerLevel}</strong></div>
	    <div>티어: <strong>${dto.tier} ${dto.rank}</strong> (${dto.leaguePoints} LP)</div>
	    <div>판수: <strong>${dto.wins + dto.losses}</strong></div>
	    <div>승리: <strong>${dto.wins}</strong> / 패배: <strong>${dto.losses}</strong></div>
	</div>
    </div>
    <!-- 하단 테이블 (최근 경기 상세) -->
    <div class="matches-table-container">
        <h2>최근 경기 정보</h2>
		<table class="table table-striped table-hover match-table">
        <!-- <table class="match-table"> -->
            <thead>
                <tr>
                    <th>게임타입</th>
                    <th>챔피언</th>
                    <th>레벨</th>
                    <th>KDA</th>
                    <th>킬관여</th>
                    <th>아이템</th>
                    <th>CS</th>
                    <th>골드</th>
                    <th>시야</th>
                    <th>게임 시간</th>
                    <th>게임 종료</th>
                </tr>
            </thead>
			<tbody id="matchDataBody">
				<c:forEach items="${matchList}" var="match">
					<tr>
						<td>${match.queueType}</td>
						<td>
							<div class="champion-spell-container">
								<img src="${match.championIcon}" alt="${match.championName}" class="champion-icon">
								<div class="spell-rune-container">
									<div class="spell-icons">
										<img src="${match.spell1Icon}" alt="spell1" class="spell-icon">
										<img src="${match.spell2Icon}" alt="spell2" class="spell-icon">
									</div>
									<div class="rune-icons">
										<img src="${match.primaryRuneIcon}" alt="primary rune" class="primary-rune-icon">
										<img src="${match.secondaryRuneIcon}" alt="secondary rune" class="secondary-rune-icon">
									</div>
								</div>
							</div>
						</td>
						<td>${match.champLevel}</td>
						<td>${match.kills}/${match.deaths}/${match.assists}</td>
						<td><fmt:formatNumber value="${match.killParticipation}" pattern="#"/>%</td>
						<td>
							<div class="items">
								<div class="first-row">
									<c:forEach items="${match.firstRowItems}" var="item">
										<img src="${item}" alt="item" width="30" height="30">
									</c:forEach>
								</div>
								<div class="second-row">
									<c:forEach items="${match.secondRowItems}" var="item">
										<img src="${item}" alt="item" width="30" height="30">
									</c:forEach>
								</div>
							</div>
						</td>
						<td>${match.cs}</td>
						<td>${match.gold}</td>
						<td>${match.visionScore}</td>
						<td>${match.gameDuration}</td>
						<td>${match.gameEndTime}</td>
					</tr>
				</c:forEach>
			</tbody>
        </table>
    </div>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>