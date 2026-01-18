const canvas = document.getElementById("gameCanvas");
const ctx = canvas.getContext("2d");
const box = 20;
const canvasSize = 400;
let DirectionLock = false;
var game = undefined

let snake = [{ x: 9 * box, y: 9 * box }];
let direction = "RIGHT";
let score = 0;

function generateFood() {
    let newFood;
    let isOnEdge = false;
    let isOnSnake = false;

    do {
        newFood = {
            x: Math.floor(Math.random() * (canvasSize / box)) * box,
            y: Math.floor(Math.random() * (canvasSize / box)) * box,
        };

        isOnEdge =
            newFood.x === 0 || newFood.y === 0 || newFood.x === canvasSize - box || newFood.y === canvasSize - box;
        isOnSnake = collision(newFood, snake);
    } while (isOnEdge || isOnSnake);

    return newFood;
}

let food = generateFood();

document.addEventListener("keydown", changeDirection);

function changeDirection(event) {
    if (DirectionLock) {
        return;
    }
    if (event.key === "ArrowLeft" && direction !== "RIGHT") {
        direction = "LEFT";
        DirectionLock = true;
    } else if (event.key === "ArrowUp" && direction !== "DOWN") {
        direction = "UP";
        DirectionLock = true;
    } else if (event.key === "ArrowRight" && direction !== "LEFT") {
        direction = "RIGHT";
        DirectionLock = true;
    } else if (event.key === "ArrowDown" && direction !== "UP") {
        direction = "DOWN";
        DirectionLock = true;
    }
}

function draw() {
    DirectionLock = false;

    ctx.clearRect(0, 0, canvasSize, canvasSize);

    for (let i = 0; i < snake.length; i++) {
        ctx.fillStyle = i === 0 ? "green" : "lightgreen";
        ctx.fillRect(snake[i].x, snake[i].y, box, box);
    }

    ctx.fillStyle = "red";
    ctx.fillRect(food.x, food.y, box, box);

    let headX = snake[0].x;
    let headY = snake[0].y;

    if (direction === "LEFT") {
        headX -= box;
    }
    if (direction === "RIGHT") {
        headX += box;
    }
    if (direction === "UP") {
        headY -= box;
    }
    if (direction === "DOWN") {
        headY += box;
    }

    if (headX === food.x && headY === food.y) {
        score++;
        CjObj.getscore(score.toString())
        food = generateFood();
    } else {
        snake.pop();
    }


    const newHead = { x: headX, y: headY };


    if (
        headX < 0 || headY < 0 ||
            headX >= canvasSize || headY >= canvasSize ||
        collision(newHead, snake)
    ) {
        clearInterval(game);
        CjObj.gameover()
        ctx.font = "50px Arial";
        ctx.fillStyle = "black";
        ctx.fillText("Game Over", canvasSize / 2 - 125, canvasSize / 2);

    }

    snake.unshift(newHead);
}

function collision(head, body) {
    for (let i = 0; i < body.length; i++) {
        if (head.x === body[i].x && head.y === body[i].y) {
            return true;
        }
    }
    return false;
}

game = setInterval(draw, 200);