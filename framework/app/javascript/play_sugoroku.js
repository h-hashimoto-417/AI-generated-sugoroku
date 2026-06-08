// 現在の手番のプレイヤーID（例）
let currentDisplayPlayer = 'player-1-piece'; 

const square_cols = 7;
const x_distance = 150;
const y_distance = 150;
const square_size = 80
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

    // スタートマスの座標を取得
    const startX = 60
    const startY = 0

    // ループ処理で、すべてのプレイヤーのコマをその場所に配置する
    for (let i = 1; i <= window.player_count; i++) {
      //console.log("for文の中身");
        const piece = document.getElementById(`player-${i}-piece`);
        
        if (piece) {
            piece.style.left = startX + 'px';
            piece.style.top = startY + 'px';
            piece.style.backgroundColor = window.player_colors[i-1];
            //console.log("player" + i + "のコマ");
            
            // 全員が完全に重なると見づらいので、少しだけ位置をズラす（微調整）
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
 * ターン開始時の演出
 * 一瞬全体を引き（等倍）、そのあと自分のコマに自動ズームする
 */
function startTurn(crr_turn, playerId, square_index) {    
    // まずは等倍(1.0)に戻して全体マップを見せる（中心をなんとなく中央に）
    // 画面中央（screenWidth/2, screenHeight/2）付近にマップが来るようにリセット
    const camera = document.getElementById('map-camera');
    const diceButton = document.getElementById("dice");
    const turnNotice = document.getElementById("turn-notice");
    const turnNum = document.getElementById("turn-num-in-notice");
    const playerName = document.getElementById("playername-in-notice");

    camera.style.transform = `translate(0px, 0px) scale(1.0)`;
    turnNum.innerText = `ターン${crr_turn}`;
    playerName.innerText = `${window.player_names[playerId]}さん`;    

    setTimeout(() => {
        turnNotice.style.display = `block`;
        setTimeout(() => {
            turnNotice.style.display = 'none';
        }, 1000);
    }, 800);
    
    // 1.5秒（1500ミリ秒）全体を見せた後、自分のコマにググッとズームインする
    setTimeout(() => {
        // playerのいるマスのインデックスとズーム倍率
        focusOnPlayer(square_index, 1.8);
        
        // ズームが終わった頃（約0.5秒後）にサイコロボタンを活性化させるなどの処理
        setTimeout(() => {
            diceButton.disabled = false;
            diceButton.style.opacity = 1.0;
            //alert("サイコロを振ってください！");
        }, 500);
    }, 2100);
}

/**
 * サイコロの目が出て、コマが動くときの処理
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

/**
 * サイコロの目がでる演出
 */

// プレイヤーの現在地を管理する変数（例）
// play_sugoroku.js

const player_positions = { 1: 0, 2: 0, 3: 0, 4: 0};
let current_turn = 1;
let current_player = 1;

// 💡 画面のHTML要素がすべて出揃ったタイミングで実行する
window.addEventListener('load', () => {
    console.log("play_sugoroku.js の読み込み＆画面準備完了！");

    const diceButton = document.getElementById("dice");
    const diceOverlay = document.getElementById('dice-overlay');
    const pieceInWindow = document.getElementById('piece-in-window');
    const playerNameInWindow = document.getElementById('playername-in-window');


    // 💡 ボタンが見つからなかったら、コンソールに警告を出すようにする（デバッグ用）
    if (!diceButton) {
        console.error("エラー: HTMLの中に id='dice' のボタンが見つかりません！");
        return;
    }
    if (!diceOverlay) {
        console.warn("警告: HTMLの中に id='dice-overlay' の要素が見つかりません");
    }

    // ここで初めてクリックイベントを登録する
    diceButton.addEventListener("click", () => {
        console.log("diceボタンが押されました！");
        
        const target_number = Math.floor(Math.random() * 6) + 1; 
        console.log("事前に決めた出したい目:", target_number);

        // ボタンの不活性化
        diceButton.disabled = true;
        diceButton.style.opacity = 0.5;

        if (diceOverlay) {
            diceOverlay.classList.remove('is-hidden');
        }
        setTimeout(() => {
            rollADie({
            element: document.getElementById('dice-box'),
            numberOfDice: 1,
            values: [target_number],
            delay: 3000,
            callback: (result) => {
                const final_dice_result = result[0];
                
                setTimeout(() => {
                    //alert(`${current_player}Pは ${final_dice_result} が出ました！`);
                    if (diceOverlay) {
                        diceOverlay.classList.add('is-hidden');
                    }

                    const before_index = player_positions[current_player]
                    player_positions[current_player] += final_dice_result;
                    const next_index = player_positions[current_player];

                    /** コマの位置の調整(同じコマに止まったらそれぞれ位置をずらす) */
                    const [new_x, new_y] = getSquareCoordinate(next_index);
                    let same_position = [];
                    let player_piece;
                    for (let i = 0; i < window.player_count; i++) {
                        if((player_positions[i+1] == next_index)) {
                            same_position.push(i+1);
                        }
                    }
                    console.log("同じマスに止まったプレイヤー：", same_position);
                    if (same_position.length != 1) {
                        same_position.forEach((value, index) => {
                            console.log(value, index);
                            player_piece = document.getElementById(`player-${value}-piece`);
                            if (player_piece) {
                                player_piece.style.left = index%2 === 0 ? new_x + 60 + 'px' : new_x + dice_size + 75 + 'px';
                                player_piece.style.top = index < 2 ? new_y + 'px' : new_y + dice_size + 15 + 'px';
                            }
                            else {
                                console.log("プレイヤーのコマが取得できません");
                            }
                        });
                    }
                    else {
                        const piece = document.getElementById(`player-${current_player}-piece`);
                        if (piece) {
                            piece.style.left = new_x + 82 + "px";
                            piece.style.top = new_y + 25 + "px";
                        }
                    }                    
                    
                    //current_player = current_player === 1 ? 2 : 1;
                    current_player = current_player === window.player_count ? 1 : ++current_player;

                }, 2000);
                setTimeout(() => {
                    pieceInWindow.style.background = window.player_colors[current_player-1];
                    playerNameInWindow.textContent = window.player_names[current_player-1] + ' さん';
                    startTurn(1, current_player-1, player_positions[current_player]);
                    // diceButton.disabled = false;    // サイコロボタンを活性化
                    // diceButton.style.opacity = 1.0;
                }, 3000);
            }
            });
        }, 200);
    });
});
// function diceAnimetion {

// }


// 特定のマスにズーム
function focusOnPlayer(square_index, zoom) {
    const camera = document.getElementById('map-camera');
    const cameraContainer = document.querySelector('#lines'); // .map-camera の親要素
    const W = cameraContainer.clientWidth;  // 画面の横幅
    const H = cameraContainer.clientHeight; // 画面の縦幅
    console.log("W: %d, H: %d", W, H);

    const [x, y] = getSquareCoordinate(square_index);

    // 公式に当てはめて移動量を計算する
    const translateX = (W / 2) - ((x + 180) * zoom); // 0にならないように1を足してみる
    const translateY = (H / 2) - ((y + 225) * zoom);

    //camera.style.transform = 'translate(-' + x + 'px, -' + y +'px) scale(' + zoom + ')';
    camera.style.transform = `translate(${translateX}px, ${translateY}px) scale(${zoom})`;

}

// マスの座標を計算
function getSquareCoordinate(square_index) {
    const row = Math.floor(square_index / square_cols);
    const colInRow = square_index % square_cols;
    const col = row % 2 === 0
        ? colInRow
        : (square_cols - 1 - colInRow);

    const x = col * x_distance;
    const y = row * y_distance;

    return [x , y]; // マスの左上座標
}

document.addEventListener('turbo:load', () => {
    console.log('setInitialPositions');
    //renderMap();
    setInitialPositions();
    startTurn(1,0,0);
    
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