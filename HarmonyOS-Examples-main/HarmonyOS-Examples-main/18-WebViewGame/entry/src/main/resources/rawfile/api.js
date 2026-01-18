var CjApi =  {}
CjApi.changeDirection = function (event) {
    if (DirectionLock) {
        return;
    }
    if (event === "ArrowLeft" && direction !== "RIGHT") {
        direction = "LEFT";
        DirectionLock = true;
    } else if (event === "ArrowUp" && direction !== "DOWN") {
        direction = "UP";
        DirectionLock = true;
    } else if (event === "ArrowRight" && direction !== "LEFT") {
        direction = "RIGHT";
        DirectionLock = true;
    } else if (event === "ArrowDown" && direction !== "UP") {
        direction = "DOWN";
        DirectionLock = true;
    }
}

CjApi.getscore = function () {
    return score;
}

CjApi.startorpause = function () {
    if (typeof game !== 'undefined') {
        clearInterval(game);
        game = undefined
    } else {
        game = setInterval(draw, 200);
    }
}