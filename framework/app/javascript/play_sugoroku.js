// 現在の手番のプレイヤーID（例）
let currentDisplayPlayer = 'player-1-piece'; 

const square_cols = 7;
const sqare_size = 130;
const dice_size = 40;

console.log('play_sugoroku.js loaded');

document.addEventListener('turbo:load', () => {
  console.log('turbo:load in play_sugoroku');
});

document.addEventListener('map:rendered', () => {
  console.log('map:rendered received');
});


function setInitialPositions() {
    console.log("コマの初期化");

    // 1. スタートマス（1マス目）の要素を取得
    //const startSquare = document.getElementById('square-1');
    //if (!startSquare) return;

    // 2. スタートマスの座標（CSSの left と top）を取得
    const startX = 60
    const startY = 0

    // 3. ループ処理で、すべてのプレイヤーのコマをその場所に配置する
    //（例として最大4人分を想定して回す、または @player_count の数に合わせる）
    for (let i = 1; i <= window.player_count; i++) {
      console.log("for文の中身");
      const piece = document.getElementById(`player-${i}-piece`);
      
      if (piece) {
        piece.style.left = startX + 'px';
        piece.style.top = startY + 'px';
        piece.style.backgroundColor = window.player_colors[i-1];
        console.log("player" + i + "のコマ");
        
        // 💡 応用：全員が完全に重なると見づらいので、少しだけ位置をズラす（微調整）
        // 2人目は右に10px、3人目は下に10px... のようにずらすと全員が見やすくなります
        if (i === 2) piece.style.left = (startX + dice_size + 15) + 'px';
        if (i === 3) piece.style.top = (startY + dice_size + 15) + 'px';
        if (i === 4) {
          piece.style.left = (startX + dice_size + 15) + 'px';
          piece.style.top = (startY + dice_size + 15) + 'px';
        }
      }
    }
}

/**
 * 1. ターン開始時の演出
 * 一瞬全体を引き（等倍）、そのあと自分のコマに自動ズームする
 */
function startTurn(playerId) {
  currentDisplayPlayer = playerId;
  
  // まずは等倍(1.0)に戻して全体マップを見せる（中心をなんとなく中央に）
  // 画面中央（screenWidth/2, screenHeight/2）付近にマップが来るようにリセット
  const camera = document.getElementById('map-camera');
  camera.style.transform = `translate(0px, 0px) scale(1.0)`;
  
  // 1.5秒（1500ミリ秒）全体を見せた後、自分のコマにググッとズームインする
  setTimeout(() => {
    focusOnPlayer(currentDisplayPlayer, 1.8); // 1.8倍にズーム
    
    // ズームが終わった頃（約0.5秒後）にサイコロボタンを活性化させるなどの処理
    setTimeout(() => {
      alert("サイコロを振ってください！");
    }, 500);
  }, 1500);
}

/**
 * 2. サイコロの目が出て、コマが動くときの処理
 * コマの移動アニメーションに合わせて、カメラも毎フレーム（またはコマの動きと同時に）追従させる
 */
function movePlayerAndFollow(playerId, targetSquaresArray) {
  let step = 0;

  function moveToNextSquare() {
    if (step >= targetSquaresArray.length) {
      // ➔ 4. 目的のマスに到着したら、全体のマップに戻る
      setTimeout(() => {
        const camera = document.getElementById('map-camera');
        camera.style.transform = `translate(0px, 0px) scale(1.0)`; // 全体に戻す
        alert("ターン終了！");
      }, 800);
      return;
    }

    // 次のマスの情報を取得（例: ['square-3', 'square-4', 'square-5'] みたいな配列を想定）
    const nextSquareId = targetSquaresArray[step];
    const nextSquare = document.getElementById(nextSquareId);
    const piece = document.getElementById(playerId);

    // コマを次のマスへ移動させる（CSSの left/top を書き換える）
    piece.style.left = nextSquare.style.left;
    piece.style.top = nextSquare.style.top;

    // 💡【ここがポイント】コマが動くのと「同時」に、カメラもその新しい位置を追いかける！
    // ズーム倍率は維持（1.8倍）したまま、新しい座標へ追従
    setTimeout(() => {
      focusOnPlayer(playerId, 1.8);
    }, 50); // コマの動き出しとほぼ同時にカメラも動かす

    step++;
    
    // 1マス進むごとに0.6秒のウェイトを置いて、トコトコ歩いている感を出す
    setTimeout(moveToNextSquare, 600);
  }

  // ループ（歩行処理）を開始
  moveToNextSquare();
}

document.addEventListener('turbo:load', () => {
  console.log('setInitialPositions');
  //renderMap();
  setInitialPositions();
  
});

// まとめたファイルの一番下（イベント周辺）

// function executeGameInit() {
//   console.log("=== すごろく初期化処理スタート ===");
  
//   // 1. 最新のマップ要素があるか確認
//   const mapEl = document.getElementById("map");
//   if (!mapEl) {
//     console.log("このページには #map が存在しないため処理をスキップします");
//     return;
//   }

//   // 2. マップを描画（この中で #square-1 が作られる）
//   renderMap();

//   // 3. 💡 描画直後、ブラウザがHTMLを認識する時間を「1ミリ秒」だけ作ってからコマを置く
//   setTimeout(() => {
//     console.log("コマの配置を開始します");
//     setInitialPositions();
//   }, 1);
// }

// // 💡 Turboのタイミングを「一番確実なタイミング」に指定する
// document.addEventListener('turbo:load', executeGameInit);