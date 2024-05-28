# Still in beta, dont use useServerFunction for security reasons.


### Server Function
```lua
local player = PlayerId()
local source = GetPlayerServerId(player)
useServerFunction(function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addAccountMoney('bank', 1000)
end)
```

### Client Function

```lua
useClientFunction(function()
    local ped = PlayerPedId()
    SetEntityCoords(ped, 255, 255, 255)
end, src)
```