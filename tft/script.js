// script.js


const board = document.getElementById("board");

for (let i = 0; i < 28; i++) {
  const cell = document.createElement("div");
  cell.classList.add("cell");
  cell.dataset.index = i; //인덱스
  board.appendChild(cell);
}


// 드래그 당하는 챔피언
let draggedChampionId = null;

// 챔피언 드래그
document.querySelectorAll(".champion").forEach(champ => {
  champ.addEventListener("dragstart", (e) => {
    draggedChampionId = e.target.id;
  });
});

// 보드 칸 드롭 이벤트
document.querySelectorAll(".cell").forEach(cell => {
  cell.addEventListener("dragover", (e) => {
    e.preventDefault(); // 드롭 허용
  });

  cell.addEventListener("drop", (e) => {
    if (!draggedChampionId) return;

    // 드래그된 챔피언 복제해서 넣기
    const champImg = document.createElement("img");
    champImg.src = document.getElementById(draggedChampionId).src;
    champImg.classList.add("champion");
    champImg.style.width = "100%";
    champImg.style.height = "100%";

    // 기존 챔피언 있으면 제거
    cell.innerHTML = "";
    cell.appendChild(champImg);

    draggedChampionId = null;

    
  });

  function drop(event) {
  event.preventDefault();
  const data = event.dataTransfer.getData("text/plain");
  const draggedImage = document.getElementById(data);

  // 복사본 생성
  const newImage = draggedImage.cloneNode(true);
  newImage.removeAttribute("id"); // id 중복 방지
  newImage.classList.add("placed"); 

  // 삭제 이벤트
  newImage.addEventListener("click", () => {
    newImage.remove();
  });

  event.target.appendChild(newImage);
}

});
