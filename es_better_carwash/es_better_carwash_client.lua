Key = 38 -- E

vehicleWashStation = {
	{28.75,  -1391.93,  27.97},
	{167.1034,  -1719.4704,  27.2916},
	{-74.5693,  6427.8715,  29.4400},
	{-699.6325,  -932.7043,  17.0139},
	{1362.5385, 3592.1274, 33.9211}
}

Citizen.CreateThread(function ()
	Citizen.Wait(0)
	for i = 1, #vehicleWashStation do
		garageCoords = vehicleWashStation[i]
		stationBlip = AddBlipForCoord(garageCoords[1], garageCoords[2], garageCoords[3])
		SetBlipSprite(stationBlip, 100)
		SetBlipColour(stationBlip, 3)
		SetBlipAsShortRange(stationBlip, true)
	end
    return
end)

local timer2 = false
local mycie = false

function es_better_carwash_DrawSubtitleTimed(m_text, showtime)
	SetTextEntry_2('STRING')
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

function es_better_carwash_DrawNotification(m_text)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(m_text)
	DrawNotification(true, false)
end

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
		if IsPedSittingInAnyVehicle(PlayerPedId()) then 
			for i = 1, #vehicleWashStation do
				garageCoords2 = vehicleWashStation[i]
				DrawMarker(1, garageCoords2[1], garageCoords2[2], garageCoords2[3], 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), garageCoords2[1], garageCoords2[2], garageCoords2[3], true ) < 5 then
					if mycie == false then
					HelpPromt('Press ~INPUT_CONTEXT~ to ~b~clean ~s~vehicle for ~g~$25')
					if IsControlJustPressed(1, Key) then
						TriggerServerEvent('es_better_carwash:checkmoney')
					end
				end
				end
			end
		end
	end
end)

RegisterNetEvent('es_better_carwash:success')
AddEventHandler('es_better_carwash:success', function (price)
	local car = GetVehiclePedIsUsing(PlayerPedId())
	local coords = GetEntityCoords(PlayerPedId())
	mycie = true
	FreezeEntityPosition(car, true)
	if not HasNamedPtfxAssetLoaded("core") then
		RequestNamedPtfxAsset("core")
		while not HasNamedPtfxAssetLoaded("core") do
			Wait(1)
		end
	end
	UseParticleFxAssetNextCall("core")
	particles  = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("core")
	particles2  = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", coords.x + 2, coords.y, coords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	timer = 10
	timer2 = true
    Citizen.CreateThread(function()
		while timer2 do
            Citizen.Wait(0)
            Citizen.Wait(1000)
            if(timer > 0)then
				timer = timer - 1
			elseif (timer == 0) then
				mycie = false
				WashDecalsFromVehicle(car, 1.0)
				SetVehicleDirtLevel(car)
				FreezeEntityPosition(car, false)
				StopParticleFxLooped(particles, 0)
				StopParticleFxLooped(particles2, 0)
				timer2 = false
			end
        end
    end)
	Citizen.CreateThread(function()
        while true do
			Citizen.Wait(100)
			if mycie == true then
				for i = 1, #vehicleWashStation do
				garageCoords3 = vehicleWashStation[i]
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), garageCoords3[1], garageCoords3[2], garageCoords3[3], true ) < 2 then
					local finished = exports["np-taskbar"]:taskBar(11400,"Cleaning Vehicle")
            		if finished == 100 then
                		TriggerEvent("notification","Vehicle Cleaned")
            		end
				end
				end
			end
		end
	end)
end)

RegisterNetEvent('es_better_carwash:notenoughmoney')
AddEventHandler('es_better_carwash:notenoughmoney', function (moneyleft)
	TriggerEvent("pNotify:SendNotification", {text = "You don't have enough money! You need:" .. moneyleft .."$ more.", type = "warning", queue = "global", timeout = 5000, layout = "centerLeft"}) 
end)

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

function HelpPromt(text)
	Citizen.CreateThread(function()
		SetTextComponentFormat("STRING")
		AddTextComponentString(text)
		DisplayHelpTextFromStringLabel(0, state, 0, -1)

	end)
end