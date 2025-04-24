<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>TFT 챔피언 배치 툴</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
  <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
  <style>
    body.light-theme { background-color: #f4f4f4; color: #222; }
    body.dark-theme { background-color: #121212; color: #e0e0e0; }
    #board { display: grid; grid-template-columns: repeat(7, 1fr); gap: 5px; max-width: 700px; margin: auto; }
    .cell { width: 100px; height: 100px; display: flex; align-items: center; justify-content: center; }
    body.light-theme .cell { background-color: #ffffff; border: 1px solid #ccc; }
    body.dark-theme .cell { background-color: #1e1e1e; border: 1px solid #333; }
    .champion-pool { display: grid; grid-template-columns: repeat(auto-fill, minmax(60px, 1fr)); max-width: 700px; margin: auto; overflow-y: auto; padding: 10px; }
    .champion-pool img { width: 60px; height: 60px; border: 2px solid gray; border-radius: 5px; cursor: grab; transition: transform 0.2s; }
    .champion-pool img:hover { transform: scale(1.1); }
    #clear-btn { position: fixed; bottom: 30px; right: 30px; z-index: 999; }
    #synergy-box { position: fixed; top: 100px; left: 30px; z-index: 900; border-radius: 10px; box-shadow: 0 0 10px black; padding: 1rem; }
    body.light-theme #synergy-box { background: #fff; color: #000; border: 1px solid #ccc; }
    body.dark-theme #synergy-box { background: #1e1e1e; color: #fff; }
    #champ-tooltip { display:none; position:absolute; z-index:1000; background:#222; color:white; padding:8px; border-radius:8px; font-size:14px; max-width:200px; box-shadow:0 0 10px black; }
  </style>
</head>
<body class="p-4 dark-theme">
  <div class="container">
    <h1 class="text-center mb-4">TFT 챔피언 배치</h1>
    <div class="text-center mb-3"><button id="toggle-theme" class="btn btn-info">라이트 테마</button></div>
    <div id="board"></div>
    <button id="clear-btn" class="btn btn-danger">클리어</button>
    <div class="champion-pool" id="champion-pool"></div>
  </div>
  <div id="synergy-box">
    <div id="synergy-header" style="cursor: move; display:flex; justify-content:space-between; align-items:center;">
      <h5>챔피언 시너지</h5>
      <button id="toggle-synergy" class="btn btn-sm btn-outline-danger">−</button>
    </div>
    <ul id="synergy-list"></ul>
  </div>
  <div class="text-center mt-3">
    <h3 id="champ-name">챔피언 정보</h3>
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

    function showChampionInfo(champ) {
      $("#champ-name").text(`${champ.name} (코스트: ${champ.cost})`);
      $("#champ-traits").html(`<li>특성: ${champ.traits.join(", ")}</li>`);
    }

    for (let i = 0; i < 28; i++) {
      const cell = document.createElement("div");
      cell.classList.add("cell");
      board.appendChild(cell);
      cell.addEventListener("dragover", e => e.preventDefault());
      cell.addEventListener("drop", () => {
        if (!dragged) return;
        const srcImg = document.getElementById(dragged);
        const champImg = document.createElement("img");
        champImg.src = srcImg.src;
        champImg.classList.add("champion");
        champImg.alt = srcImg.alt;
        champImg.setAttribute("name", srcImg.name);
        champImg.addEventListener("contextmenu", e => { e.preventDefault(); cell.innerHTML = ""; synergy(); });
        champImg.addEventListener("click", () => { const champ = championData[srcImg.alt]; if (champ) showChampionInfo(champ); });
        champImg.addEventListener("mouseover", e => {
          const champ = championData[srcImg.alt];
          if (!champ) return;
          $("#champ-tooltip").show().html(`
            <strong>${champ.name}</strong><br>
            코스트: ${champ.cost}<br>
            특성: ${champ.traits.join(", ")}`);
        });
        champImg.addEventListener("mousemove", e => {
          $("#champ-tooltip").css({ left: e.pageX + 15, top: e.pageY + 15 });
        });
        champImg.addEventListener("mouseleave", () => {
          $("#champ-tooltip").hide();
        });
        cell.innerHTML = "";
        cell.appendChild(champImg);
        synergy();
      });
    }

    $.ajax({
      url: '<c:url value="/resources/json/14unit_data.json"/>',
      type: 'GET',
      dataType: 'json',
      success: function(data) {
        data.forEach((champ, index) => {
          championData[champ.name] = champ;
          const champImg = $("<img>", {
            src: champ.image,
            alt: champ.name,
            id: `champ${index + 1}`,
            name: champ.name,
            draggable: true,
            class: "champion"
          });
          champImg.on("dragstart", e => { dragged = e.target.id; });
          champImg.on("click", () => { showChampionInfo(champ); });
          champImg.on("mouseover", e => {
            $("#champ-tooltip").show().html(`
              <strong>${champ.name}</strong><br>
              코스트: ${champ.cost}<br>
              특성: ${champ.traits.join(", ")}`);
          });
          champImg.on("mousemove", e => {
            $("#champ-tooltip").css({ left: e.pageX + 15, top: e.pageY + 15 });
          });
          champImg.on("mouseleave", () => {
            $("#champ-tooltip").hide();
          });
          $("#champion-pool").append(champImg);
        });
      },
      error: function() {
        alert("챔피언 데이터를 불러오는 데 실패했습니다.");
      }
    });

    function synergy() {
      const synergyCount = {};
      $("#synergy-list").empty();
      $(".cell img").each(function() {
        const champ = championData[$(this).attr("alt")];
        if (!champ) return;
        champ.traits.forEach(trait => {
          synergyCount[trait] = (synergyCount[trait] || 0) + 1;
        });
      });
      Object.entries(synergyCount).sort((a, b) => b[1] - a[1]).forEach(([trait, count]) => {
        $("#synergy-list").append(`<li><strong>${trait} (${count})</strong></li>`);
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

    $("#toggle-synergy").click(() => {
      const box = $("#synergy-list");
      box.toggle();
      $("#toggle-synergy").text(box.is(":visible") ? "−" : "+");
    });

    let dragging = false, offsetX = 0, offsetY = 0;
    $("#synergy-header").mousedown(e => {
      dragging = true;
      offsetX = e.offsetX;
      offsetY = e.offsetY;
    });
    $(document).mousemove(e => {
      if (!dragging) return;
      $("#synergy-box").css({ left: e.clientX - offsetX, top: e.clientY - offsetY });
    }).mouseup(() => { dragging = false; });
  </script>
</body>
</html>
