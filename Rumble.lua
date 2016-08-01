if GetObjectName(myHero) ~= "Rumble" then return end
-- Menu
Rumble = Menu("Rumble", "Rumble")
-- Combo
Rumble:SubMenu("Combo", "Combo")
Rumble.Combo:Boolean("Q", "Use Q", true)
Rumble.Combo:Boolean("W", "Use W", true)
Rumble.Combo:Boolean("E", "Use E", true)
Rumble.Combo:Boolean("R", "Use R", true)
-- Harass
Rumble:SubMenu("Harass", "Harass")
Rumble.Harass:Boolean("E", "Use Rumble E", true)
-- Killsteal menu
Rumble:SubMenu("Ks", "Killsteal")
Rumble.Ks:Boolean("E", "Use E", true)
Rumble.Ks:Boolean("R", "Use R", false)
-- Range Drawings
Rumble:SubMenu("Draw", "Range Draw")
Rumble.Draw:Boolean("E", "Draw E", true)
Rumble.Draw:Boolean("R", "Draw R", true)
-- Rumble LaneClear
Rumble:SubMenu("Lc", "LaneClear")
Rumble.Lc:Boolean("Q", "Use Q", true)
Rumble.Lc:Boolean("E", "Use E", true)
-- Rumble Jungle Clear
Rumble:SubMenu("Jc", "Jungle Clear")
Rengar.Jc:Key("JClear", "Jungle Clear", string.byte("V"))
Rumble.Jc:Boolean("Q", "Use Q", true)
Rumble.Jc:Boolean("E", "Use E", true)
-- Start
OnLoop(function(myHero)
Killsteal()
Drawings()
JungleClear()

local unit = GetCurrentTarget()
if GoS:ValidTarget(unit, 1100) then
if IOW:Mode() == "Harass" then
	-- GetPredictionForPlayer(startPosition, targetUnit, targetUnitMoveSpeed, spellTravelSpeed, spellDelay, spellRange, spellWidth, collision, addHitBox)
local EPred = GetPredictionForPlayer(GoS:myHeroPos(),unit,GetMoveSpeed(unit),2000,250,950,60,true,true)
	if Rumble.Harass.E:Value() then
		if CanUseSpell(myHero, _E) == READY and EPred.HitChance == 1 then
	CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
		end
	end
end

if IOW:Mode() == "Combo" then
local RPred = GetPredictionForPlayer(GoS:myHeroPos(),unit,GetMoveSpeed(unit),1600,400,1200,200,false,true)
local myHeroPos = GoS:myHeroPos()
local StartPos = Vector(myHero) - 525 * (Vector(myHero) - Vector(unit)):normalized()

-- Q
if CanUseSpell(myHero, _Q) == READY and GoS:IsInDistance(unit, GetCastRange(myHero,_Q)) and Rumble.Combo.Q:Value() then
CastSpell(myHero, _Q)
end

-- Q + E
if Rumble.Combo.E:Value() and Rumble.Combo.Q:Value() then
if CanUseSpell(myHero, _Q) == READY and CanUseSpell(myHero, _E) == READY and GoS:IsInDistance(unit, GetCastRange(myHero,_Q)) then
CastSpell(myHero,_Q)
elseif CanUseSpell(myHero, _E) == READY and CanUseSpell(myHero, _Q) ~= READY and not GoS:IsInDistance(unit, GetCastRange(myHero,_Q)) and EPred.HitChance == 1 then
CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
end
end

-- W + Q + E
if Rumble.Combo.Q:Value() and Rumble.Combo.W:Value() then
if CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero, _W) == READY and not GoS:IsInDistance(unit, GetCastRange(myHero,_Q)) then
CastSpell(myHero,_W)
elseif CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_W) ~= READY and GoS:IsInDistance(unit, GetCastRange(myHero,_Q)) then
CastSpell(myHero,_Q)
elseif CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_E) == READY and GoS:IsInDistance(unit, GetCastRange(myHero,_E)) and not GoS:IsInDistance(unit, GetCastRange(myHero,_Q)) and EPred.HitChance == 1 then
CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
end
end

-- W + E
if Rumble.Combo.E:Value() and Rumble.Combo.W:Value() then
if CanUseSpell(myHero, _E) == READY and CanUseSpell(myHero, _W) == READY and not GoS:IsInDistance(unit, 850) then
CastSpell(myHero, _W)
elseif CanUseSpell(myHero, _E) == READY and CanUseSpell(myHero, _W) ~= READY and GoS:IsInDistance(unit, GetCastRange(myHero,_E)) and EPred.HitChance == 1 then
CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
end
end

-- R + W + E or E + R
if Rumble.Combo.E:Value() and Rumble.Combo.R:Value() and Rumble.Combo.W:Value() then
if CanUseSpell(myHero, _E) == READY and CanUseSpell(myHero, _R) == READY and CanUseSpell(myHero, _W) == READY and GoS:IsInDistance(unit, GetCastRange(myHero, _R)) and not GoS:IsInDistance(unit, GetCastRange(myHero, _E)) and RPred.HitChance == 1 then
CastSkillShot3(_R,StartPos,RPred.PredPos)
elseif CanUseSpell(myHero, _E) == READY and CanUseSpell(myHero, _W) == READY and CanUseSpell(myHero, _R) ~= READY and not GoS:IsInDistance(unit, GetCastRange(myHero,_E)) then
CastSpell(myHero,_W)
elseif CanUseSpell(myHero, _E) == READY and CanUseSpell(myHero, _R) ~= READY and GoS:IsInDistance(unit, GetCastRange(myHero, _E)) and EPred.HitChance == 1 then
CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
elseif CanUseSpell(myHero, _E) == READY and CanUseSpell(myHero, _R) == READY and GoS:IsInDistance(unit, GetCastRange(myHero, _E)) and EPred.HitChance == 1 and RPred.HitChance == 1 then
CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
CastSkillShot3(_R,StartPos,RPred.PredPos)
end
end


end
end
end)

function Killsteal()
local unit = GetCurrentTarget()

local EPred = GetPredictionForPlayer(GoS:myHeroPos(),unit,GetMoveSpeed(unit),2000,250,950,60,true,true)
local RPred = GetPredictionForPlayer(GoS:myHeroPos(),unit,GetMoveSpeed(unit),1600,400,1200,200,false,true)
local myHeroPos = GoS:myHeroPos()
local StartPos = Vector(myHero) - 525 * (Vector(myHero) - Vector(unit)):normalized()
        for i,enemy in pairs(GoS:GetEnemyHeroes()) do
		if CanUseSpell(myHero, _E) == READY and GoS:ValidTarget(enemy,GetCastRange(myHero,_E)) and Rumble.Ks.E:Value() and EPred.HitChance == 1 and GetCurrentHP(enemy) < GoS:CalcDamage(myHero, enemy, 0, (25*GetCastLevel(myHero,_E)+20+0.4*GetBonusAP(myHero))) then
		CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
		elseif CanUseSpell(myHero, _R) == READY and GoS:ValidTarget(enemy,GetCastRange(myHero,_E)) and Rumble.Ks.R:Value() and RPred.HitChance == 1 and GetCurrentHP(enemy) < GoS:CalcDamage(myHero, enemy, 0, (55*GetCastLevel(myHero,_E)+75+0.3*GetBonusAP(myHero)*GetMaxHP(enemy)/100)) then
		CastSkillShot3(_R,StartPos,RPred.PredPos)
            end
        end
end

function Drawings()

myHeroPos = GoS:myHeroPos()
if CanUseSpell(myHero, _E) == READY and Rumble.Draw.E:Value() then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_E),3,100,0xFFFFFFFF) end
if CanUseSpell(myHero, _R) == READY and Rumble.Draw.R:Value() then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_R),3,100,0xFFCC0000) end
end

function JungleClear()
if Rumble.Jc.JClear:Value() then	
for _,J in pairs(GoS:GetAllMinions(MINION_JUNGLE)) do
	
	local JminionPos = GetOrigin(J)
				if CanUseSpell(myHero, _Q) == READY and Rumble.Jc.Q:Value() and GoS:ValidTarget(J, GetCastRange(myHero,_Q)) then
				CastSpell(_Q)
				end

				if CanUseSpell(myHero, _E) == READY and Rumble.Jc.E:Value() and GoS:ValidTarget(J, GetCastRange(myHero,_E)) then
				CastSkillShot(_E, JminionPos.x, JminionPos.y, JminionPos.z)
				end
end	
end
