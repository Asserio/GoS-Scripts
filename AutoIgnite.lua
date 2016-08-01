require('Inspired')
if GetCastName(myHero,SUMMONER_1):lower() == "summonerdot" then
	Ignite = SUMMONER_1
elseif GetCastName(myHero,SUMMONER_2):lower() == "summonerdot" then
	Ignite = SUMMONER_2
else
	return
end
Ign = Menu ("Ign","Ignite")
Ign:Boolean("AtIgn","Auto Ignite",true)

OnTick(function(myHero)
for i,enemy in pairs(GetEnemyHeroes()) do

if Ignite and Ign.AtIgn:Value() then
		if CanUseSpell(myHero, Ignite) and 50 + (20  * GetLevel(myHero)) > GetCurrentHP(enemy) and ValidTarget(enemy, 600) then
			CastTargetSpell(enemy, Ignite)
		end
end
end
end)
