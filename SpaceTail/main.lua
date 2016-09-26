-- Space Tail yehhhhhh Game xD

-- Hide Status Bar

display.setStatusBar(display.HiddenStatusBar)

-- Import MovieClip Library

local movieclip = require('movieclip')

-- Import Physics

local physics = require('physics')
physics.start()
physics.setGravity(0, 0)

-- Graphics

-- Background

screenW = display.contentWidth
screenH = display.contentHeight
halfW = display.contentWidth*0.5 
halfH = display.contentHeight*0.5

local bg = display.newImage('game/bg.png')
		bg.x = halfW
		bg.y = halfH


-- [Title View]

local title
local playBtn
local creditsBtn
local titleView

-- [Credits]

local creditsView

-- [Ship]

local ship

-- [Boss]

local boss

-- [Score]

local score

local info

-- [Lives]

local lives

-- Load Sounds

local shot = audio.loadSound('sound/shot.mp3')
local explo = audio.loadSound('sound/explo.mp3')
local bossSound = audio.loadSound('sound/boss.mp3')

-- Variables

local timerSource1
local timerSource2
local timerSource3
local lives = display.newGroup()
local bullets = display.newGroup()
local enemies1 = display.newGroup()
local enemies2 = display.newGroup()
local enemies3 = display.newGroup()
local scoreN = 0
local infoN = 0
local bossHealth = 20
local alertView
local trans
local speed1 = 1.5
local speed2 = 2.5
local control = 0 

-- Functions

local Main = {}
local addTitleView = {}
local showCredits = {}
local removeCredits = {}
local removeTitleView = {}
local addShip = {}
local addScore = {}
local addLives = {}
local listeners = {}
local moveShip = {}
local shoot = {}
local addEnemy1 = {}
local addEnemy2 = {}
local addEnemy3 = {}
local alert = {}
local update = {}
local collisionHandler = {}
local restart = {}

-- Main Function

function Main()
	addTitleView()
end

function addTitleView()
	title = display.newImage('game/title.png')
		title.x = halfW
		title.y = halfH + 5
	playBtn = display.newImage('game/playBtn.png')
	playBtn.x = display.contentCenterX
	playBtn.y = display.contentCenterY + 10
	playBtn:addEventListener('tap', removeTitleView)
	
	creditsBtn = display.newImage('game/creditsBtn.png')
	creditsBtn.x = halfW
	creditsBtn.y = halfH + 60
	creditsBtn:addEventListener('tap', showCredits)
	
	titleView = display.newGroup(title, playBtn, creditsBtn)
end

function removeTitleView:tap(e)
	transition.to(titleView,  {time = 300, y = -display.contentHeight, onComplete = function() display.remove(titleView) titleView = null addShip() if(creditsView ~= null)then creditsView:removeSelf( ) creditsView = null end end})
end

function showCredits:tap(e)
	creditsBtn.isVisible = false
	creditsView = display.newImage('game/creditsView.png')
	creditsView.x = halfW;
	creditsView.y = halfH;
	
	transition.from(creditsView, {time = 300, x = 1000, y = 1000})
	creditsView:addEventListener('tap', removeCredits)
end

function removeCredits:tap(e)
	creditsBtn.isVisible = true
	transition.to(creditsView, {time = 500, x = display.contentWidth, onComplete = function() display.remove(creditsView) creditsView = null end})
end

function addShip()
	ship = movieclip.newAnim({'img/shipA.png', 'img/shipB.png'})
	ship.x = display.contentWidth * 0.5
	ship.y = display.contentHeight - ship.height
	ship.name = 'ship'
	ship:play()
	physics.addBody(ship)
	
	addScore()
end

function addScore()
	score = display.newText('Score: ', 1, 0, native.systemFontBold, 14)
	score.x = 40
	score.y = display.contentHeight - score.height * 0.05
	score.text = score.text .. tostring(scoreN)
	score.anchorX = 0.5
	score.anchorY = 0.5
	--score:setReferencePoint(display.TopLeftReferencePoint)
	
	--addInfo()
	addLives()
end

function addLives()
	for i = 1, 3 do
		live = display.newImage('img/live.png')
		live.x = (display.contentWidth - live.width * 0.7) - (5 * i+1) - live.width * i + 20
		live.y = display.contentHeight - live.height * 0.1
		
		lives.insert(lives, live)
	end
	listeners('add')
end

function addInfo()
	info = display.newText('Info: ', 1, 0, native.systemFontBold, 14)
	info.x = 40
	info.y = display.contentHeight - 10
	info.text = info.text .. tostring(infoN)
	info.anchorX = 0.5
	info.anchorY = 0.5
	--score:setReferencePoint(display.TopLeftReferencePoint)
end

function listeners(action)
	if(action == 'add') then	
		bg:addEventListener('touch', moveShip)
		bg:addEventListener('tap', shoot)
			Runtime:addEventListener('enterFrame', update)
			if(scoreN == 0)then
				 	show1 = 3000
				 	show2 = 2000
				 	show3 = 10000
				 	 timerSource3 = timer.performWithDelay(show3, addEnemy3, 0)
				 timerSource1 = timer.performWithDelay(show1, addEnemy1, 0)
				 timerSource2 = timer.performWithDelay(show2, addEnemy2, 0)
				 end

	else
		bg:removeEventListener('touch', moveShip)
		bg:removeEventListener('tap', shoot)
		Runtime:removeEventListener('enterFrame', update)
		timer.cancel(timerSource1)
		timer.cancel(timerSource2)
		timer.cancel(timerSource3)
	end
end

function moveShip:touch(e)
	if(e.phase == 'began') then
		lastX = e.x - ship.x
	elseif(e.phase == 'moved') then
		ship.x = e.x - lastX
		if ship.x <= 0 then
			ship.x = 0
		end
		if ship.x > display.contentWidth then
			ship.x = display.contentWidth
		end
	end
end

function shoot:tap(e)
	local bullet = display.newImage('img/tiro1.png')
	bullet.x = ship.x
	bullet.y = ship.y - ship.height
	bullet.name = 'bullet'
	physics.addBody(bullet)
	
	audio.play(shot)
	
	bullets.insert(bullets, bullet)
end

function addEnemy1(e)
	local enemy1 = movieclip.newAnim({'img/enemy1A.png', 'img/enemy1A.png','img/enemy1A.png','img/enemy1A.png','img/enemy1A.png','img/enemy1A.png','img/enemy1B.png','img/enemy1B.png','img/enemy1B.png','img/enemy1B.png','img/enemy1B.png','img/enemy1B.png'})
	enemy1.x = math.floor(math.random() * (display.contentWidth - enemy1.width))
	enemy1.y = -enemy1.height
	enemy1.name = 'enemy1'
	physics.addBody(enemy1)
	enemy1.bodyType = 'static'
	enemies1.insert(enemies1, enemy1)
	enemy1:play()
	enemy1:addEventListener('collision', collisionHandler)
end


function addEnemy2(e)
	local enemy2 = movieclip.newAnim({'img/enemy2A.png', 'img/enemy2A.png','img/enemy2A.png','img/enemy2B.png','img/enemy2B.png','img/enemy2B.png'})
	enemy2.x = math.floor(math.random() * (display.contentWidth - enemy2.width))
	enemy2.y = -enemy2.height
	enemy2.name = 'enemy2'
	enemy2.hp = 2
	physics.addBody(enemy2)
	enemy2.bodyType = 'static'
	enemies2.insert(enemies2, enemy2)
	enemy2:play()
	enemy2:addEventListener('collision', collisionHandler)
end

function addEnemy3(e)
	local enemy3 = movieclip.newAnim({'img/meteor1.png','img/meteor1.png','img/meteor1.png', 'img/meteor2.png','img/meteor2.png', 'img/meteor2.png','img/meteor3.png','img/meteor3.png','img/meteor3.png','img/meteor4.png','img/meteor4.png','img/meteor4.png','img/meteor5.png','img/meteor5.png','img/meteor5.png','img/meteor6.png','img/meteor6.png','img/meteor6.png','img/meteor7.png','img/meteor7.png','img/meteor7.png','img/meteor8.png','img/meteor8.png','img/meteor8.png'})
	
			local startingPosition = math.random(1,3)
						if(startingPosition == 1) then
							-- Envia o inimigo do lado esquerdo do ecra
							enemy3.x = -10
							enemy3.y = math.random(0,screenH)
						elseif(startingPosition == 2) then
							-- Envia o inimigo do direito esquerdo do ecra
							enemy3.x = screenW + 10
							startingY = math.random(0,screenH)
						else
							-- Envia o inimigo do topo esquerdo do ecra
						enemy3.x = math.random(0,screenW)
						enemy3.y = -10
						end
	enemy3.name = 'meteor'
	physics.addBody(enemy3)
	enemy3.bodyType = 'static'
	enemies3.insert(enemies3, enemy3)
	enemy3:play()
	enemy3:addEventListener('collision', collisionHandler)
end


function alert(e)
	listeners('remove')
	
	if(e == 'win') then
		alertView = display.newImage('game/youWon.png')
		alertView.x = display.contentWidth * 0.5
		alertView.y = display.contentHeight * 0.5
	else
		alertView = display.newImage('game/gameOver.png')
		alertView.x = display.contentWidth * 0.5
		alertView.y = display.contentHeight * 0.5
	end
	
	alertView:addEventListener('tap', restart)
end

function update(e)
	-- Move Bullets

		--infoN = bullets.numChildren
			--	info.text = 'Info: ' .. tostring(infoN)

			if(scoreN >= 100 and control == 0)then
				speed1 = speed1 + 1.2
				speed2 = speed2 + 1
				control = 1
			end

			if(scoreN >= 200 and control == 1)then
				speed1 = speed1 + 1.2
				speed2 = speed2 + 1
				control =2
			end

			if(scoreN >= 300 and control == 3)then
				speed1 = speed1 + 1.2
				speed2 = speed2 + 1
				control =4
			end
		
	if(bullets.numChildren ~= 0) then
		for i = 1, bullets.numChildren do
			bullets[i].y = bullets[i].y - 10
			
			-- Destroy Offstage Bullets

			if(bullets[i].y < -bullets[i].height) then
				bullets:remove(bullets[i])
				display.remove(bullets[i])
				bullets[i] = nil
			end

		end
	end
	
	-- Move Enemies
	
	if(enemies1.numChildren ~= 0) then
		for i = 1, enemies1.numChildren do
			if(enemies1[i] ~= nil) then
				enemies1[i].y = enemies1[i].y + speed1
			
				-- Destroy Offstage Enemies
			
				if(enemies1[i].y > display.contentHeight) then
					enemies1[i]:removeSelf(); 
					display.remove(lives[lives.numChildren])

					--enemies1:remove(enemies1[i])
					--display.remove(enemies1[i])
						if(lives.numChildren < 1) then
							alert('lose')
						end
				end
			end
		end
	end
	
	-- Move Enemies2

	if(enemies2.numChildren ~= 0) then
		for i = 1, enemies2.numChildren do
			if(enemies2[i] ~= nil) then
				
				enemies2[i].y = enemies2[i].y + speed2
			
				 if(enemies2[i].y > 5)then
				 	enemies2[i].x = enemies2[i].x + 5 
				 	enemies2[i].x = enemies2[i].x - 5
			
				-- Destroy Offstage Enemies
			
				if(enemies2[i].y > display.contentHeight) then
					enemies2[i]:removeSelf(); 
					--enemies2:remove(enemies2[i])
					--display.remove(enemies2[i])
					display.remove(lives[lives.numChildren])
						if(lives.numChildren < 1) then
							alert('lose')
						end
					end
				end
			end
		end
end

 -- Move meteor
	if(enemies3.numChildren ~= 0) then
		for i = 1, enemies3.numChildren do
			if(enemies3[i] ~= nil) then
			
				 enemies3[i] = transition.moveTo(enemies3[i], { time=2500, x=halfW, y=800, onComplete=retirar }	)	

				 function retirar()
				 	display.remove(enemies3[i])
				   end
				end
			end
		end
	-- Show Boss
	

	if(scoreN >= 10 and boss == nil) then
		audio.play(bossSound)
		boss = movieclip.newAnim({'img/bossA.png','img/bossA.png','img/bossA.png','img/bossA.png','img/bossA.png', 'img/bossA.png','img/bossA.png', 'img/bossB.png','img/bossB.png','img/bossB.png','img/bossB.png','img/bossB.png','img/bossB.png','img/bossB.png'})
		boss.x = display.contentWidth * 0.5
		boss.name = 'boss'
		physics.addBody(boss)
		boss.bodyType = 'static'
		transition.to(boss, {time = 1000, y = boss.height})
		boss:play()
		boss:addEventListener('collision', collisionHandler)
end

end
function collisionHandler(e)
	if(e.other.name == 'bullet' and e.target.name == 'enemy1') then
		audio.play(explo)
		display.remove(e.other)
		display.remove(e.target)
		scoreN = scoreN + 10
		score.text = 'Score: ' .. tostring(scoreN)
		score.anchorX = 0.5
		score.anchorY = 0.5
		-- score:setReferencePoint(display.TopLeftReferencePoint)
		score.x = 40

	elseif(e.other.name == 'bullet' and e.target.name == 'enemy2') then
		audio.play(explo)
		display.remove(e.other)
		e.target.hp = e.target.hp - 1
		scoreN = scoreN + 25
		score.text = 'Score: ' .. tostring(scoreN)
		score.anchorX = 0.5
		score.anchorY = 0.5
		-- score:setReferencePoint(display.TopLeftReferencePoint)
		score.x = 40
		if(e.target.hp <= 0) then
			display.remove(e.target)
		end
	elseif(e.other.name == 'bullet' and e.target.name == 'meteor') then
		audio.play(explo)
		display.remove(e.other)
		display.remove(e.target)
		scoreN = scoreN + 1
		score.text = 'Score: ' .. tostring(scoreN)
		score.anchorX = 0.5
		score.anchorY = 0.5
		-- score:setReferencePoint(display.TopLeftReferencePoint)
		score.x = 40
	elseif(e.other.name == 'bullet' and e.target.name == 'boss') then
		audio.play(explo)
		display.remove(e.other)
		bossHealth = bossHealth - 1
		scoreN = scoreN + 50
		score.text = 'Score: ' .. tostring(scoreN)
		--score:setReferencePoint(display.TopLeftReferencePoint)
		score.x = 40
		if(bossHealth <= 10)then
			transition.to(boss, {time = 1000, y = boss.height-50})
		end
		if(bossHealth <= 0) then
			display.remove(e.target)
			alert('win')
		end
	elseif(e.other.name == 'ship') then
		audio.play(explo)
		
		display.remove(e.target)
		
		-- Remove Live
		
		display.remove(lives[lives.numChildren])
		
		-- Check for Game Over
		
		if(lives.numChildren < 1) then
			alert('lose')
		end
	end
end

function restart()

	display.remove( bullets )
	display.remove( enemies1 )
	display.remove( enemies2 )
	display.remove( ship )
	display.remove( score )

		--alertView:removeSelf()
		timer.cancel(timerSource1)
		timer.cancel(timerSource2)
		timer.cancel(timerSource3)
	display.remove( alertView ) alertView = null

lives = null 
lives = display.newGroup()
bullets = null 
bullets = display.newGroup()
enemies1 = null 
enemies1 = display.newGroup()
enemy2 = null 
enemies2 = display.newGroup()
enemy3 = null 
enemies3 = display.newGroup()
ship = null
listeners('remove')
scoreN = 0
score = null

	Main()
end

Main()