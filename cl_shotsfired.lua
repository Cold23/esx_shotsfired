ESX = nil

local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

local blacklistedWeapons = {
	"WEAPON_UNARMED",
	"WEAPON_STUNGUN",
	"WEAPON_KNIFE",
	"WEAPON_KNUCKLE",
	"WEAPON_NIGHTSTICK",
	"WEAPON_HAMMER",
	"WEAPON_BAT",
	"WEAPON_GOLFCLUB",
	"WEAPON_CROWBAR",
	"WEAPON_BOTTLE",
	"WEAPON_DAGGER",
	"WEAPON_HATCHET",
	"WEAPON_MACHETE",
	"WEAPON_FLASHLIGHT",
	"WEAPON_SWITCHBLADE",
	"WEAPON_FIREEXTINGUISHER",
	"WEAPON_PETROLCAN",
	"WEAPON_SNOWBALL",
	"WEAPON_FLARE",
	"WEAPON_BALL"
}

-- [[ You shouldn't have to touch below here ]] --

local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
local playerX = 0
local playerY = 0
local playerZ = 0


Citizen.CreateThread( function()
	while true do
		Citizen.Wait(5)
		local ped = GetPlayerPed(-1)
		local pedShooting = IsPedShooting(ped)
		if pedShooting and PlayerData.job.name ~= 'police'  then
			local isBlacklistedWeapon = false
			x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
			playerX = tonumber(string.format("%.2f", x))
			playerY = tonumber(string.format("%.2f", y))
			playerZ = tonumber(string.format("%.2f", z))
			if CheckCity(playerX, playerY) then
				for i=1, #blacklistedWeapons, 1 do
	    			if GetSelectedPedWeapon(ped) == GetHashKey(blacklistedWeapons[i]) then
	    				isBlacklistedWeapon = true
	    			end
				end 

				if not isBlacklistedWeapon then
					TriggerServerEvent('robberies:ServerNotification',"Shots Fired, marked all units GPS.")
					TriggerServerEvent('shotsFired:setblip',playerX, playerY, playerZ)
					Citizen.Wait(30000)
				end

				isBlacklistedWeapon = false

			end
		end
	end
end)

RegisterNetEvent("shotsFired:blipC")
AddEventHandler("shotsFired:blipC", function(x,y,z)
	setblip(x,y,z)
end)


RegisterNetEvent("shotsFired:killb")
AddEventHandler("shotsFired:killb", function()
	killblip()
end)

function killblip()
    RemoveBlip(blipRobbery)
end

function setblip(x,y,z)
    local blipRobbery = AddBlipForCoord(x, y, z)
    SetBlipSprite(blipRobbery , 433)
    SetBlipScale(blipRobbery , 2.0)
    SetBlipColour(blipRobbery, 37)
    SetBlipAlpha(blipRobbery, 100)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Shots Fired Alert")
    EndTextCommandSetBlipName(blipRobbery)
    local ped = GetPlayerPed(-1)
	local blipActive = true
	Citizen.Wait(30000)
	RemoveBlip(blipRobbery)
end

function CheckCity(x, y)
	-- LS --
	local lsNorth = 1309.00 --
	local lsSouth = -3643.00 --
	local lsWest = -2608.00 --
	local lsEast = 1590.00 --

	-- Paleto --
	local pNorth = 7123.00 --
	local pSouth = 5678.00 --
	local pWest = -595.00 --
	local pEast = 799.00 --

	-- Sandy --
	local sNorth = 4089.00 --
	local sSouth = 3291.00 --
	local sWest = 1350.00 --
	local sEast = 2232.00 --

	-- Grapeseed --
	local gNorth = 5321.00 --
	local gSouth = 4277.00 --
	local gWest = 2977.00 --
	local gEast = 1633.00 --

	-- Chumash --
	local cNorth = 1385.00 --
	local cSouth = 187.00 --
	local cWest = -3451.00 --
	local cEast = -2869.00 --

	-- Tataviam --
	local tNorth = 862.00 --
	local tSouth = 0.00 --
	local tWest = 2378.00 --
	local tEast = 2738.00 --

	
	if (x <= lsEast) and (x >= lsWest) and (y <= lsNorth) and (y >= lsSouth) then
		return true
	elseif (x <= pEast) and (x >= pWest) and (y <= pNorth) and (y >= pSouth) then
		return true
	elseif (x <= sEast) and (x >= sWest) and (y <= sNorth) and (y >= sSouth) then
		return true
	elseif (x <= gEast) and (x >= gWest) and (y <= gNorth) and (y >= gSouth) then
		return true
	elseif (x <= cEast) and (x >= cWest) and (y <= cNorth) and (y >= cSouth) then
		return true
	elseif (x <= tEast) and (x >= tWest) and (y <= tNorth) and (y >= tSouth) then
		return true
	end
	return false
	
end