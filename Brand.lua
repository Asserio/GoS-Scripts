if GetObjectName(GetMyHero()) ~= "Brand" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua!") return end

-- Combo Menu
BrandMenu = Menu("Brand", "Brand")
BrandMenu:SubMenu("Combo", "Combo")
BrandMenu.Combo:Boolean("Q", "Use Brand Q", true)
BrandMenu.Combo:Boolean("W", "Use Brand W", true)
BrandMenu.Combo:Boolean("E", "Use Brand E", true)
-- Harass Menu
BrandMenu:SubMenu("Harass", "Harass")
BrandMenu.Harass:Boolean("Q", "Use Q", true)
BrandMenu.Harass:Boolean("W", "Use W", true)
-- R Settings
BrandMenu:SubMenu("RSettings", "R Settings")
BrandMenu.RSettings:Boolean("R", "R when Champ?", true)
BrandMenu.RSettings:Boolean("R2", "R If Kileable", true)
BrandMenu.RSettings:Slider("Champs", "Champ to use R", 2, 2, 5, 1)
-- Range Draw
BrandMenu:SubMenu("Drawings", "Drawings")
BrandMenu.Drawings:Boolean("Q","Draw Q",  true)
BrandMenu.Drawings:Boolean("W","Draw W",  true)
BrandMenu.Drawings:Boolean("E","Draw E",  true)
BrandMenu.Drawings:Boolean("R","Draw R",  true)
-- PrintChat
local info = "Evolved Brand Loaded"
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
Killsteal()
local unit = GetCurrentTarget()
if ValidTarget(unit, 1100) then
if IOW:Mode() == "Combo" then


-- Brand E
	if BrandMenu.Combo.E:Value() then
		if CanUseSpell(myHero, _E) == READY and ValidTarget(unit, GetCastRange(myHero, _E)) then
	CastTargetSpell(unit, _E)
		end
	end

-- Brand Q
	-- GetPredictionForPlayer(startPosition, targetUnit, targetUnitMoveSpeed, spellTravelSpeed, spellDelay, spellRange, spellWidth, collision, addHitBox)
local QPred = GetPredictionForPlayer(myHeroPos(),unit,GetMoveSpeed(unit),1600,250,1100,60,true,true)
	if BrandMenu.Combo.Q:Value() then
		if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and GotBuff(unit, "BrandAblaze") == 1 then
	CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
		end
	end

-- Brand W
	-- GetPredictionForPlayer(startPosition, targetUnit, targetUnitMoveSpeed, spellTravelSpeed, spellDelay, spellRange, spellWidth, collision, addHitBox)
local WPred = GetPredictionForPlayer(myHeroPos(),unit,GetMoveSpeed(unit),math.huge,850,900,240,false,true)
	if BrandMenu.Combo.W:Value() then
		if CanUseSpell(myHero, _W) == READY and WPred.HitChance == 1 then
	CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
		end
	end

-- Brand R
	if BrandMenu.RSettings.R:Value() then
		if CanUseSpell(myHero, _R) == READY and EnemiesAround(myHeroPos(), 750) >= BrandMenu.RSettings.Champs:Value()  then
		CastTargetSpell(unit, _R)
		end
	end
end


if IOW:Mode() == "Harass" then

-- Brand Q
	-- GetPredictionForPlayer(startPosition, targetUnit, targetUnitMoveSpeed, spellTravelSpeed, spellDelay, spellRange, spellWidth, collision, addHitBox)
local QPred = GetPredictionForPlayer(myHeroPos(),unit,GetMoveSpeed(unit),1600,250,1100,60,true,true)
	if BrandMenu.Harass.Q:Value() then
		if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 then
	CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
		end
	end


-- Brand W
	-- GetPredictionForPlayer(startPosition, targetUnit, targetUnitMoveSpeed, spellTravelSpeed, spellDelay, spellRange, spellWidth, collision, addHitBox)
local WPred = GetPredictionForPlayer(myHeroPos(),unit,GetMoveSpeed(unit),math.huge,850,900,240,false,true)
	if BrandMenu.Harass.W:Value() then
		if CanUseSpell(myHero, _W) == READY and WPred.HitChance == 1 then
	CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
		end
	end
end
end
end)

function Killsteal()
        for i,enemy in pairs(GetEnemyHeroes()) do
      -- GetPredictionForPlayer(startPosition, targetUnit, targetUnitMoveSpeed, spellTravelSpeed, spellDelay, spellRange, spellWidth, collision, addHitBox)
            if CanUseSpell(myHero, _R) == READY and ValidTarget(enemy, 750) and BrandMenu.RSettings.R2:Value() and GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0,  (math.max(100*GetCastLevel(myHero,_R)+50+.5*GetBonusAP(myHero),(100*GetCastLevel(myHero,_R)+50+.5*GetBonusAP(myHero))*3))) then
    CastTargetSpell(enemy, _R)
            end
        end
end

-- Range Drawing
OnDraw(function(myHero)
if CanUseSpell(myHero, _Q) == READY and BrandMenu.Drawings.Q:Value() then DrawCircle(myHeroPos().x,myHeroPos().y,myHeroPos().z,GetCastRange(myHero,_Q),3,100,0xFFFF7F7F) end
if CanUseSpell(myHero, _W) == READY and BrandMenu.Drawings.W:Value() then DrawCircle(myHeroPos().x,myHeroPos().y,myHeroPos().z,GetCastRange(myHero,_W),3,100,0xFF00FF00) end
if CanUseSpell(myHero, _E) == READY and BrandMenu.Drawings.E:Value() then DrawCircle(myHeroPos().x,myHeroPos().y,myHeroPos().z,GetCastRange(myHero,_E),3,100,0xFFFFFFFF) end
if CanUseSpell(myHero, _R) == READY and BrandMenu.Drawings.R:Value() then DrawCircle(myHeroPos().x,myHeroPos().y,myHeroPos().z,GetCastRange(myHero,_R),3,100,0xFFCC0000) end
end)
