if GetObjectName(GetMyHero()) == "Elise" then
-- Menu
Config = scriptConfig("IElise", "Elise.lua")
Config.addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
Config.addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
Config.addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
Config.addParam("R", "Use R", SCRIPT_PARAM_ONOFF, true)

OnLoop(function(myHero)
AutoIgnite()
DrawText("Evolved Elise is Loaded",24,0,0,0xffff0000);
if IWalkConfig.Combo then
local unit = GetCurrentTarget()
if ValidTarget(unit, 1200) then

	if GetCastName(myHero, _E) == "EliseHumanE" then
	-- GetPredictionForPlayer(startPosition, targetUnit, targetUnitMoveSpeed, spellTravelSpeed, spellDelay, spellRange, spellWidth, collision, addHitBox)
	local EPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1600,250,1100,55,true,true)
	if Config.E then
	if CanUseSpell(myHero, _E) == READY and EPred.HitChance == 1 then
	CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
	end
	end
	end

	if GetCastName(myHero, _W) == "EliseHumanW" then
	local WPred = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),1600,250,950,55,true,true)
	if Config.W then
	if CanUseSpell(myHero, _W) == READY and WPred.HitChance == 1 then
	CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
	end
	end
	end

	if GetCastName(myHero, _Q) == "EliseHumanQ" then
	if Config.Q then
	if CanUseSpell(myHero, _Q) == READY and IsInDistance(unit, 625) then
	CastTargetSpell(unit, _Q)
	end
	end
	end

	if GetCastName(myHero, _R) == "EliseR" then
	if Config.R then
	if unit ~= nil then
	if CanUseSpell(myHero, _R) == READY and CanUseSpell(myHero, _E) ~= READY and CanUseSpell(myHero, _W) ~= READY and CanUseSpell(myHero, _Q) ~= READY then
	CastTargetSpell(myHero, _R)
	end
	end
	end
	end

	if GetCastName(myHero, _E) == "EliseSpiderEInitial" then
	if Config.E then
	if CanUseSpell(myHero, _E) == READY and IsInDistance(unit, 750) then
	CastTargetSpell(unit, _E)
	end
	end
	end

	if GetCastName(myHero, _W) == "EliseSpiderW" then
	if Config.W then
	if CanUseSpell(myHero, _W) == READY and IsInDistance(unit, 200) then
	CastTargetSpell(myHero, _W)
	end
	end
	end

	if GetCastName(myHero, _Q) == "EliseSpiderQCast" then
	if Config.Q then
	if CanUseSpell(myHero, _Q) == READY and IsInDistance(unit, 475) then
	CastTargetSpell(unit, _Q)
	end
	end
	end

	if GetCastName(myHero, _R) == "EliseRSpider" then
	if Config.R then
	if unit ~= nil then
	if CanUseSpell(myHero, _R) == READY and CanUseSpell(myHero, _E) ~= READY and CanUseSpell(myHero, _W) ~= READY and CanUseSpell(myHero, _Q) ~= READY then
	CastSpell(_R)
	end
	end
	end
	end

end
end
end)
