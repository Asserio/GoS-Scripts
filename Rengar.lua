if GetObjectName(myHero) == "Rengar" then

-- PrintChat
local info = "Evolved Rengar Loaded"
local upv = "Upvote if you like it!"
local sig = "Made by Asserio"
local ver = "v 1.0"
textTable = {info,upv,sig,ver}
PrintChat(textTable[1])
PrintChat(textTable[2])
PrintChat(textTable[3])
PrintChat(textTable[4])
-- Menu
Rengar = Menu("Rengar", "Rengar")
-- Combo menu
Rengar:SubMenu("Combo", "Combo")
Rengar.Combo:Boolean("Q", "Use Q", true)
Rengar.Combo:Boolean("W", "Use W", true)
Rengar.Combo:Boolean("E", "Use E", true)
-- Jungle Clear Menu
Rengar:SubMenu("Jungle", "Jungle clear")
Rengar.Jungle:Boolean("Q2", "Use Q", true)
Rengar.Jungle:Boolean("W2", "Use W", true)
Rengar.Jungle:Boolean("E2", "Use E", true)
Rengar.Jungle:Key("Jung", "Jungle", string.byte("V"))
-- LaneClear Menu
Rengar:SubMenu("LaneClear", "Lane Clear")
Rengar.LaneClear:Boolean("LC", "LaneClear", true)
Rengar.LaneClear:Boolean("Q3", "Use Q", true)
Rengar.LaneClear:Boolean("W3", "Use W", true)
Rengar.LaneClear:Boolean("E3", "Use E", true)
Rengar.LaneClear:Key("LClear", "LaneClear", string.byte("V"))
-- Misc
Rengar:SubMenu("Misc", "Misc")
Rengar.Misc:Boolean("AT", "AutoHeal", true)
-- Auto Level Up
Rengar.Misc:SubMenu("Auto", "Auto Level Up")
Rengar.Misc.Auto:Boolean("AutoL", "Auto Level Up", true)
Rengar.Misc.Auto:Boolean("ALJung", "Auto Level Up for Jungle", false)
Rengar.Misc.Auto:Boolean("ALTop", "Auto Level Up for Top", false)
-- Damage Draw
Rengar.Misc:SubMenu("DrawDMG", "Damage Draw")
Rengar.Misc.DrawDMG:Boolean("Q", "Draw Q Dmg", true)
Rengar.Misc.DrawDMG:Boolean("W", "Draw W Dmg", true)
Rengar.Misc.DrawDMG:Boolean("E", "Draw E Dmg", true)
-- Range Draw
Rengar.Misc:SubMenu("Range", "Range Draw")
Rengar.Misc.Range:Boolean("DrawW","Draw W", true)
Rengar.Misc.Range:Boolean("DrawE","Draw E", true)
-- Start
OnLoop(function(myHero)
Drawings()
DrawDamage()
AutoHeal()
LaneClear()
JungleClear()
AutoLevelUp()
local unit = GetCurrentTarget()
if GoS:ValidTarget(unit, 1400) then
if IOW:Mode() == "Combo" then
Ferocyti()

-- Rengar E
	if Rengar.Combo.E:Value() then
		-- GetPredictionForPlayer(startPosition, targetUnit, targetUnitMoveSpeed, spellTravelSpeed, spellDelay, spellRange, spellWidth, collision, addHitBox)
		local EPred = GetPredictionForPlayer(GoS:myHeroPos(),unit,GetMoveSpeed(unit),1500,250,1000,70,true,true)
			if GetCurrentMana(myHero) ~= 5 then
				if CanUseSpell(myHero, _E) == READY and EPred.HitChance == 1 then
					CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
				end
			end
		end
	end
-- Rengar Q
	if Rengar.Combo.Q:Value() then
		if GetCurrentMana(myHero) ~= 5 then
			if CanUseSpell(myHero, _Q) == READY and GoS:IsInDistance(unit, GetCastRange(myHero,_Q)) then
				CastSpell(_Q)
			end
		end
	end
-- Rengar W
	if Rengar.Combo.W:Value() then
		if GetCurrentMana(myHero) ~= 5 then
			if CanUseSpell(myHero, _W) == READY and GoS:IsInDistance(unit, 350) then
				CastSpell(_W)
			end
		end
	end
end
end)

-- 5 mana Logic function
function Ferocyti()
local hp = GetCurrentHP(myHero)
local maxhp = GetMaxHP(myHero)
local unit = GetCurrentTarget()
if GoS:ValidTarget(unit, 1400) then

-- Rengar E
	if Rengar.Combo.E:Value() and (hp/maxhp) > 0.4 and (GetCurrentHP(unit)/GetMaxHP(unit)) > 0.3 and not GoS:IsInDistance(unit, GetCastRange(myHero, _Q)) and GetCurrentMana(myHero) == 5 then
		local EPred = GetPredictionForPlayer(GoS:myHeroPos(),unit,GetMoveSpeed(unit),1500,250,1000,70,true,true)
			if CanUseSpell(myHero, _E) == READY and EPred.HitChance == 1 then
				CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
			end
		end
	end
-- Rengar Q
	if Rengar.Combo.Q:Value() and (hp/maxhp) > 0.4 and (GetCurrentHP(unit)/GetMaxHP(unit)) < 0.3 and GetCurrentMana(myHero) == 5 then
		if CanUseSpell(myHero, _Q) == READY and GoS:IsInDistance(unit, GetCastRange(myHero, _Q)) then
			CastSpell(_Q)
		end
	end
end

-- AutoHeal with W when 5 mana and if it have Valid Target / Logic
function AutoHeal()
local hp = GetCurrentHP(myHero)
local maxhp = GetMaxHP(myHero)
local unit = GetCurrentTarget()
if GoS:ValidTarget(unit, 1200) then

-- Rengar Auto W with Logic
if GetCurrentHP(unit)/GetMaxHP(unit) < 0.3 and GoS:IsInDistance(unit, GetCastRange(myHero, _Q)) then return end
	if Rengar.Misc.AT:Value() and GetCurrentMana(myHero) == 5 then
		if CanUseSpell(myHero, _W) == READY and (hp/maxhp) < 0.4 then
			CastSpell(_W)
		end
	end
end
end
end

function DrawDamage()
local unit = GetCurrentTarget()
if GoS:ValidTarget(unit, 1400) then

local Qdmg =  GoS:CalcDamage(myHero, unit, 0,  (math.max((30*GetCastLevel(myHero,_Q)+(.05*GetCastLevel(myHero,_Q)-.05)*GetBaseDamage(myHero)),(math.min(15*GetLevel(myHero)+15,10*GetLevel(myHero)+60)+.5*GetBaseDamage(myHero)))))
	if CanUseSpell(myHero,_Q) == READY and Rengar.Misc.DrawDMG.Q:Value() then
		DrawDmgOverHpBar(unit,GetCurrentHP(unit),Qdmg,0,0xff00ff00)
	end

local Wdmg =  GoS:CalcDamage(myHero, unit, 0,  (math.max((30*GetCastLevel(myHero,_W)+20+.8*GetBonusAP(myHero)),(math.min(15*GetLevel(myHero)+25,math.max(145,10*GetLevel(myHero)+60))+.8*GetBonusAP(myHero)))))
	if CanUseSpell(myHero,_W) == READY and Rengar.Misc.DrawDMG.W:Value() then
		DrawDmgOverHpBar(unit,GetCurrentHP(unit),Wdmg,0,0xff00ff00)
	end

local Edmg = GoS:CalcDamage(myHero, unit, 0,  (math.max((50*GetCastLevel(myHero,_E)+.7*GetBonusDmg(myHero)),(math.min(25*GetLevel(myHero)+25,10*GetLevel(myHero)+160)+.7*GetBonusDmg(myHero)))))
	if CanUseSpell(myHero,_E) == READY and Rengar.Misc.DrawDMG.E:Value() then
		DrawDmgOverHpBar(unit,GetCurrentHP(unit),Edmg,0,0xff00ff00)
	end
end
end

function Drawings()
myHeroPos = GoS:myHeroPos()
if CanUseSpell(myHero, _W) == READY and Rengar.Misc.Range.DrawW:Value() then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_W),3,100,0xFF00FF00) end
if CanUseSpell(myHero, _E) == READY and Rengar.Misc.Range.DrawE:Value() then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_E),3,100,0xFFFFFFFF) end
end
-- LaneClear func
function LaneClear()
if Rengar.LaneClear.LC:Value() then
	if Rengar.LaneClear.LClear:Value() then

		for _,M in pairs(GoS:GetAllMinions(MINION_ENEMY)) do

			local minionPos = GetOrigin(M)

				if CanUseSpell(myHero, _Q) == READY and Rengar.LaneClear.Q3:Value() and GoS:ValidTarget(M, 125) then
				CastSpell(_Q)
				end

				if CanUseSpell(myHero, _W) == READY and Rengar.LaneClear.W3:Value() and GoS:ValidTarget(M, 350) then
				CastSpell(_W)
				end

				if CanUseSpell(myHero, _E) == READY and Rengar.LaneClear.E3:Value() and GoS:ValidTarget(M, 1000) then
				CastSkillShot(_E, minionPos.x, minionPos.y, minionPos.z)
				end

		end
	end
end
end
-- Jungle Clear func
function JungleClear()
if Rengar.Jungle.Jung:Value() then
	if GetCurrentMana(myHero) == 5 and (GetCurrentHP(myHero)/GetMaxHP(myHero)) < 0.4 and CanUseSpell(myHero, _W) == READY then
	CastSpell(_W)
	elseif (GetCurrentHP(myHero)/GetMaxHP(myHero)) > 0.4 or (GetCurrentHP(myHero)/GetMaxHP(myHero)) < 0.4 and GetCurrentMana(myHero) ~= 5 or GetCurrentMana(myHero) == 5 then
		for _,J in pairs(GoS:GetAllMinions(MINION_JUNGLE)) do

			local JminionPos = GetOrigin(J)

				if CanUseSpell(myHero, _Q) == READY and Rengar.Jungle.Q2:Value() and GoS:ValidTarget(J, 200) then
				CastSpell(_Q)
				end

				if CanUseSpell(myHero, _W) == READY and Rengar.Jungle.W2:Value() and GoS:ValidTarget(J, 350) then
				CastSpell(_W)
				end

				if CanUseSpell(myHero, _E) == READY and Rengar.Jungle.E2:Value() and GoS:ValidTarget(J, 1000) then
				CastSkillShot(_E, JminionPos.x, JminionPos.y, JminionPos.z)
				end
		end
	end
end
end


-- Level Up func
function AutoLevelUp()

	if Rengar.Misc.Auto.AutoL:Value() then

		if Rengar.Misc.Auto.ALJung:Value() then

		   if GetLevel(myHero) == 1 then
			LevelSpell(_Q)
			elseif GetLevel(myHero) == 2 then
			LevelSpell(_E)
			elseif GetLevel(myHero) == 3 then
			LevelSpell(_W)
			elseif GetLevel(myHero) == 4 then
			LevelSpell(_Q)
			elseif GetLevel(myHero) == 5 then
			LevelSpell(_Q)
			elseif GetLevel(myHero) == 6 then
			LevelSpell(_R)
			elseif GetLevel(myHero) == 7 then
			LevelSpell(_Q)
			elseif GetLevel(myHero) == 8 then
			LevelSpell(_E)
			elseif GetLevel(myHero) == 9 then
			LevelSpell(_Q)
			elseif GetLevel(myHero) == 10 then
			LevelSpell(_E)
			elseif GetLevel(myHero) == 11 then
			LevelSpell(_R)
			elseif GetLevel(myHero) == 12 then
			LevelSpell(_E)
			elseif GetLevel(myHero) == 13 then
			LevelSpell(_E)
			elseif GetLevel(myHero) == 14 then
			LevelSpell(_W)
			elseif GetLevel(myHero) == 15 then
			LevelSpell(_W)
			elseif GetLevel(myHero) == 16 then
			LevelSpell(_R)
			elseif GetLevel(myHero) == 17 then
			LevelSpell(_W)
			elseif GetLevel(myHero) == 18 then
			LevelSpell(_W)
			end
		end

		if Rengar.Misc.Auto.ALTop:Value() then
			if GetLevel(myHero) == 1 then
			LevelSpell(_Q)
			elseif GetLevel(myHero) == 2 then
			LevelSpell(_W)
			elseif GetLevel(myHero) == 3 then
			LevelSpell(_E)
			elseif GetLevel(myHero) == 4 then
			LevelSpell(_Q)
			elseif GetLevel(myHero) == 5 then
			LevelSpell(_Q)
			elseif GetLevel(myHero) == 6 then
			LevelSpell(_R)
			elseif GetLevel(myHero) == 7 then
			LevelSpell(_Q)
			elseif GetLevel(myHero) == 8 then
			LevelSpell(_E)
			elseif GetLevel(myHero) == 9 then
			LevelSpell(_Q)
			elseif GetLevel(myHero) == 10 then
			LevelSpell(_E)
			elseif GetLevel(myHero) == 11 then
			LevelSpell(_R)
			elseif GetLevel(myHero) == 12 then
			LevelSpell(_E)
			elseif GetLevel(myHero) == 13 then
			LevelSpell(_E)
			elseif GetLevel(myHero) == 14 then
			LevelSpell(_W)
			elseif GetLevel(myHero) == 15 then
			LevelSpell(_W)
			elseif GetLevel(myHero) == 16 then
			LevelSpell(_R)
			elseif GetLevel(myHero) == 17 then
			LevelSpell(_W)
			elseif GetLevel(myHero) == 18 then
			LevelSpell(_W)
			end
		end

	end
end

