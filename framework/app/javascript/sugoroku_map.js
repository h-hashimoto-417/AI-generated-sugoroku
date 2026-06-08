//const svg = document.getElementById("lines");

function renderMap() {  
  const cols = 7;
  const x_distance = 150; // ！！親(board)のウィンドウサイズを求めてcolで割ればいいのでは！！
  const y_distance = 150;
  const square_size = 80
  const map = document.getElementById("map");
  const svg = document.getElementById("lines");
  const squares = sugoroku.squares;

  // 画面遷移した時に、前のデータや描画が残らないように中身を綺麗にリセットする
  map.innerHTML = '';
  svg.innerHTML = '';

  const positions = [];

  console.log("squaresの表示");

  // --- マス生成 ---
  squares.forEach((square, index) => {
    const row = Math.floor(index / cols);
    const colInRow = index % cols;
    //console.log("index: %d, row: %d, colInRow: %d", index, row, colInRow);

    const col = row % 2 === 0
      ? colInRow
      : (cols - 1 - colInRow);

    const x = col * x_distance;
    const y = row * y_distance;

    // 線の始点と終点になる
    positions.push({ x: x + square_size / 2, y: y + square_size / 2 }); // 中心点

    const container = document.createElement("div");
    container.className = "square-container";

    container.style.left = `${x}px`;
    container.style.top = `${y}px`;

    let squareClass;
    let square_text;

    switch (square.type) {
    case "start":
        squareClass = "square start-goal";
        square_text = "START";
        break;
    case "goal":
        squareClass = "square start-goal";
        square_text = "GOAL";
        break;
    case "event":
        squareClass = "square event";
        switch (square.effect) {
          case "skip": square_text = "🚫"; break;
          case "roll_again": square_text = "🔄"; break;
          case "move": square_text = square.value < 0 ? "↩️" : "⏩️"; break;
          default: square_text = "";
        }
        break;
    default:
        squareClass = "square normal";
        square_text = "";
    }

    // div.title = square.text;

    container.innerHTML = `
    <div class="${squareClass}">
        <p>${square_text}</p>
    </div>

    <div class="tooltip">
        ${square.text}
    </div>
    `;

    map.appendChild(container);

    
  });

  // --- マス同士を接続 ---
  for (let i = 0; i < positions.length - 1; i++) {
    drawLine(
      svg,
      positions[i].x,
      positions[i].y,
      positions[i + 1].x,
      positions[i + 1].y
    );
  }

  document.dispatchEvent(new CustomEvent('map:rendered'));
}

// --- 線描画関数 ---
function drawLine(svg, x1, y1, x2, y2) {
  const line = document.createElementNS("http://www.w3.org/2000/svg", "line");

  line.setAttribute("x1", x1);
  line.setAttribute("y1", y1);
  line.setAttribute("x2", x2);
  line.setAttribute("y2", y2);

  line.setAttribute("stroke", "#dac9a8");
  line.setAttribute("stroke-width", "20");

  svg.appendChild(line);
}

document.addEventListener('turbo:load', () => {
  console.log('renderMap');
  renderMap();
});

document.addEventListener('map:rendered', () => {
  console.log('map rendered');
});
