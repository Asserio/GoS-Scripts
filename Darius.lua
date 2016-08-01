if GetObjectName(myHero) ~= "Darius" then return end

require "Inspired"
require "DamageLib"

-- Main Menu
Darius = Menu("Darius", "Darius")
-- SubMenu Combo
Darius:SubMenu("Combo", "Combo")
Darius.Combo:Boolean("Q", "Use Q", true)
Darius.Combo:Boolean("W", "Use W", true)
Darius.Combo:Boolean("E", "Use E", true)
-- SubMenu Drawings
Darius:SubMenu("Drawings", "Drawings")
-- Darius DMG Draw Menu
Darius.Drawings:SubMenu("DmgDraw", "Damage Draw")
Darius.Drawings.DmgDraw:Boolean("Q", "Draw Q Dmg", true)
Darius.Drawings.DmgDraw:Boolean("W", "Draw w Dmg", true)
Darius.Drawings.DmgDraw:Boolean("R", "Draw R Dmg", true)
-- Range Draw
Darius.Drawings:SubMenu("RangeDraw", "Range Drawings")
Darius.Drawings.RangeDraw:Boolean("DrawQ","Draw Q", true)
Darius.Drawings.RangeDraw:Boolean("DrawE","Draw E", true)
Darius.Drawings.RangeDraw:Boolean("DrawR","Draw R", true)
-- Auto ultimate
Darius:SubMenu("AT", "Automatic")
Darius.AT:Boolean("R", "Auto R", true)
-- PrintChat
local info = "Evolved Darius Loaded"
local upv = "Upvote if you like it!"
local sig = "Made by Asserio"
local ver = "v 1.0"
textTable = {info,upv,sig,ver}
PrintChat(textTable[1])
PrintChat(textTable[2])
PrintChat(textTable[3])
PrintChat(textTable[4])

OnTick(function(myHero)
Killsteal()
DrawDamage()
local unit = GetCurrentTarget()
if ValidTarget(unit, 1400) then
if IOW:Mode() == "Combo" then
local hp = GetCurrentHP(unit)
local maxHP = GetMaxHP(unit)
-- Darius E
  -- GetPredictionForPlayer(startPosition, targetUnit, targetUnitMoveSpeed, spellTravelSpeed, spellDelay, spellRange, spellWidth, collision, addHitBox)
local EPred = GetPredictionForPlayer(myHeroPos(),unit,GetMoveSpeed(unit),math.huge,300,550,80,false,true)
  if Darius.Combo.E:Value() then
    if CanUseSpell(myHero, _E) == READY and EPred.HitChance == 1 then
      CastTargetSpell(unit, _E)
    end
  end

-- Darius Q
 if Darius.Combo.Q:Value() then
 local QPred = GetPredictionForPlayer(myHeroPos(),unit,GetMoveSpeed(unit),1700,250,475,50,true,true)
                        if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and ValidTarget(unit, 475) then
                        CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
                        end
                end
-- Darius W
if Darius.Combo.W:Value() then
  if CanUseSpell(myHero, _W) == READY and ValidTarget(unit, GetRange(myHero)) then
    CastTargetSpell(myHero, _W)
  end
end



end
end
end)

function DrawDamage()
local unit = GetCurrentTarget()
if ValidTarget(unit, 1400) then
local Qdmg = CalcDamage(myHero, unit, 0,  (math.max(35*GetCastLevel(myHero,_Q)+35+.7*GetBonusDmg(myHero),(35*GetCastLevel(myHero,_Q)+35+.7*GetBonusDmg(myHero))*1.5)))
	if CanUseSpell(myHero,_Q) == READY and Darius.Drawings.DmgDraw.Q:Value() then
		DrawDmgOverHpBar(unit,GetCurrentHP(unit),Qdmg,0,0xff00ff00)
	end

local Wdmg = CalcDamage(myHero, unit, 0,  (.2*GetCastLevel(myHero,_W)*GetBaseDamage(myHero)))
	if CanUseSpell(myHero,_W) == READY and Darius.Drawings.DmgDraw.W:Value() then
		DrawDmgOverHpBar(unit,GetCurrentHP(unit),Wdmg,0,0xff00ff00)
	end

local Rdmg = getdmg("R",unit,myHero,3)
	if CanUseSpell(myHero,_R) == READY and Darius.Drawings.DmgDraw.R:Value() then
		DrawDmgOverHpBar(unit,GetCurrentHP(unit),Rdmg,0,0xff00f000)
	end
end
end

function Killsteal()
        for i,enemy in pairs(GetEnemyHeroes()) do
      -- GetPredictionForPlayer(startPosition, targetUnit, targetUnitMoveSpeed, spellTravelSpeed, spellDelay, spellRange, spellWidth, collision, addHitBox)
            if CanUseSpell(myHero, _R) == READY and ValidTarget(enemy,GetCastRange(myHero,_R)) and Darius.AT.R:Value() and GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0,  (math.max(90*GetCastLevel(myHero,_R)+70+.75*GetBonusDmg(myHero),(90*GetCastLevel(myHero,_R)+70+.75*GetBonusDmg(myHero))*2))) then
    CastTargetSpell(enemy, _R)
            end
        end
end

-- Range Drawing
OnDraw(function(myHero)
if CanUseSpell(myHero, _E) == READY and Darius.Drawings.RangeDraw.DrawE:Value() then DrawCircle(myHeroPos().x,myHeroPos().y,myHeroPos().z,GetCastRange(myHero,_E),3,100,0xFFFFFFFF) end
if CanUseSpell(myHero, _R) == READY and Darius.Drawings.RangeDraw.DrawR:Value() then DrawCircle(myHeroPos().x,myHeroPos().y,myHeroPos().z,GetCastRange(myHero,_R),3,100,0xFFCC0000) end
end)
