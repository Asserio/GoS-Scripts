if GetObjectName(GetMyHero()) == "Akali" then
-- Menu
Config = scriptConfig("IAkali", "Akali")
Config.addParam("Q", "Use Akali Q", SCRIPT_PARAM_ONOFF, true)
Config.addParam("w", "Use Akali w", SCRIPT_PARAM_ONOFF, true)
Config.addParam("E", "Use Akali E", SCRIPT_PARAM_ONOFF, true)
Config.addParam("R", "Use Akali R", SCRIPT_PARAM_ONOFF, true)
DrawConfig = scriptConfig("DrawDMG", "Dmg Draw")
DrawConfig.addParam("Q", "Draw Q Dmg", SCRIPT_PARAM_ONOFF, true)
DrawConfig.addParam("E", "Draw E Dmg", SCRIPT_PARAM_ONOFF, true)
DrawConfig.addParam("R", "Draw R Dmg", SCRIPT_PARAM_ONOFF, true)
DrawingsConfig = scriptConfig("Drawings", "Drawings")
DrawingsConfig.addParam("DrawQ","Draw Q", SCRIPT_PARAM_ONOFF, true)
DrawingsConfig.addParam("DrawR","Draw R", SCRIPT_PARAM_ONOFF, true)
KSConfig = scriptConfig("KS", "Killsteal:")
KSConfig.addParam("KSR", "Killsteal with R", SCRIPT_PARAM_ONOFF, false)
-- PrintChat
local info = "Evolved Akali Loaded"
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
AutoIgnite()
Killsteal()
DrawDamage()
Drawings()
if IWalkConfig.Combo then
local unit = GetCurrentTarget()
if ValidTarget(unit, 1400) then

-- Akali Q
if CanUseSpell(myHero, _Q) == READY and IsInDistance(unit, GetCastRange(myHero, _Q)) then
CastTargetSpell(unit, _Q)
end
-- Akali R
if CanUseSpell(myHero, _R) == READY and IsInDistance(unit, GetCastRange(myHero, _R)) then
CastTargetSpell(unit, _R)
end
-- Akali E
if CanUseSpell(myHero, _E) == READY and IsInDistance(unit, GetCastRange(myHero, _E)) then
CastTargetSpell(myHero, _E)
end

end
end
end)

function DrawDamage()
local unit = GetCurrentTarget()
if ValidTarget(unit, 1400) then
local Qdmg = CalcDamage(myHero, unit, 0,  (math.max((20*GetCastLevel(myHero,_Q)+15+.4*GetBonusAP(myHero)),(25*GetCastLevel(myHero,_Q)+20+.5*GetBonusAP(myHero)),(45*GetCastLevel(myHero,_Q)+35+.9*GetBonusAP(myHero)))))
	if CanUseSpell(myHero,_Q) == READY and DrawConfig.Q then
		DrawDmgOverHpBar(unit,GetCurrentHP(unit),Qdmg,0,0xff00ff00)
	end

local Edmg =  CalcDamage(myHero, unit, 0,  (25*GetCastLevel(myHero,_E)+5+.3*GetBonusAP(myHero)+.6*GetBaseDamage(myHero)))
	if CanUseSpell(myHero,_E) == READY and DrawConfig.E then
		DrawDmgOverHpBar(unit,GetCurrentHP(unit),Edmg,0,0xff00ff00)
	end

local Rdmg = CalcDamage(myHero, unit, 0,  (75*GetCastLevel(myHero,_R)+25+.5*GetBonusAP(myHero)))
	if CanUseSpell(myHero,_R) == READY and DrawConfig.R then
		DrawDmgOverHpBar(unit,GetCurrentHP(unit),Rdmg,0,0xff00ff00)
	end
end
end

function Killsteal()
        for i,enemy in pairs(GetEnemyHeroes()) do
            if CanUseSpell(myHero, _R) == READY and ValidTarget(enemy,GetCastRange(myHero,_R)) and KSConfig.KSR and GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, (75*GetCastLevel(myHero,_R)+25+.5*GetBonusAP(myHero))) then
		CastTargetSpell(enemy, _R)
            end
        end
end

function Drawings()
myHeroPos = GetOrigin(myHero)
if CanUseSpell(myHero, _Q) == READY and DrawingsConfig.DrawQ then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_Q),3,100,0xFFFF7F7F) end
if CanUseSpell(myHero, _R) == READY and DrawingsConfig.DrawR then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_R),3,100,0xFFCC0000) end
end
end
