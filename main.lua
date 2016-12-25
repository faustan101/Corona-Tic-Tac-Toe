
--Main Menu Screen
local mmGroup 
local mmBackground
local mmPlayBtn
local mmExitBtn

--Game Screen
local gameScreenGroup
local gameBackground
local boxRow = 3
local boxColumn = 3
local boxGap = 3
local boxWidth = 100
local boxHeight = 100
local lineGroup
local boxGroup

local winLineGroup

local square
local notBlank = display.newGroup()

--Player 1
local p1 = "X"
local p1Score = 0

--Player 2
local p2 = "O"
local p2Score = 0

local icon
local iconGroup
--Winner
local isWin = false
local board = {}
board[0] = {}
board[1] = {}
board[2] = {}

--Variables 
local _W = display.contentWidth / 2
local _H = display.contentHeight / 2
local turn = "player1"
local  drawPlayerTurn
local drawScore1, drawScore2

function mainMenuScreen()
	mmGroup = display.newGroup()

	mmBackground = display.newImage("images/mmbackground.png")
	mmBackground.x = _W; mmBackground.y = _H

	mmPlayBtn = display.newImage("images/mmplaybtn.png")
	mmPlayBtn.x = _W; mmPlayBtn.y = _H
	mmPlayBtn.name = "Play"

	mmExitBtn = display.newImage("images/mmexitbtn.png")
	mmExitBtn.x = _W; mmExitBtn.y = _H + mmPlayBtn.width
	mmExitBtn.name = "Exit"

	mmGroup:insert(mmBackground)
	mmGroup:insert(mmPlayBtn)
	mmGroup:insert(mmExitBtn)

	mmPlayBtn:addEventListener("tap", loadGame)

	mmExitBtn:addEventListener("tap", exit)
end

local function closeapp()
       if  system.getInfo("platformName")=="Android" then
           native.requestExit()
       else
           os.exit() 
      end

end

function exit( event )

     timer.performWithDelay(1000,closeapp)
end  

function loadGame(event)
	if event.target.name == "Play" then
		transition.to(mmGroup, {time = 0, alpha = 0, onComplete = addGameScreen})
		mmPlayBtn:removeEventListener("tap", loadGame)
	end

end

function addGameScreen()
	local score1, score2
	local drawPlayer1, drawPlayer2
	local drawWordTurn
	gameScreenGroup = display.newGroup()

	gameBackground = display.newImage("images/gamebackground.png")
	gameBackground.x = _W; gameBackground.y = _H

	drawWordTurn = display.newText("Turn", display.contentCenterX, 0)
	drawWordTurn:setFillColor(0, 0, 0)

	drawPlayerTurn = display.newText("X Turn", display.contentCenterX, 20)
	drawPlayerTurn:setFillColor(0, 0, 1)

	drawPlayer1 = display.newText("Player 1", 0, 0, "Comic Sans MS", 14)
	drawPlayer1.x = 25; drawPlayer1.y = 0
	drawPlayer1:setFillColor(0, 0, 0)
	
	score1 = display.newText("Score: ", 25, 25, "Comic Sans MS", 14)
	score1:setFillColor(0, 0, 0)

	drawScore1 = display.newText(p1Score, 60, 25, "Comic Sans MS", 14)
	drawScore1:setFillColor(0, 0, 0)


	score2 = display.newText("Score: ", display.contentWidth - 65, 25, "Comic Sans MS", 14)
	score2:setFillColor(0, 0, 0)

	drawScore2 = display.newText(p2Score, display.contentWidth -30, 25, "Comic Sans MS", 14)
	drawScore2:setFillColor(0, 0, 0)

	drawPlayer2 = display.newText("Player 2", 0, 0, "Comic Sans MS", 14)
	drawPlayer2.x = display.contentWidth - 50; drawPlayer2.y = 0
	drawPlayer2:setFillColor(0, 0, 0)

	drawBox()
	drawLine()

	drawBackbtn = display.newImage("images/backbtn.png", 50, display.contentHeight - 20)
	drawBackbtn.height = 100; drawBackbtn.width = 100
	drawBackbtn:addEventListener("tap", backToMainMenu)

	gameScreenGroup:insert(gameBackground)
	gameScreenGroup:insert(drawWordTurn)
	gameScreenGroup:insert(drawPlayerTurn)
	gameScreenGroup:insert(drawPlayer1)
	gameScreenGroup:insert(score1)
	gameScreenGroup:insert(drawScore1)
	gameScreenGroup:insert(score2)
	gameScreenGroup:insert(drawScore2)
	gameScreenGroup:insert(drawPlayer2)
	gameScreenGroup:insert(drawBackbtn)

end

function backToMainMenu(event)
	gameScreenGroup:removeSelf()
	gameScreenGroup = nil

	boxGroup:removeSelf()
	boxGroup = nil

	iconGroup:removeSelf()
	iconGroup = nil

	lineGroup:removeSelf()
	lineGroup = nil

	mmGroup.alpha = 1

	mmPlayBtn:addEventListener("tap", loadGame)
end

function drawBox()
	boxGroup = display.newGroup()

	local height = _H - boxHeight
	local width = _W - boxWidth
	for row = 0, boxRow-1 do
		for column = 0, boxColumn - 1  do
			square = display.newRect((boxGap * column) + width + (100 * column),  (boxGap * row) + (height) + (100 * row), boxWidth, boxHeight)
			square.id = "square"
			square.name = row .. column
			--square:setFillColor(1, 0, 0)
			square:addEventListener("tap", displayXO)
			boxGroup:insert(square)
		end
	end 
	iconGroup = display.newGroup()
	--[[
	(0 + width + 0, height + (100 * 0)),     (3 + width + 100, height + (100 * 0)),     (6 + width + 200, height + (100 * 0)) row = 0
	(0 + width + 0, height + (100 * 1) + 3), (3 + width + 100, height + (100 * 1) + 3), (6 + width + 200, height + (100 * 1) + 3) row = 1
	(0 + width + 0, height + (100 * 2) + 6), (3 + width + 100, height + (100 * 2) + 6), (6 + width + 200, height + (100 * 2) + 6) row = 2
	]]--
end

function drawLine()
	lineGroup = display.newGroup()

	local height = _H - boxHeight
	local width = _W - boxWidth

	local line1 = display.newLine( 0 + width + 0   + 50, height + (100 * 0)     - 50, 0 + width + 0   + 50, height + (100 * 2) + 6  + 50)
	local line2 = display.newLine( 3 + width + 100 + 50, height + (100 * 0)     - 50, 3 + width + 100 + 50, height + (100 * 2) + 6  + 50)
	local line3 = display.newLine( 0 + width + 0   - 50, height + (100 * 0)     + 50, 6 + width + 200 + 50, height + (100 * 0) + 50)
	local line4 = display.newLine( 0 + width + 0   - 50, height + (100 * 1) + 3 + 50, 6 + width + 200 + 50, height + (100 * 1) + 3  + 50)
	line1.strokeWidth = 1; line1:setStrokeColor(0, 0, 0)
	line2.strokeWidth = 1; line2:setStrokeColor(0, 0, 0)
	line3.strokeWidth = 1; line3:setStrokeColor(0, 0, 0)
	line4.strokeWidth = 1; line4:setStrokeColor(0, 0, 0)

	lineGroup:insert(line1)
	lineGroup:insert(line2)
	lineGroup:insert(line3)
	lineGroup:insert(line4)
	--[[
		for a = 0, 1 do
			for b = 0, 1 do
				local line = display.newLine()
				line.strokeWidth = 5
				line:setStrokeColor(0, 0, 0)
			end
		end
	]]--
end

function displayXO(event)

	local location1
	local location2

	iconGroup:toFront()

	for a = 0, 2 do
		for b = 0, 2 do
			if (a .. b) == event.target.name then
				location1 = a
				location2 = b
				break
			end
		end
		if location1 ~= nil then break end
	end
	if event.target.id == "square" then
		if turn == "player1" then
			board[location1][location2] = "X"
			turn = "player2"
			drawPlayerTurn.text = "O Turn"
			icon = display.newImage("images/x.png", event.target.x, event.target.y)
			icon.height = 90; icon.width = 90	
			iconGroup:insert(icon)
		else
			board[location1][location2] = "O"
			turn = "player1"
			drawPlayerTurn.text = "X Turn"
			icon = display.newImage("images/o.png", event.target.x, event.target.y)
			icon.height = 90; icon.width = 90
			iconGroup:insert(icon)
		end

		isWin = checkWin()
		if isWin then
			boxGroup:removeSelf()
			boxGroup = nil
			timer.performWithDelay(1000, win)
		end
	end
	event.target:removeEventListener("tap", displayXO)
end

function win()
	if turn == "player1" then
		p2Score = p2Score + 1
		drawScore2.text = p2Score
	else
		p1Score = p1Score + 1
		drawScore1.text = p1Score
	end

	lineGroup:removeSelf()
	lineGroup = nil

	iconGroup:removeSelf()
	iconGroup = nil

	winLineGroup:removeSelf()
	winLineGroup = nil

	board = nil

	nextGame()
end

function nextGame()
	drawBox()
	drawLine()
	iconGroup = display.newGroup()

	board = {}
	board[0] = {}
	board[1] = {}
	board[2] = {}

	isWin = false
	turn = "player1"
	drawPlayerTurn.text = "X Turn"
end

function checkWin()
	winLineGroup = display.newGroup()
	local height = _H - boxHeight
	local width = _W - boxWidth
	--[[
	(0 + width + 0, height + (100 * 0)),     (3 + width + 100, height + (100 * 0)),     (6 + width + 200, height + (100 * 0)) row = 0
	(0 + width + 0, height + (100 * 1) + 3), (3 + width + 100, height + (100 * 1) + 3), (6 + width + 200, height + (100 * 1) + 3) row = 1
	(0 + width + 0, height + (100 * 2) + 6), (3 + width + 100, height + (100 * 2) + 6), (6 + width + 200, height + (100 * 2) + 6) row = 2
	]]--

	if (board[0][0] == board[0][1] and board[0][1] == board[0][2] and board[0][0] ~= nil) then
		drawWinLine1 = display.newLine(0 + width + 0, height + (100 * 0), 6 + width + 200, height + (100 * 0))
		drawWinLine1.strokeWidth = 15; drawWinLine1:setStrokeColor(1, 0, 0)
		winLineGroup:insert(drawWinLine1)
		return true

	elseif (board[1][0] == board[1][1] and board[1][1] == board[1][2] and board[1][1] ~= nil) then
		drawWinLine2 = display.newLine(0 + width + 0, height + (100 * 1) + 3, 6 + width + 200, height + (100 * 1) + 3)
		drawWinLine2.strokeWidth = 15; drawWinLine2:setStrokeColor(1, 0, 0)
		winLineGroup:insert(drawWinLine2)
		return true

	elseif (board[2][0] == board[2][1] and board[2][1]== board[2][2] and board[2][0] ~= nil) then
		drawWinLine3 = display.newLine(0 + width + 0, height + (100 * 2) + 6, 6 + width + 200, height + (100 * 2) + 6)
		drawWinLine3.strokeWidth = 15; drawWinLine3:setStrokeColor(1, 0, 0)
		winLineGroup:insert(drawWinLine3)
		return true

	elseif (board[0][0] == board[1][0] and board[1][0] == board[2][0] and board[0][0] ~= nil) then
		drawWinLine4 = display.newLine(0 + width + 0, height + (100 * 0), 0 + width + 0, height + (100 * 2) + 6)
		drawWinLine4.strokeWidth = 15; drawWinLine4:setStrokeColor(1, 0, 0)
		winLineGroup:insert(drawWinLine4)
		return true

	elseif (board[0][1] == board[1][1] and board[1][1] == board[2][1] and board[0][1] ~= nil) then
		drawWinLine5 = display.newLine(3 + width + 100, height + (100 * 0), 3 + width + 100, height + (100 * 2) + 6)
		drawWinLine5.strokeWidth = 15; drawWinLine5:setStrokeColor(1, 0, 0)
		winLineGroup:insert(drawWinLine5)
		return true

	elseif (board[0][2] == board[1][2] and board[1][2] == board[2][2] and board[0][2] ~= nil) then
		drawWinLine6 = display.newLine(6 + width + 200, height + (100 * 0), 6 + width + 200, height + (100 * 2) + 6)
		drawWinLine6.strokeWidth = 15; drawWinLine6:setStrokeColor(1, 0, 0)
		winLineGroup:insert(drawWinLine6)
		return true

	elseif (board[0][0] == board[1][1] and board[1][1] == board[2][2] and board[0][0] ~= nil) then
		drawWinLine7 = display.newLine(0 + width + 0, height + (100 * 0), 6 + width + 200, height + (100 * 2) + 6)
		drawWinLine7.strokeWidth = 15; drawWinLine7:setStrokeColor(1, 0, 0)
		winLineGroup:insert(drawWinLine7)
		return true

	elseif (board[2][0] == board[1][1] and board[1][1] == board[0][2] and board[2][0] ~= nil) then
		drawWinLine8 = display.newLine(0 + width + 0, height + (100 * 2) + 6, 6 + width + 200, height + (100 * 0))
		drawWinLine8.strokeWidth = 15; drawWinLine8:setStrokeColor(1, 0, 0)
		winLineGroup:insert(drawWinLine8)
		return true
	else
		return false

	end
end

function main()
	mainMenuScreen()
end

main()