document.addEventListener("DOMContentLoaded", () => {
  const cols = 7;
  const size = 130;

  const map = document.getElementById("map");
  const svg = document.getElementById("lines");

  const squares = sugoroku.squares;

  const positions = [];

  console.log("squaresの表示");

  // --- マス生成 ---
  squares.forEach((square, index) => {
    const row = Math.floor(index / cols);
    const colInRow = index % cols;
    console.log("index: %d, row: %d, colInRow: %d", index, row, colInRow);

    const col = row % 2 === 0
      ? colInRow
      : (cols - 1 - colInRow);

    const x = col * size;
    const y = row * size;

    positions.push({ x: x + 50, y: y + 40 }); // 中心点

    const container = document.createElement("div");
    container.className = "square-container";

    container.style.left = `${x}px`;
    container.style.top = `${y}px`;

    let squareClass;

    switch (square.type) {
    case "start":
    case "goal":
        squareClass = "square-start-goal";
        break;
    case "event":
        squareClass = "square-event";
        break;
    default:
        squareClass = "square-normal";
    }

    // div.title = square.text;

    container.innerHTML = `
    <div class="${squareClass}">
        <span class="square-label">${index + 1}</span>
    </div>

    <div class="tooltip">
        ${square.text}
    </div>
    `;

    map.appendChild(container);

    
  });

  // --- 線描画関数 ---
  function drawLine(x1, y1, x2, y2) {
    const line = document.createElementNS("http://www.w3.org/2000/svg", "line");

    line.setAttribute("x1", x1);
    line.setAttribute("y1", y1);
    line.setAttribute("x2", x2);
    line.setAttribute("y2", y2);

    line.setAttribute("stroke", "#dac9a8");
    line.setAttribute("stroke-width", "16");

    svg.appendChild(line);
  }

  // --- マス同士を接続 ---
  for (let i = 0; i < positions.length - 1; i++) {
    drawLine(
      positions[i].x,
      positions[i].y,
      positions[i + 1].x,
      positions[i + 1].y
    );
  }
});