if game.PlaceId ~= 286090429 then
    return
end


local config = {
    
    SpamRespawn = false,
    
    ServerHopOnLowPlrCount = true,
    ServerHopPlrCount = 5,
    ServerHopAfterTime = true,
    ServerHopTime = 45
}

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local plrs = game:service("Players")
local rs = game:service("ReplicatedStorage")

local function hop() 
    while wait(3) do
        local x = {}
        for _, v in ipairs(game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
            if type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then
                x[#x + 1] = v.id
            end
        end
        if #x > 0 then
            wait()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, x[math.random(1, #x)])
        end
    end
end

spawn(function()
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/xJxnDev/ArsenalAutofarmV2/main/ServerHop.lua'),true))()
end)

while not plrs["LocalPlayer"] do
    wait()
end

local plr = plrs.LocalPlayer

while not rs:FindFirstChild("Events") or not plr:FindFirstChild("Status") or not rs:FindFirstChild("wkspc") or not rs:FindFirstChild("Weapons") do
    wait()
end

local events = rs.Events



local function teamcheck(vic, isffa)
    if isffa == true then return true end
    if vic.Status.Team.Value == plr.Status.Team.Value then return false end
    return true
end

spawn(function()
    while wait(1) do
        if _G.ChatSpam == true then
            events.PlayerChatted:FireServer(_G.SpamMessage, false, false, false)
        end
    end
end)


spawn(function()
    while wait(.1) do
        if #plrs:GetPlayers() <= 8 then
            hop()
        	wait(2)
    	end
    end
end)

local decalsyeeted = true
local g = game
local w = g.Workspace
local l = g.Lighting
local t = w.Terrain
sethiddenproperty(l,"Technology",2)
sethiddenproperty(t,"Decoration",false)
t.WaterWaveSize = 0
t.WaterWaveSpeed = 0
t.WaterReflectance = 0
t.WaterTransparency = 0
l.GlobalShadows = false
l.FogEnd = 9e9
l.Brightness = 0
settings().Rendering.QualityLevel = "Level01"
for i, v in pairs(g:GetDescendants()) do
    if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
    elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Lifetime = NumberRange.new(0)
    elseif v:IsA("Explosion") then
        v.BlastPressure = 1
        v.BlastRadius = 1
    elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
        v.Enabled = false
    elseif v:IsA("MeshPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
        v.TextureID = 10385902758728957
    end
end

for i, e in pairs(l:GetChildren()) do
    if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
        e.Enabled = false
    end
end


while wait() do
    local is_spectator = plr.Status.Team.Value == "Spectator"
    local roundover = rs.wkspc.Status.RoundOver.Value
    local ffa = rs.wkspc.FFA.Value
    local can_respawn = rs.wkspc.Status.CanRespawn.Value
    local camera = workspace.CurrentCamera

    if is_spectator == false and roundover == false then
        for _,v in next, plrs:GetPlayers() do
            pcall(function()
                if v.Name ~= plr.Name and v.Character:FindFirstChild("Spawned") and teamcheck(v, ffa) then
                    local gun = rs.Weapons:FindFirstChild(plr.Character.Gun.Boop.Value)
                    local ismelee = (gun:FindFirstChild("Melee") and true or false)
                    if ismelee == false then
                        if config.SpamRespawn == true then
                            events.SpawnMe:FireServer()
                        end
                        plr.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                        plr.Character.HumanoidRootPart.CFrame = v.Character.Head.CFrame + Vector3.new(0,2,0)
                        camera.CFrame = CFrame.new(camera.CFrame.p, v.Character.Head.CFrame.p)
                        events.HitPart:FireServer(v.Character.Head, v.Character.Head.Position + Vector3.new(math.random(), math.random(), math.random()), gun.Name, 1, (plr.Character.Head.Position - v.Character.Head.Position).Magnitude, false, (math.random() > .6 and true or false), ismelee, 1, false, gun.FireRate.Value, gun.ReloadTime.Value, gun.Ammo.Value, gun.StoredAmmo.Value, gun.Bullets.Value, gun.EquipTime.Value, gun.RecoilControl.Value, gun.Auto.Value, gun["Speed%"].Value, rs.wkspc.DistributedTime.Value) --thanks ic3w0lf
                    else
                        plr.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                        plr.Character.HumanoidRootPart.CFrame = v.Character.Head.CFrame + Vector3.new(0,2,0)
                        wait(.4)
                        camera.CFrame = CFrame.new(camera.CFrame.p, v.Character.Head.CFrame.p)
                        events.HitPart:FireServer(v.Character.Head, v.Character.Head.Position + Vector3.new(math.random(), math.random(), math.random()), gun.Name, 1, (plr.Character.Head.Position - v.Character.Head.Position).Magnitude, false, (math.random() > .6 and true or false), ismelee, 1, false, gun.FireRate.Value, gun.ReloadTime.Value, gun.Ammo.Value, gun.StoredAmmo.Value, gun.Bullets.Value, gun.EquipTime.Value, gun.RecoilControl.Value, gun.Auto.Value, gun["Speed%"].Value, rs.wkspc.DistributedTime.Value) --thanks ic3w0lf
                    end
                end
            end)
        end
    end
    
    if is_spectator == true and roundover == false and can_respawn == true then
        events.CoolNewRemote:FireServer("MouseButton1")
        wait(.2)
        if ffa == false then 
            events.JoinTeam:FireServer("TBC")
            wait(.3)
            if (plr.Status.Team.Value == "Spectator") and rs.wkspc.Status.RoundOver.Value == false and rs.wkspc.Status.CanRespawn.Value == true then
                events.JoinTeam:FireServer("TRC")
            end
            wait(.3)
        else
            events.JoinTeam:FireServer("Random")
        end
end
end
