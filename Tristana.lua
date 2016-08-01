if GetObjectName(GetMyHero()) == "Tristana" then
-- Keys
Config = scriptConfig("ITristana", "Tristana.lua")
Config.addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
Config.addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
Config.addParam("R", "Use R", SCRIPT_PARAM_ONOFF, true)
-- Damage Draw
DrawConfig = scriptConfig("DrawDMG", "Dmg Draw")
DrawConfig.addParam("E", "Draw E Dmg", SCRIPT_PARAM_ONOFF, true)
DrawConfig.addParam("R", "Draw R Dmg", SCRIPT_PARAM_ONOFF, true)
-- Range Draw
DrawingsConfig = scriptConfig("Drawings", "Drawings")
DrawingsConfig.addParam("DrawW","Draw W", SCRIPT_PARAM_ONOFF, true)
DrawingsConfig.addParam("DrawE","Draw E", SCRIPT_PARAM_ONOFF, true)
DrawingsConfig.addParam("DrawR","Draw R", SCRIPT_PARAM_ONOFF, true)
-- Auto R
AutoRConfig = scriptConfig("AT", "Auto R")
AutoRConfig.addParam("R", "Auto R", SCRIPT_PARAM_ONOFF, true)
-- PrintChat
---Credits to TheWelder. I Actualy liked this very much so i will use it here. Hope the Welder doesn't get mad.
local info = "Evolved Tristana Loaded"
local upv = "Upvote if you like it!"
local sig = "Made by Asserio"
local ver = "v 1.0"
textTable = {info,upv,sig,ver}
PrintChat(textTable[1])
PrintChat(textTable[2])
PrintChat(textTable[3])
PrintChat(textTable[4])

-- This is done every mil second
OnLoop(function(myHero)
AutoIgnite()
DrawDamage()
Drawings()
Killsteal()
if IWalkConfig.Combo then
local unit = GetCurrentTarget()
if ValidTarget(unit, 1000) then
-- Use Tristana E
	if Config.E then
		if CanUseSpell(myHero, _E) == READY and IsInDistance(unit, GetCastRange(myHero, _E)) then
		CastTargetSpell(unit, _E)
		end
	end
-- Use Tristana Q
	if Config.Q then
		if CanUseSpell(myHero, _Q) == READY and CanUseSpell(myHero, _W) ~= READY and IsInDistance(unit, GetRange(myHero)) then
		CastTargetSpell(myHero, _Q)
		end
	end

--[[ LanceClear Not Working ATM
if IWalkConfig.Laneclear then
	if Config.Q then
		if CanUseSpell(myHero, _Q) == READY then
		CastSpell(myHero, _Q)
end
		end
	end]]

end
end
end)

function DrawDamage()
local unit = GetCurrentTarget()
if ValidTarget(unit, 1400) then

local Edmg =  CalcDamage(myHero, unit, 0,  (math.max((45*GetCastLevel(myHero,_E)+35+GetBonusAP(myHero)),(25*GetCastLevel(myHero,_E)+25+.25*GetBonusAP(myHero)))))
	if CanUseSpell(myHero,_E) == READY and DrawConfig.E then
		DrawDmgOverHpBar(unit,GetCurrentHP(unit),Edmg,0,0xff00ff00)
	end

local Rdmg = CalcDamage(myHero, unit, 0,  (100*GetCastLevel(myHero,_R)+200+1.5*GetBonusAP(myHero)))
	if CanUseSpell(myHero,_R) == READY and DrawConfig.R then
		DrawDmgOverHpBar(unit,GetCurrentHP(unit),Rdmg,0,0xff00ff00)
	end
end
end

function Drawings()
myHeroPos = GetOrigin(myHero)
if CanUseSpell(myHero, _W) == READY and DrawingsConfig.DrawW then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_W),3,100,0xFF00FF00) end
if CanUseSpell(myHero, _E) == READY and DrawingsConfig.DrawE then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_E),3,100,0xFFFFFFFF) end
if CanUseSpell(myHero, _R) == READY and DrawingsConfig.DrawR then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_R),3,100,0xFFCC0000) end
end

function Killsteal()
        for i,enemy in pairs(GetEnemyHeroes()) do
      -- GetPredictionForPlayer(startPosition, targetUnit, targetUnitMoveSpeed, spellTravelSpeed, spellDelay, spellRange, spellWidth, collision, addHitBox)
            if CanUseSpell(myHero, _R) == READY and ValidTarget(enemy,GetCastRange(myHero,_R)) and AutoRConfig.R and GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0,  (100*GetCastLevel(myHero,_R)+200+1.5*GetBonusAP(myHero))) then
    CastTargetSpell(enemy, _R)
            end
        end
end
end






