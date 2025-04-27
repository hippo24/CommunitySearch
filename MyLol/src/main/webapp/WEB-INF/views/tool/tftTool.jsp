<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<title>TFT 챔피언 배치 툴</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/TFT_Tool.css">
	
</head>
<body class="dark-theme">

	<!-- 배치툴용 헤더 따로 작성 -->

	<div class="container mt-5">
		<h1 class="text-center mb-4">TFT 챔피언 배치</h1>

		<div class="text-center mb-3">
			<button id="toggle-theme" class="btn btn-info">라이트 테마</button>
		</div>

		<div id="board"></div>

		<button class="btn btn-danger my-3" onclick="clearBoard()"
			id="clear-btn">클리어</button>

		<div class="champion-pool mt-7" id="champion-pool">
			<!-- 여기에 챔피언들 -->

		</div>

	</div>

	<div id="synergy-box" class="p-3">
		<div id="synergy-header">
			<h5>챔피언 시너지</h5>
			<button id="toggle-synergy" class="btn btn-sm btn-outline-danger">−</button>
		</div>
		<ul id="synergy-list"></ul>
	</div>

	<div class="text-center mt-3">
		<h3 id="champ-name">챔피언</h3>
		<ul id="champ-traits"></ul>
	</div>

	<div id="champ-tooltip"></div>

	<script>
    const board = document.getElementById("board");
    const champPool = document.getElementById("champion-pool");
    const toggleBtn = document.getElementById("toggle-theme");
    const body = document.body;
    let dragged = null;
    let championData = {};
	

    const synergyData = {
       //시너지 설명을 어떻게 할까...

    }

    // 챔피언 정보 함수
    function showChampionInfo(champ) {
    	document.getElementById("champ-name").innerText = `\${champ.name} (코스트: \${champ.cost})`;
    	document.getElementById("champ-traits").innerHTML = `<il style="list-style: none;">\${champ.traits.join(", ")}</li>`;
	}

	// 보드
    for (let i = 0; i < 28; i++) {
    	  const cell = document.createElement("div");
    	  cell.classList.add("cell");
    	  cell.dataset.index = i;

    	  const row = Math.floor(i / 7);
    	  cell.dataset.row = row;

    	  board.appendChild(cell);
    	  
    	  // 드래그 앤 드롭
    	  cell.addEventListener("dragover", e => e.preventDefault());

    	  cell.addEventListener("drop", (e) => {
    	    e.preventDefault();

    	    const champId = e.dataTransfer.getData("text/plain"); // 챔피언 ID 받아옴
    	    const champ = championData[champId];
    	    if (!champ) return;

    	    const champImg = document.createElement("img");
    	    champImg.src = champ.image;
    	    champImg.alt = champ.name;
    	    champImg.setAttribute("name", champ.name);
    	    champImg.classList.add("champion");

    	    // 우클릭 삭제
    	    champImg.addEventListener("contextmenu", e => {
    	      e.preventDefault();
    	      cell.innerHTML = "";
    	      synergy();
    	    });

    	    // 클릭 시 정보 출력
    	    champImg.addEventListener("click", () => {
    	      showChampionInfo(champ);
    	    });

    	    // 마우스 오버 툴팁
    	    champImg.addEventListener("mouseover", (e) => {
    	      const tooltip = document.getElementById("champ-tooltip");
    	      tooltip.style.display = "block";
    	      tooltip.innerHTML = `
    	        <strong>\${champ.name}</strong><br>
    	        코스트: \${champ.cost}<br>
    	        특성: \${champ.traits.join(", ")}
    	      `;
    	    });

    	    champImg.addEventListener("mousemove", (e) => {
    	      const tooltip = document.getElementById("champ-tooltip");
    	      tooltip.style.left = e.pageX + 15 + "px";
    	      tooltip.style.top = e.pageY + 15 + "px";
    	    });

    	    champImg.addEventListener("mouseleave", () => {
    	      document.getElementById("champ-tooltip").style.display = "none";
    	    });

    	    cell.innerHTML = "";
    	    cell.appendChild(champImg);
    	    synergy();
    	  });
    	}

    // json으로부터 챔피언 데이터 가져오기
    Promise.all([
	  fetch("/riot/resources/14unit_data.json").then(res => res.json()),
	  fetch("/riot/resources/14trait_data.json").then(res => res.json())
	])
    .then(([unitData, traitData]) => {
    	console.log(unitData);
    	console.log(traitData);
    	
    	unitData.forEach((champ, index) => {
          championData[champ.id] = champ;
		  
          //유닛 이미지 설정
          const champImg = document.createElement("img");
          champImg.src = champ.image;
          champImg.alt = champ.name;
          champImg.name = champ.name;
          champImg.id = `champ${index + 1}`;
          champImg.draggable = true;
          champImg.dataset.champid = champ.id;
          champImg.classList.add("champion");
		
          champPool.addEventListener("dragstart", e => {
	       	if (e.target && e.target.classList.contains("champion")) {
	       	  const champId = e.target.dataset.champid;
	       	  e.dataTransfer.setData("text/plain", champId);
	       	}
	      });
          champImg.addEventListener("click", () => {
            showChampionInfo(champ);
          });

          //챔피언 목록에서 유닛 이미지에 마우스를 올릴 경우
          champImg.addEventListener("mouseover", function (e) {
        	  const tooltip = document.getElementById("champ-tooltip");
        	  tooltip.style.display = "block";

        	  const traits = Array.isArray(champ.traits) ? champ.traits.join(", ") : "정보 없음";

        	  tooltip.innerHTML = `
        	    <strong>\${champ.name}</strong><br>
        	    코스트: \${champ.cost}<br>
        	    특성: \${traits}
        	  `;
          });
		  //마우스 잘 따라다니면서 보여주기
          champImg.addEventListener("mousemove", (e) => {
            const tooltip = document.getElementById("champ-tooltip");
            tooltip.style.left = e.pageX + 15 + "px";
            tooltip.style.top = e.pageY + 15 + "px";
          });
		  
		  // 마우스가 유닛 이미지에서 벗어나면
          champImg.addEventListener("mouseleave", () => {
            document.getElementById("champ-tooltip").style.display = "none";
          });
          $("#champion-pool").append(champImg);
        });
      },
      error: function() {
        alert("챔피언 데이터를 불러오는 데 실패했습니다.");
      }
    });

    //클리어버튼
    function clearBoard() {
      document.querySelectorAll(".cell").forEach(cell => {
        cell.innerHTML = "";
      });
      synergy();
    }
    
	//시너지 활성 등급 계산 함수
    function getActiveStyle(traitData, unitCount) {
  	  if (!traitData || !traitData.tiers) return 0;
  	  const activeTier = traitData.tiers
  	    .filter(tier => unitCount >= tier.minUnits)
  	    .sort((a, b) => b.tier - a.tier)[0];
  	  return activeTier ? activeTier.style : 0;
  	}
	// 시너지 아이콘과 등급(스타일)별 배경 이미지 매핑 준비
   	const styleBgMap = {
	  1: "https://cdn.dak.gg/tft/images2/tft/traits/background/bronze.svg",
	  2: "https://cdn.dak.gg/tft/images2/tft/traits/background/silver.svg",
	  3: "https://cdn.dak.gg/tft/images2/tft/traits/background/unique.svg",
	  4: "https://cdn.dak.gg/tft/images2/tft/traits/background/gold.svg",
	  5: "https://cdn.dak.gg/tft/images2/tft/traits/background/chromatic.svg"
	};
    
    //시너지 계산
    function synergy() {
    	
      const synergyList = document.getElementById("synergy-list");
      synergyList.innerHTML = "";

      const champs = new Set();
      const champCount = {};

      // 올라간 챔피언 등록
      document.querySelectorAll(".cell").forEach(cell => {
        const champImg = cell.querySelector("img");
        if (!champImg) return;
        const champName = champImg.getAttribute("name");
        if (champs.has(champName)) return; // 중복 체크
        champs.add(champName);

        const champ = Object.values(championData).find(c => c.name === champName);
        if (!champ) return;
        champ.traits.forEach(trait => {
          synergyCount[trait] = (synergyCount[trait] || 0) + 1;
        });
      });

  
      Object.entries(champCount)
        .sort((a, b) => b[1] - a[1]) 
        .sort()
        .forEach(([trait, count]) => {
          const li = document.createElement("li");

          const name = document.createElement("div");
          name.textContent = `\${trait} \${count}`;
          name.style.fontWeight = "bold";

          const desc = document.createElement("div");
          desc.textContent = synergyData[trait]?.description || "";
          desc.style.fontSize = "12px";
          desc.style.opacity = "0.75";
          desc.style.marginLeft = "5px";

          li.appendChild(name);
          li.appendChild(desc);
          synergyList.appendChild(li);
        });
    }

    $("#clear-btn").click(() => {
      $(".cell").html("");
      synergy();
    });

    toggleBtn.addEventListener("click", () => {
      const dark = body.classList.toggle("dark-theme");
      body.classList.toggle("light-theme", !dark);
      toggleBtn.textContent = dark ? "라이트 테마" : "다크 테마";
      toggleBtn.className = dark ? "btn btn-info" : "btn btn-dark";
    });

    const synergyToggle = document.getElementById("toggle-synergy");
    const synergyList = document.getElementById("synergy-list");
    const synergyBox = document.getElementById("synergy-box");
    const synergyHeader = document.getElementById("synergy-header");
    let isDragging = false;
    let offsetX = 0;
    let offsetY = 0;

    // 시너지창 접기/펼치기 토글
    synergyToggle.addEventListener("click", () => {
      const isVisible = synergyList.style.display !== "none" && synergyList.style.display !== "";
      synergyList.style.display = isVisible ? "none" : "block";
      synergyToggle.textContent = isVisible ? "+" : "-";
    });

    // 시너지창 드래그 시작
    synergyHeader.addEventListener("mousedown", (e) => {
      e.preventDefault(); // 드래그 중 텍스트 선택 방지
      isDragging = true;

      // synergyBox 위치 기준과 마우스 위치 차이 계산
      const rect = synergyBox.getBoundingClientRect();
      offsetX = e.clientX - rect.left;
      offsetY = e.clientY - rect.top;

      // position 고정 (fixed 또는 absolute 중 선택)
      synergyBox.style.position = "fixed";

      // 드래그 중에도 부드러운 이동을 위해 pointer-events 설정(필요 시)
    });

    // 드래그 중 이동
    document.addEventListener("mousemove", (e) => {
      if (!isDragging) return;

      // 화면 밖으로 나가지 않도록 최소값 설정 (선택사항)
      let left = e.clientX - offsetX;
      let top = e.clientY - offsetY;

      // 예시: 화면 내로 제한 (옵션)
      const maxLeft = window.innerWidth - synergyBox.offsetWidth;
      const maxTop = window.innerHeight - synergyBox.offsetHeight;
      left = Math.min(Math.max(0, left), maxLeft);
      top = Math.min(Math.max(0, top), maxTop);

      synergyBox.style.left = `\${left}px`;
      synergyBox.style.top = `\${top}px`;
    });

    // 드래그 종료
    document.addEventListener("mouseup", () => {
    	isDragging = false;
    });


  </script>
</body>
</html>
