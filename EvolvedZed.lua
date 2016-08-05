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
Zed.Harass:Boolean("W","Use W",true)
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
local Wtime = 0
local objects = {}
local stackeddamage = 0
local savestacked = 0
OnTick(function(myHero)
local unit = GetCurrentTarget()
if Zed.Misc.Emode.AE:Value() then
	useE(unit)
end
if IOW:Mode() == "Combo" then
 	if Zed.Misc.Emode.ME:Value() and Zed.Combo.E:Value() then
		useE(unit)
	end
    if Zed.Combo.Q:Value() then
	   useQ(unit)
	end
	if Zed.Combo.W:Value() then
	   useW(unit)
	   gapClose(unit)
	end
	if Zed.Combo.R:Value() then
	   useR(unit)
	end
end
if IOW:Mode() == "Harass" then

	if Zed.Misc.Emode.ME:Value() and Zed.Harass.E:Value() then
	   useE(unit)
	end
	if Zed.Harass.Q:Value() then
	   useQ(unit)
	end
	useW(unit)

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
  for i, obj in pairs(objects) do
	-- QW
	if Ready(_Q) and obj ~= nil and ValidTarget(unit, 4000) then
		local wQPred = GetPredictionForPlayer(GetOrigin(obj),unit,GetMoveSpeed(unit),1700,250,GetCastRange(myHero,_Q),50,false,false)
			if wQPred.HitChance == 1 then
				CastSkillShot(_Q,wQPred.PredPos.x,wQPred.PredPos.y,wQPred.PredPos.z)
			end
	end
	--QR
	if Ready(_Q) and obj ~= nil and ValidTarget(unit, 4000) then
		local rQPred = GetPredictionForPlayer(GetOrigin(obj),unit,GetMoveSpeed(unit),1700,250,GetCastRange(myHero,_Q),50,false,true)
		if rQPred.HitChance == 1 then
			CastSkillShot(_Q,rQPred.PredPos.x,rQPred.PredPos.y,rQPred.PredPos.z)
		end
	end
  end
end

function useW(unit)
  if IOW:Mode() == "Harass" then
     local time = 5000
	 if Ready(_Q) and Ready(_W) and GotBuff(myHero,"ZedWHandler") == 0 and ValidTarget(unit, totalRange) then
		-- GetPredictionForPlayer(StartPos,target,movespeed,speed,delay,range,width,collision(true/false),AddHitBox(true/false))
		local Time = GetTickCount()
		local WQPred = GetPredictionForPlayer(myHeroPos(),unit,GetMoveSpeed(unit),300,300,1450,250,false,false)
		if (Wtime + 5000) < Time then
			if WQPred.HitChance == 1 then
				CastSkillShot(_W,WQPred.PredPos.x,WQPred.PredPos.y,WQPred.PredPos.z)
				Wtime = Time
			end
		end
	 end
  end
	for i, obj in pairs(objects) do
		if IOW:Mode() == "Combo" then
		if Ready(_W) and obj ~= nil and ValidTarget(unit, 4000) then
			local WPredt = GetPredictionForPlayer(GetOrigin(obj),unit,GetMoveSpeed(unit),math.huge,250,GetCastRange(myHero,_E),0,false,false)
			if WPredt.HitChance == 1 then
				CastSpell(_W)
			end
		end
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
	for i, obj in pairs(objects) do
	-- EW
		if Ready(_E) and obj ~= nil and ValidTarget(unit, 4000) then
			local wEPred = GetPredictionForPlayer(GetOrigin(obj),unit,GetMoveSpeed(unit),math.huge,250,GetCastRange(myHero,_E),0,false,false)
			if wEPred.HitChance == 1 then
				CastSpell(_E)
			end
		end
	--ER
		if Ready(_E) and obj ~= nil and ValidTarget(unit, 4000) then
			local rEPred = GetPredictionForPlayer(GetOrigin(obj),unit,GetMoveSpeed(unit),math.huge,250,GetCastRange(myHero,_E),0,false,false)
			if rEPred.HitChance == 1 then
				CastSpell(_E)
			end
		end
	end
end

function useR(unit)
local Qdmg = getdmg("Q",unit,myHero,1,GetCastLevel(myHero,_Q))
local Edmg = getdmg("E",unit,myHero,1,GetCastLevel(myHero,_E))
local Rdmg = getdmg("R",unit,myHero,1,GetCastLevel(myHero,_R))
local physical = GetBaseDamage(myHero) + GetBonusDmg(myHero)
local magical = GetBonusAP(myHero)
local TotalDamage = physical + magical * .1
local enemyLife = GetCurrentHP(unit)+GetMagicShield(unit)+GetDmgShield(unit)

	if ValidTarget(unit, GetCastRange(myHero, _R)) and Ready(_R) and deathMark == nil and savestacked > enemyLife then
		CastTargetSpell(unit, _R)
	end
--[[if Ready(_Q) then
	if ValidTarget(unit, GetCastRange(myHero, _R)) and Ready(_R) and deathMark == nil and TotalDamage + Qdmg > enemyLife then
		CastTargetSpell(unit, _R)
	end
end
if Ready(_E) then
    if ValidTarget(unit, GetCastRange(myHero, _R)) and Ready(_R) and deathMark == nil and TotalDamage + Edmg > enemyLife then
		CastTargetSpell(unit, _R)
	end
end
if Ready(_Q) and Ready(_E) then
	if ValidTarget(unit, GetCastRange(myHero, _R)) and Ready(_R) and deathMark == nil and TotalDamage + Qdmg + Edmg > enemyLife then
		CastTargetSpell(unit, _R)
	end
end]]
-- Go back
	if deathMark ~= nil and stackeddamage > enemyLife then
		CastSpell(_R)
	end
	--if deathMark == nil and not ValidTarget(unit, GetCastRange(myHero,_E)) and Ready(_R) then
		--CastSpell(_R)
	--end
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
		savestacked = stackeddamage
		stackeddamage = 0
    end
end)

function gapClose(unit)
if deathMark ~= true then
	if Zed.Combo.W:Value() then
		if Ready(_W) and ValidTarget(unit, GetRange(myHero)+GetCastRange(myHero,_W)) and not IsInDistance(unit, GetCastRange(myHero,_E)+GetRange(myHero)) then
			local GaWPred = GetPredictionForPlayer(myHeroPos(),unit,GetMoveSpeed(unit),300,300,GetCastRange(myHero,_W)+GetRange(myHero),250,false,false)
			if GaWPred.HitChance == 1 then
				CastSkillShot(_W,GaWPred.PredPos.x,GaWPred.PredPos.y,GaWPred.PredPos.z)
			end
		end
	end
end
end
-- Credits to Deftsu
OnCreateObj(function(Object)
  if GetObjectBaseName(Object) == "Shadow" then
    table.insert(objects, Object)
  end
end)

OnDeleteObj(function(Object)
  if GetObjectBaseName(Object) == "Shadow" then
    for i, obj in pairs(objects) do
      if obj == Object then
        table.remove(objects, i)
      end
	end
  end
end)

OnDraw(function(myHero) -- example
	if CanUseSpell(myHero, _Q) == READY and Zed.Draw.DrawQ:Value() then DrawCircle(myHeroPos().x,myHeroPos().y,myHeroPos().z,GetCastRange(myHero,_Q),3,100,GoS.Red) end
	if CanUseSpell(myHero, _E) == READY and Zed.Draw.DrawE:Value() then DrawCircle(myHeroPos().x,myHeroPos().y,myHeroPos().z,GetCastRange(myHero,_E),3,100,GoS.Green) end
	if Zed.Drawings.DrawS:Value() then
		for i, obj in pairs(objects) do -- objects table
			DrawCircle(GetOrigin(obj), GetCastRange(myHero,_Q),1,50,GoS.Blue)
			DrawCircle(GetOrigin(obj), GetCastRange(myHero,_E),1,50,GoS.Blue)
			DrawCircle(GetOrigin(obj), 50,3,50,GoS.White)
		end
	end
	-- Credits end here
local unit = GetCurrentTarget()
local Qdmg = getdmg("Q",unit,myHero,1,GetCastLevel(myHero,_Q))
local Edmg = getdmg("E",unit,myHero,1,GetCastLevel(myHero,_E))
local Rdmg = getdmg("R",unit,myHero,1,GetCastLevel(myHero,_R))
local physical = GetBaseDamage(myHero) + GetBonusDmg(myHero)
local magical = GetBonusAP(myHero)
local TotalDamage = physical + magical * .1
	if ValidTarget(unit, 1400) then
		--[[local Qdmg = getdmg("Q",unit,myHero,1,GetCastLevel(myHero,_Q))
		if Ready(_Q) then
			DrawDmgOverHpBar(unit,GetCurrentHP(unit),Qdmg,0,0xff00ff00)
		end
		local Edmg = getdmg("E",unit,myHero,1,GetCastLevel(myHero,_E))
		if Ready(_E) then
			DrawDmgOverHpBar(unit,GetCurrentHP(unit),Edmg,0,0xff00ff00)
		end]]
		local Rdmg = getdmg("R",unit,myHero,1,GetCastLevel(myHero,_R))
		if Ready(_R) then
			DrawDmgOverHpBar(unit,GetCurrentHP(unit),savestacked,0,0xff00ff00)
		end
		if deathMark ~= nil then
		   DrawDmgOverHpBar(unit,GetCurrentHP(unit),stackeddamage,0,0xff00ff00)
		end
	end
end)
--More Credits to Deftsu
OnDamage(function(unit, target, damage)
local enemyHero = GetCurrentTarget()
	if unit == myHero and target == enemyHero then
		if deathMark ~= nil then
		 stackeddamage = stackeddamage + damage
		 --PrintChat(string.format("<font color='#ff0000'>OnDamage:</font> Sender: [%s] Receiver: [%s] Damage: [%f]",GetObjectName(unit),GetObjectName(target),damage));
		end
	end
end)
