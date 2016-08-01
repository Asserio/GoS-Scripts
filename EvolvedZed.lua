if GetObjectName(myHero) ~= "Zed" then return end

require "Inspired"
require "OpenPredict"
require "DamageLib"

Zed = Menu("Zed","Zed")
--Combo
Zed:SubMenu("Combo","Combo")
Zed.Combo:Boolean("Q","Use Q",true)
Zed.Combo:Boolean("W","Use W",true)
Zed.Combo:Boolean("E","Use E",true)
Zed.Combo:Boolean("R","Use R",true)
--Harass
Zed:SubMenu("Harass","Harass")
Zed.Harass:Boolean("Q","Use Q",true)
Zed.Harass:Boolean("E","Use E",true)
--Drawings
Zed:SubMenu("Draw","Drawings")
Zed.Draw:Boolean("DrawQ","Draw Q",true)
Zed.Draw:Boolean("DrawE","Draw E",true)
Zed.Draw:Boolean("DrawS","Draw Shadows",true)
--Misc
Zed:SubMenu("Misc","Misc")
Zed.Misc:SubMenu("Emode","E mode")
Zed.Misc.Emode:Boolean("AE","Auto E",true)
Zed.Misc.Emode:Boolean("ME","Manual E",false)

PrintChat("Evolved Zed is Loaded")
PrintChat("Have fun senpai!")

deathMark = nil

OnTick(function(myHero)
local unit = GetCurrentTarget()
DrawDamage(unit)
if Zed.Misc.Emode.AE:Value() then
	useE(unit)
end
if IOW:Mode() == "Combo" then
	if Zed.Misc.Emode.ME:Value() and Zed.Combo.E:Value() then
		useE(unit)
	end
	gapClose(unit)
	useQ(unit)
	useR(unit)
end
if IOW:Mode() == "Harass" then
	if Zed.Misc.Emode.ME:Value() and Zed.Harass.E:Value() then
		useE(unit)
	end
	useQ(unit)
end
end)

function useQ(unit)
	-- Q
	if Ready(_Q) then
		local ZedQ = {delay = 0.25, speed = 1700, width = 50, range = GetCastRange(myHero,_Q)}
		local Qpred = GetPrediction(unit, ZedQ)
		if Ready(_Q) and ValidTarget(unit, GetCastRange(myHero,_Q)) and Qpred and Qpred.hitChance >= 0.50 then
			CastSkillShot(_Q,Qpred.castPos)
		end
	end
	-- QW
	if Ready(_Q) and WPos ~= nil and ValidTarget(unit, 4000) then
		local wQPred = GetPredictionForPlayer(WPos,unit,GetMoveSpeed(unit),1700,250,GetCastRange(myHero,_Q),50,false,false)
			if wQPred.HitChance == 1 then
				CastSkillShot(_Q,wQPred.PredPos.x,wQPred.PredPos.y,wQPred.PredPos.z)
			end
	end
	--QR
	if Ready(_Q) and RPos ~= nil and ValidTarget(unit, 4000) then
		local rQPred = GetPredictionForPlayer(RPos,unit,GetMoveSpeed(unit),1700,250,GetCastRange(myHero,_Q),50,false,true)
		if rQPred.HitChance == 1 then
			CastSkillShot(_Q,rQPred.PredPos.x,rQPred.PredPos.y,rQPred.PredPos.z)
		end
	end
end

function useE(unit)
	--E
	if Ready(_E) then
		if Ready(_E) and ValidTarget(unit, GetCastRange(myHero,_E)) then
			CastTargetSpell(myHero,_E)
		end
	end
	-- EW
	if Ready(_E) and WPos ~= nil and ValidTarget(unit, 4000) then
		local wEPred = GetPredictionForPlayer(WPos,unit,GetMoveSpeed(unit),math.huge,250,GetCastRange(myHero,_E),0,false,false)
		if wEPred.HitChance == 1 then
			CastSpell(_E)
		end
	end
	--ER
	if Ready(_E) and RPos ~= nil and ValidTarget(unit, 4000) then
		local rEPred = GetPredictionForPlayer(RPos,unit,GetMoveSpeed(unit),math.huge,250,GetCastRange(myHero,_E),0,false,false)
		if rEPred.HitChance == 1 then
			CastSpell(_E)
		end
	end
end

function useR(unit)
local Qdmg = getdmg("Q",unit,myHero,1)
local Edmg = getdmg("E",unit,myHero,1)
local Rdmg = getdmg("R",unit,myHero,3)
local TotalDamage = Qdmg + Edmg + Rdmg
local enemyLife = GetCurrentHP(unit)+GetMagicShield(unit)+GetDmgShield(unit)

	if ValidTarget(unit, GetCastRange(myHero, _R)) and Ready(_R) and deathMark == nil and TotalDamage > enemyLife then
		CastTargetSpell(unit, _R)
		if Ready(_Q) or Ready(_E) then
			CastTargetSpell(unit, _R)
		end
	end
	if deathMark == nil and not ValidTarget(unit, GetCastRange(myHero,_E)) and Ready(_R) then
		CastSpell(_R)
	end
end

OnUpdateBuff (function(unit, buff)
	if not unit or not buff then
		return
	end
	if buff.Name == "zedrdeathmark" then
		print("Not going back!!")
      	deathMark = true
    end
end)
OnRemoveBuff (function(unit, buff)
	if not unit or not buff then
		return
	end
	if buff.Name == "zedrdeathmark" then
		print("Now we can go back!")
		deathMark = nil
    end
end)

function gapClose(unit)
	if Zed.Combo.W:Value() then
		if Ready(_W) and ValidTarget(unit, GetRange(myHero)+GetCastRange(myHero,_W)) and not IsInDistance(unit, GetCastRange(myHero,_E)+GetRange(myHero)) then
			local GaWPred = GetPredictionForPlayer(myHeroPos(),unit,GetMoveSpeed(unit),300,300,GetCastRange(myHero,_W)+GetRange(myHero),250,false,false)
			if GaWPred.HitChance == 1 then
				CastSkillShot(_W,GaWPred.PredPos.x,GaWPred.PredPos.y,GaWPred.PredPos.z)
			end
		end
	end
end

OnCreateObj(function(Object)
	if GetObjectBaseName(Object) == "Shadow" then
		WPos = Object
		RPos = Object
	end
	--PrintChat(string.format("<font color='#00ff00'>CreatedObject= %s</font>",GetObjectBaseName(Object)))
end)
OnDeleteObj(function(Object,myHero)
	if GetObjectBaseName(Object) == "Shadow" then
		WPos = nil
		RPos = nil
	end
end)

function DrawDamage(unit)
	if ValidTarget(unit, 1400) then
		local Qdmg = getdmg("Q",unit,myHero,1)
		if Ready(_Q) then
			DrawDmgOverHpBar(unit,GetCurrentHP(unit),Qdmg,0,0xff00ff00)
		end
		local Edmg = getdmg("E",unit,myHero,1)
		if Ready(_E) then
			DrawDmgOverHpBar(unit,GetCurrentHP(unit),Edmg,0,0xff00ff00)
		end
		local Rdmg = getdmg("R",unit,myHero,3)
		if Ready(_R) then
			DrawDmgOverHpBar(unit,GetCurrentHP(unit),Rdmg,0,0xff00ff00)
		end
	end
end

OnDraw(function(myHero)
	if CanUseSpell(myHero, _Q) == READY and Zed.Draw.DrawQ:Value() then DrawCircle(myHeroPos().x,myHeroPos().y,myHeroPos().z,GetCastRange(myHero,_Q),3,100,GoS.Red) end
	if CanUseSpell(myHero, _E) == READY and Zed.Draw.DrawE:Value() then DrawCircle(myHeroPos().x,myHeroPos().y,myHeroPos().z,GetCastRange(myHero,_E),3,100,GoS.Green) end
	if Zed.Drawings.DrawS:Value() then
		if RPos ~= nil and CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_E) == READY then
			DrawCircle(GetOrigin(RPos), GetCastRange(myHero,_Q),1,50,GoS.Blue)
			DrawCircle(GetOrigin(RPos), GetCastRange(myHero,_E),1,50,GoS.Blue)
			DrawCircle(GetOrigin(RPos), 50,3,50,GoS.White)
		elseif RPos ~= nil and CanUseSpell(myHero,_Q) == READY then
			DrawCircle(GetOrigin(RPos), GetCastRange(myHero,_Q),1,50,GoS.Blue)
			DrawCircle(GetOrigin(RPos), 50,3,50,GoS.White)
		elseif RPos ~= nil and CanUseSpell(myHero,_E) == READY then
			DrawCircle(GetOrigin(RPos), GetCastRange(myHero,_E),1,50,GoS.Blue)
			DrawCircle(GetOrigin(RPos), 50,3,50,GoS.White)
		elseif RPos ~= nil then
			DrawCircle(GetOrigin(RPos), 50,3,50,GoS.White)
		end
		-- W Drawings
		if WPos ~= nil and CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_E) == READY then
			DrawCircle(GetOrigin(WPos), GetCastRange(myHero,_Q),1,50,GoS.Blue)
			DrawCircle(GetOrigin(WPos), GetCastRange(myHero,_E),1,50,GoS.Blue)
			DrawCircle(GetOrigin(WPos), 50,3,50,GoS.White)
		elseif WPos ~= nil and CanUseSpell(myHero,_Q) == READY then
			DrawCircle(GetOrigin(WPos), GetCastRange(myHero,_Q),1,50,GoS.Blue)
			DrawCircle(GetOrigin(WPos), 50,3,50,GoS.White)
		elseif WPos ~= nil and CanUseSpell(myHero,_E) == READY then
			DrawCircle(GetOrigin(WPos), GetCastRange(myHero,_E),1,50,GoS.Blue)
			DrawCircle(GetOrigin(WPos), 50,3,50,GoS.White)
		elseif WPos ~= nil then
			DrawCircle(GetOrigin(WPos), 50,3,50,GoS.White)
		end
	end
end)
