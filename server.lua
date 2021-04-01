local pickups = {}
for k,v in pairs(Config.coords) do
  pickups[k] = {GetHashKey(Config.models[k]), v, Config.coords[k]}
end

local stats_data = LoadResourceFile(GetCurrentResourceName(), 'stats.json')
local stats = {}
if stats_data then
  stats = json.decode(stats_data)
end

if Config.advanceCount then
  for k,v in pairs(stats) do
    local count = 0
    for i,d in pairs(v.pickups) do
      count = count + 1
    end

    v.count = count
  end
end

local function GetPlayerLicense(ids)
  for _,v in pairs(ids) do
    if string.find(v, 'license') then
      return v
    end
  end

  return false
end

RegisterNetEvent('paques:takePuckup')
AddEventHandler('paques:takePuckup', function(pickupId)
  local ids = GetPlayerIdentifiers(source)
  local license = GetPlayerLicense(ids)
  local data = stats[license]

  if not data then
    stats[license] = {
      count = 0,
      pickups = {}
    }
  end

  stats[license].pickups[pickupId] = true

  if Config.advanceCount then
    local count = 0
    for i,d in pairs(stats[license].pickups) do
      count = count + 1
    end

    stats[license].count = count
  else
    stats[license].count = stats[license].count + 1
  end

  if stats[license].count == #Config.coords then
    TriggerClientEvent('paques:notify', source, Config.texts[Config.locale].collected_all)
  else
    TriggerClientEvent('paques:notify', source, Config.texts[Config.locale].collected..' ('..stats[license].count..'/~b~'..#Config.coords..'~s~)')
  end

  SaveResourceFile(GetCurrentResourceName(), 'stats.json', json.encode(stats), -1)
end)

RegisterNetEvent('paques:requestData')
AddEventHandler('paques:requestData', function()
  local ids = GetPlayerIdentifiers(source)
  local license = GetPlayerLicense(ids)
  if license then
    local data = stats[license] or {
      count = 0,
      pickups = {}
    }
    TriggerClientEvent('paques:receiveData', source, data, pickups)
  else
    print('PAS DE LISCENCE POUR? : '..source)
  end
end)