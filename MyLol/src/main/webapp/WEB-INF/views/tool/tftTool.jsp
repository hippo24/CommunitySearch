<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
 <meta charset="UTF-8">
  <title>TFT 챔피언 배치 툴</title>

  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
  <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

  <style>
     body.light-theme {
      background-color: #f4f4f4;
      color: #222;
    }
    body.dark-theme {
      background-color: #121212;
      color: #e0e0e0;
    }

    #board {
      display: grid;
      grid-template-columns: repeat(7, 1fr);
      gap: 5px;
      width: 100%;
      max-width: 700px;
      margin: auto;
    }

    .cell {
      width: 100px;
      height: 100px;
      background-color: white;
      border: 1px solid gainsboro;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    body.light-theme .cell {
      background-color: #ffffff;
      border: 1px solid #ccc;
    }

    body.dark-theme .cell {
      background-color: #1e1e1e;
      border: 1px solid #333;
    }

    .champion {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }

    .champion-pool {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(60px, 1fr));
      padding: 10px;
      justify-content: center;
      max-width: 700px;
      max-height: 300px;
      overflow-y: auto;
      margin: 0 auto 20px;
    }

    .champion-pool img {
      width: 60px;
      height: 60px;
      cursor: grab;
      border: 2px solid gray;
      border-radius: 5px;
      transition: transform 0.2s;
    }

    .champion-pool img:hover {
      transform: scale(1.1);
    }

    body.light-theme .champion-pool img {
      border: 2px solid #aaa;
    }

    body.dark-theme .champion-pool img {
      border: 2px solid #444;
    }

    .champion-pool img:hover::after {
      content: attr(name);
      position: absolute;
      background: #333;
      color: #fff;
      padding: 2px 6px;
      font-size: 12px;
      border-radius: 4px;
      top: -25px;
      left: 0;
      white-space: nowrap;
    }

    #clear-btn {
      position: fixed;
      bottom: 30px;
      right: 30px;
      z-index: 999;
      padding: 12px 20px;
      border-radius: 999px;
      box-shadow: 0 4px 8px black;
    }

    #synergy-box {
      position: fixed;
      top: 100px;
      left: 30px;
      width: 200px;
      background-color: #1e1e1e;
      color: white;
      border-radius: 10px;
      box-shadow: 0 0 10px black;
      z-index: 900;
    }
    body.light-theme #synergy-box {
      background-color: #fff;
      color: black;
      border: 1px solid #ccc;
    }
    #champ-tooltip{
      display:none; position:absolute; 
      z-index:1000; background:#222; color:white; 
      padding:8px; border-radius:8px; font-size:14px; max-width:200px; 
      box-shadow:0 0 10px black;
    }
    .synergy-list{
      margin-top: 10px;
    }
    #synergy-header{
      cursor: move; display: flex; justify-content: space-between; align-items: center;
    }
  </style>
</head>
<body class="p-4 dark-theme">
  <div class="container">
    <h1 class="text-center mb-4">TFT 챔피언 배치</h1>

    <div class="text-center mb-3">
      <button id="toggle-theme" class="btn btn-info">라이트 테마</button>
    </div>

    <div id="board"></div>

    <button class="btn btn-danger my-3" onclick="clearBoard()" id="clear-btn">클리어</button>

    <div class="champion-pool" id="champion-pool">
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
    // JavaScript 코드: 기존 HTML과 동일하게 유지
    // 단, fetch("14unit_data.json") → context path 주의 필요
    // 예: fetch("${pageContext.request.contextPath}/static/14unit_data.json")
    
    
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
      document.getElementById("champ-name").innerText = `${champ.name} (코스트: ${champ.cost})`;
      document.getElementById("champ-traits").innerHTML = `<li>특성: ${champ.traits.join(", ")}</li>`;
    }

    // 보드
    for (let i = 0; i < 28; i++) {
      const cell = document.createElement("div");
      cell.classList.add("cell");
      cell.dataset.index = i;
      board.appendChild(cell);

      // 드래그 앤 드롭
      cell.addEventListener("dragover", e => e.preventDefault());

      cell.addEventListener("drop", () => {
        if (!dragged) return;
        const srcImg = document.getElementById(dragged);
        const champImg = document.createElement("img");
        champImg.src = srcImg.src;
        champImg.classList.add("champion");
        

        // 우클릭 삭제
        champImg.addEventListener("contextmenu", e => {
          e.preventDefault();
          cell.innerHTML = "";
          synergy();
        });

        champImg.alt = srcImg.alt;
        champImg.setAttribute("name", srcImg.name);

        // 클릭 시 정보 출력
        champImg.addEventListener("click", () => {
          const original = Object.values(championData).find(c => c.name === champImg.getAttribute("name"));
          if (original) {
            showChampionInfo(original);
          }
        });
        //마우스 올릴 때
        champImg.addEventListener("mouseover", (e) => {
          const champ = Object.values(championData).find(c => c.name === champImg.getAttribute("name"));
          if (!champ) return;

          const tooltip = document.getElementById("champ-tooltip");
          tooltip.style.display = "block";
          tooltip.innerHTML = `
            <strong>${champ.name}</strong><br>
            코스트: ${champ.cost}<br>
            특성: ${champ.traits.join(", ")}
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
        dragged = null;
        synergy();

      });
    }

  


    // json으로부터 챔피언 데이터 가져오기
    fetch("/lolsts/resources/14unit_data.json")
      .then(response => response.json())
      .then(data => {
        data.forEach((champ, index) => {
          championData[champ.id] = champ;

          const champImg = document.createElement("img");
          champImg.src = champ.image;
          champImg.alt = champ.name;
          champImg.name = champ.name;
          champImg.id = `champ${index + 1}`;
          champImg.draggable = true;
          champImg.classList.add("champion");

          champImg.addEventListener("dragstart", e => {
            dragged = e.target.id;
          });

          champImg.addEventListener("click", () => {
            showChampionInfo(champ);
          });

          
          champImg.addEventListener("mouseover", (e) => {
            const tooltip = document.getElementById("champ-tooltip");
            tooltip.style.display = "block";
            tooltip.innerHTML = `
              <strong>${champ.name}</strong><br>
              코스트: ${champ.cost}<br>
              특성: ${champ.traits.join(", ")}
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

          champPool.appendChild(champImg);


        });
      });

    //클리어버튼
    function clearBoard() {
      document.querySelectorAll(".cell").forEach(cell => {
        cell.innerHTML = "";
      });
      synergy();
    }

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
          champCount[trait] = (champCount[trait] || 0) + 1;
        });
      });

  
      Object.entries(champCount)
        .sort((a, b) => b[1] - a[1]) 
        .sort()
        .forEach(([trait, count]) => {
          const li = document.createElement("li");

          const name = document.createElement("div");
          name.textContent = `${trait} ${count}`;
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



    // 다크/라이트 테마 토글버튼
    toggleBtn.addEventListener("click", () => {
      const darktheme = body.classList.contains("dark-theme");
      body.classList.toggle("dark-theme", !darktheme);
      body.classList.toggle("light-theme", darktheme);
      toggleBtn.textContent = darktheme ? "다크 테마" : "라이트 테마";
      toggleBtn.className = darktheme ? "btn btn-dark" : "btn btn-info";
    });

    //시너지창 접기
    const synergyToggle = document.getElementById("toggle-synergy");
    const synergyList = document.getElementById("synergy-list");

    synergyToggle.addEventListener("click", () => {
      const display = synergyList.style.display !== "none";
      synergyList.style.display = display ? "none" : "block";
      synergyToggle.textContent = display ? "+" : "-";
    });

    //시너지창 이동
    const synergyBox = document.getElementById("synergy-box");
    const synergyHeader = document.getElementById("synergy-header");
    let isDragging = false, offsetX = 0, offsetY = 0;

    synergyHeader.addEventListener("mousedown", (e) => {
      isDragging = true;
      offsetX = e.clientX - synergyBox.getBoundingClientRect().left;
      offsetY = e.clientY - synergyBox.getBoundingClientRect().top;
      synergyBox.style.position = "absolute";
    });

    document.addEventListener("mousemove", (e) => {
      if (!isDragging) return;
      synergyBox.style.left = `${e.clientX - offsetX}px`;
      synergyBox.style.top = `${e.clientY - offsetY}px`;
    });

    document.addEventListener("mouseup", () => {
      isDragging = false;
    });


  </script>

</body>
</html>