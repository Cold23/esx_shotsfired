ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("shotsFired:setblip")
AddEventHandler("shotsFired:setblip", function(x,y,z)
	Citizen.Wait(math.random(1500,3000))
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('shotsFired:blipC',xPlayers[i],x,y,z)
		end
	end
end)
