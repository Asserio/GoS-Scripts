if GetObjectName(myHero) ~= "DrMundo" then return end
-- Keys
DrMundo = Menu("DrMundo", "DrMundo")
-- Combo menu
DrMundo:SubMenu("Combo", "Combo")
DrMundo.Combo:Boolean("Q", "Use Q", true)
DrMundo.Combo:Boolean("W", "Use W", true)
DrMundo.Combo:Boolean("E", "Use E", true)
-- Automatic
DrMundo:SubMenu("AU", "Automatic")
DrMundo.AU:Slider("UltHP", "Hp to Auto R", 50, 0, 100, 1)
DrMundo.AU:Boolean("R", "Use Auto R", true)
-- Killsteal
DrMundo:SubMenu("KS", "Killsteal")
DrMundo.KS:Boolean("KSQ", "Killsteal with Q", true)
-- Draw Range
DrMundo:SubMenu("Drawings", "Drawings")
DrMundo.Drawings:Boolean("DrawQ","Draw Q", true)
-- PrintChat
local info = "Evolved DrMundo Loaded"
local upv = "Upvote if you like it!"
local sig = "Made by Asserio"
local ver = "v 1.0"
textTable = {info,upv,sig,ver}
PrintChat(textTable[1])
PrintChat(textTable[2])
PrintChat(textTable[3])
PrintChat(textTable[4])
-- Start
OnLoop(function(myHero)
Killsteal()
AutoUltimate()
Drawings()
if IOW:Mode() == "Combo" then
WTurnOff()
local unit = GetCurrentTarget()
if GoS:ValidTarget(unit, 1300) then

-- Dr.Mundo Q
	-- GetPredictionForPlayer(startPosition, targetUnit, targetUnitMoveSpeed, spellTravelSpeed, spellDelay, spellRange, spellWidth, collision, addHitBox)
local QPred = GetPredictionForPlayer(GoS:myHeroPos(),unit,GetMoveSpeed(unit),2000,250,1050,60,true,true)
	if DrMundo.Combo.Q:Value() then
		if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 then
	CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
		end
	end
-- Dr.Mundo W
if DrMundo.Combo.W:Value() then
	if GotBuff(myHero, "BurningAgony") ~= 1 then
	if CanUseSpell(myHero, _W) == READY and GoS:IsInDistance(unit, GetCastRange(myHero, _W)) then
	CastTargetSpell(myHero, _W)
	end
end

-- Dr.Mundo E
if DrMundo.Combo.E:Value() then
	if CanUseSpell(myHero, _E) == READY and GoS:IsInDistance(unit, 200) then
	CastTargetSpell(myHero, _E)
	end
end

end
end
end
end)


function AutoUltimate()
	local hp = GetCurrentHP(myHero)
	local maxHP = GetMaxHP(myHero)

	if DrMundo.AU.R:Value() then
	if GotBuff(myHero, "recall") ~= 1 then
		if CanUseSpell(myHero, _R) == READY and GoS:EnemiesAround(GoS:myHeroPos(), 600) >= 1 and (hp/maxHP)*100 < DrMundo.AU.UltHP:Value() then
	CastTargetSpell(myHero, _R)
		end
	end
	end

end

function Killsteal()
        for i,enemy in pairs(GoS:GetEnemyHeroes()) do
			-- GetPredictionForPlayer(startPosition, targetUnit, targetUnitMoveSpeed, spellTravelSpeed, spellDelay, spellRange, spellWidth, collision, addHitBox)
local QPred = GetPredictionForPlayer(GoS:myHeroPos(),enemy,GetMoveSpeed(enemy),2000,250,GetCastRange(myHero,_Q),60,true,true)
            if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and GoS:ValidTarget(enemy,GetCastRange(myHero,_Q)) and DrMundo.KS.KSQ:Value() and GetCurrentHP(enemy) < GoS:CalcDamage(myHero, enemy, 0, (2.5*GetCastLevel(myHero,_Q)+12.5)*GetCurrentHP(enemy)/100 + 50*GetCastLevel(myHero, _Q)+30) then
		CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
            end
        end
end


function WTurnOff()
	local unit = GetCurrentTarget()
	if GoS:ValidTarget(unit, 1400) then

-- W Turn off logic
if DrMundo.Combo.W:Value() then
	if GotBuff(myHero, "BurningAgony") == 1 then
	if CanUseSpell(myHero, _W) == READY and not GoS:IsInDistance(unit, GetCastRange(myHero, _W)) or GoS:ValidTarget(unit, GetCastRange(myHero,_W)) == nil then
		CastTargetSpell(myHero, _W)
	end
	end
end


end
end

-- Range Drawing
function Drawings()
myHeroPos = GoS:myHeroPos()
if CanUseSpell(myHero, _Q) == READY and DrMundo.Drawings.DrawQ:Value() then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_Q),3,100,0xFFFF7F7F) end
end
