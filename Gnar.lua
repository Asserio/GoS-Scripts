if GetObjectName(GetMyHero()) ~= "Gnar" then return end

require "Inspired"

-- Menu
GnarMenu = MenuConfig("Gnar", "Gnar")

GnarMenu:Menu("MiniCombo", "Mini Combo")
GnarMenu.MiniCombo:Boolean("Q", "Use Gnar Q", true)
GnarMenu.MiniCombo:Boolean("E", "Use Gnar E", true)

GnarMenu:Menu("BigGnar", "BigGnar Combo")
GnarMenu.BigGnar:Boolean("Q", "Use BigGnar Q", true)
GnarMenu.BigGnar:Boolean("W", "Use BigGnar W", true)
GnarMenu.BigGnar:Boolean("E", "Use BigGnar E", true)
-- Range Draw
GnarMenu:Menu("Drawings", "Drawings")
GnarMenu.Drawings:Boolean("DrawQ","Draw Q", true)
GnarMenu.Drawings:Boolean("DrawW","Draw W", true)
GnarMenu.Drawings:Boolean("DrawE","Draw E", true)
GnarMenu.Drawings:Boolean("DrawR","Draw R", true)
-- PrintChat
local info = "Evolved Gnar Loaded"
local upv = "Upvote if you like it!"
local sig = "Made by Asserio"
local ver = "v 1.0"
textTable = {info,upv,sig,ver}
PrintChat(textTable[1])
PrintChat(textTable[2])
PrintChat(textTable[3])
PrintChat(textTable[4])


-- Start
OnTick(function(myHero)
	local mousePos = GetMousePos()
	local unit = GetCurrentTarget()
		if ValidTarget(unit, 1400) then
			if IOW:Mode() == "Combo" then
-- Mini Gnar Q
	-- GetPredictionForPlayer(startPosition, targetUnit, targetUnitMoveSpeed, spellTravelSpeed, spellDelay, spellRange, spellWidth, collision, addHitBox)
				local QPred = GetPredictionForPlayer(myHeroPos(),unit,GetMoveSpeed(unit),2500,250,1125,60,true,true)
				if GnarMenu.MiniCombo.Q:Value() then
					if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 then
						CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
					end
				end

-- Mini Gnar E
			if GnarMenu.MiniCombo.E:Value() then
				for i, tower in pairs(GetTurrets()) do
					local vec = GetOrigin(myHero) + (Vector(GetOrigin(myHero)) - GetOrigin(myHero)):normalized() * 800 -- We normalize the vector to equal 1 then multiply by 800 (what you said)
	-- GetPredictionForPlayer(startPosition, targetUnit, targetUnitMoveSpeed, spellTravelSpeed, spellDelay, spellRange, spellWidth, collision, addHitBox)
					local EPred = GetPredictionForPlayer(myHeroPos(),unit,GetMoveSpeed(unit),903,0,473,150,false,true)
-- E Simple Logic
					if not UnderTurret(vec, true) then
						if CanUseSpell(myHero, _E) == READY and GetCurrentHP(myHero) > GetCurrentHP(unit) and IsInDistance(unit, GetCastRange(myHero, _E)) and EnemiesAround(myHeroPos(), 1500) <= 2 and EPred.HitChance == 1 then
							CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
						elseif CanUseSpell(myHero, _E) == READY and GetCurrentHP(myHero) < GetCurrentHP(unit) then return end
-- E Simple GapCloser
						if CanUseSpell(myHero, _E) == READY and not IsInDistance(unit, GetCastRange(myHero,_Q)) and GetCurrentHP(myHero) > GetCurrentHP(unit) and EnemiesAround(myHeroPos(), 1500) then
							CastSkillShot(_E,mousePos.x,mousePos.y,mousePos.z)
						end
					end
				end
			end
-----------------------------------------------MEGA GNAR COMBO------------------------------------------------------------
-- Mega Gnar E
				if GetCastName(myHero, _E) == "gnarbigE" then
	-- GetPredictionForPlayer(startPosition, targetUnit, targetUnitMoveSpeed, spellTravelSpeed, spellDelay, spellRange, spellWidth, collision, addHitBox)
					local EPred = GetPredictionForPlayer(myHeroPos(),unit,GetMoveSpeed(unit),1000,250,475,200,false,true)
					if GnarMenu.BigGnar.E:Value() then
-- E Simple Logic
						if CanUseSpell(myHero, _W) == READY and WPred.HitChance == 1 then return end
							if CanUseSpell(myHero, _E) == READY and EPred.HitChance == 1 then
								CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
-- E Simple GapCloser
								elseif CanUseSpell(myHero, _E) == READY and not IsInDistance(unit, GetCastRange(myHero, _E) or GetCastRange(myHero,_Q)) then
								CastSkillShot(_E,mousePos.x,mousePos.y,mousePos.z)
							end

						end
					end
				end
-- Mega Gnar W
	-- GetPredictionForPlayer(startPosition, targetUnit, targetUnitMoveSpeed, spellTravelSpeed, spellDelay, spellRange, spellWidth, collision, addHitBox)
				local WPred = GetPredictionForPlayer(myHeroPos(),unit,GetMoveSpeed(unit),math.huge,600,600,80,false,true)
				if GnarMenu.BigGnar.W:Value() then
					if CanUseSpell(myHero, _W) == READY and WPred.HitChance == 1 then
						CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
					end
				end

-- Mega Gnar Q
				if GetCastName(myHero, _Q) == "bnarbigQ" then
	-- GetPredictionForPlayer(startPosition, targetUnit, targetUnitMoveSpeed, spellTravelSpeed, spellDelay, spellRange, spellWidth, collision, addHitBox)
					local QPred = GetPredictionForPlayer(myHeroPos(),unit,GetMoveSpeed(unit),2100,500,1150,90,true,true)
					if GnarMenu.BigGnar.Q:Value() then
						if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 then
							CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
						end
					end
				end

		end
end)

-- Range Drawing
OnDraw(function(myHero)
if CanUseSpell(myHero, _Q) == READY and GnarMenu.Drawings.DrawQ:Value() then DrawCircle(myHeroPos().x,myHeroPos().y,myHeroPos().z,GetCastRange(myHero,_Q),3,100,0xFFFF7F7F) end
if CanUseSpell(myHero, _W) == READY and GnarMenu.Drawings.DrawW:Value() then DrawCircle(myHeroPos().x,myHeroPos().y,myHeroPos().z,GetCastRange(myHero,_W),3,100,0xFF00FF00) end
if CanUseSpell(myHero, _E) == READY and GnarMenu.Drawings.DrawE:Value() then DrawCircle(myHeroPos().x,myHeroPos().y,myHeroPos().z,GetCastRange(myHero,_E),3,100,0xFFFFFFFF) end
if CanUseSpell(myHero, _R) == READY and GnarMenu.Drawings.DrawR:Value() then DrawCircle(myHeroPos().x,myHeroPos().y,myHeroPos().z,GetCastRange(myHero,_R),3,100,0xFFCC0000) end
end)
