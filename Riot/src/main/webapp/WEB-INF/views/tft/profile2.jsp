<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%request.setAttribute("pageType", "tft");%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/TFT_Info_Styles.css">
</head>
<body>
    <div class="infoBox form-control mt-3 mb-3">
    	<h3>#1 경기 상세 정보</h3>
    	<!-- 전설이&레벨 및 시너지 -->
    	<div style="display: flex; align-items: center; flex-wrap: nowrap;">
	    	<!-- 전설이 및 레벨 -->
		    <div class="legend ml-3 mt-3" style="display: flex; align-items: center; margin-right: 20px;">
		        <figure>
		            <img src="https://ddragon.leagueoflegends.com/cdn/15.8.1/img/tft-tactician/Tooltip_TFT_Avatar_Blue.png" class="legend"/>
		            <span class="level">10</span>
		        </figure>
		    </div>
		    <!-- 시너지들 -->
		    <div class="synergy-container" style="display: flex; flex-wrap: wrap; gap: 8px;">
		        <!-- 시너지 하나 -->
		        <div style="width: 32px; text-align: center;">
		            <div style="position: relative; width: 32px; height: 32px;" class="synergy">
		                <img alt="고유특성" src="https://cdn.dak.gg/tft/images2/tft/traits/background/unique.svg" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;">
		                <img alt="영혼 살해자" src="https://ddragon.leagueoflegends.com/cdn/15.7.1/img/tft-trait/Trait_Icon_14_SoulKiller.TFT_Set14.png" style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 18px; height: 18px; filter: invert(1);">
		                <div class="tooltip">영혼 살해자 (1)</div>
		            </div>
		        </div>
		        <!-- 다른 시너지들도 같은 방식으로 -->
		       <div style="display: inline-block; width: 32px; text-align: center;">
	    			<div style="position: relative; width: 32px; height: 32px;" class="synergy">
	    				<img alt="고유특성" src="https://cdn.dak.gg/tft/images2/tft/traits/background/unique.svg" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;">
	    				<img alt="군주" src="https://ddragon.leagueoflegends.com/cdn/15.7.1/img/tft-trait/Trait_Icon_14_Overlord.TFT_Set14.png" style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 18px; height: 18px; filter: invert(1);">
	    				<div class="tooltip">군주 (1)</div>
	    			</div>
	    		</div>
		    </div>
		</div>
		
    	<!-- 유닛 및 아이템 -->
    	<div class="mt-6 mb-3 ml-2">
    		<div class="unit-container">
    			<div class="unit-box mt-3">
    				<div class="unit-star">★3</div>
    				<div class="unit">
				        <div class="unit-image" style="border-color: gold;">
				            <img alt="비에고" src="https://ddragon.leagueoflegends.com/cdn/15.7.1/img/tft-champion/TFT14_Viego.TFT_Set14.png" class="champ-img">
				        </div>
				        <div class="tooltip">비에고</div>
				    </div>
    				<div class="unit-items item">
    					<div class="item-wrapper">
    						<img alt="피바라기" src="https://ddragon.leagueoflegends.com/cdn/15.8.1/img/tft-item/TFT_Item_Bloodthirster.png">
    						<div class="tooltip">피바라기</div>
    					</div>
    					<div class="item-wrapper">
    						<img alt="정의의 손길" src="https://ddragon.leagueoflegends.com/cdn/15.8.1/img/tft-item/TFT_Item_UnstableConcoction.png">
    						<div class="tooltip">정의의 손길</div>
    					</div>
    					<div class="item-wrapper">
    						<img alt="거인의 결의" src="https://ddragon.leagueoflegends.com/cdn/15.8.1/img/tft-item/TFT_Item_TitansResolve.png">
    						<div class="tooltip">거인의 결의</div>
    					</div>
    				</div>
    			</div>
    			<div class="unit-box mt-3">
    				<div class="unit-star">★3</div>
    				<div class="unit">
	    				<div class="unit-image" style="border-color: gold;">
	    					<img alt="레넥톤" src="https://ddragon.leagueoflegends.com/cdn/15.7.1/img/tft-champion/TFT14_Renekton.TFT_Set14.png" class="champ-img">				
	    				</div>
	    				<div class="tooltip">레넥톤</div>
    				</div>
    				<div class="unit-items item">
    					<div class="item-wrapper">
    						<img alt="피바라기" src="https://ddragon.leagueoflegends.com/cdn/15.8.1/img/tft-item/TFT_Item_Bloodthirster.png">
    						<div class="tooltip">피바라기</div>
    					</div>
    					<div class="item-wrapper">
    						<img alt="정의의 손길" src="https://ddragon.leagueoflegends.com/cdn/15.8.1/img/tft-item/TFT_Item_UnstableConcoction.png">
    						<div class="tooltip">정의의 손길</div>
    					</div>
    					<div class="item-wrapper">
    						<img alt="밤의 끝자락" src="https://ddragon.leagueoflegends.com/cdn/15.8.1/img/tft-item/TFT_Item_GuardianAngel.png">
    						<div class="tooltip">밤의 끝자락</div>
    					</div>
    				</div>
    			</div>
    		</div>
   		</div>
   		
    </div>
    <button class="btn btn-outline-success btn-more">더보기</button>
</body>
</html>