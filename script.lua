--// ======================================================
--// BLOX FRUITS EVENT FINDER (FIXED + SMART HOP)
--// ======================================================

--// AUTO EXECUTE ON TELEPORT
if queue_on_teleport then
    queue_on_teleport(game:HttpGet(
        "https://raw.githubusercontent.com/wicpz/BloxFruitsFinder/main/script.lua"
    ))
end

--// GLOBAL CACHES
getgenv().ServerCache = getgenv().ServerCache or { Sent = {} }
getgenv().CheckedServers = getgenv().CheckedServers or {}

--// SERVICES
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

--// CONFIG
local WEBHOOK_URL = "https://discord.com/api/webhooks/1459982301449552015/kjAvqXuGsjwL4WeH8vujJ3tN1AqLFWoB3718qtQhA6HvvuHJ3TmSIlogV-HIMfsfYlKT"
local AUTO_HOP = true
local HOP_DELAY = 15

local PLACE_ID = game.PlaceId
local JOB_ID = game.JobId

local FoundSomething = false

-- Mark current server as checked
getgenv().CheckedServers[JOB_ID] = true

--// ======================================================
--// AFK PROTECTION
--// ======================================================
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

--// ======================================================
--// UTIL
--// ======================================================
local function getPlayerCount()
    return tostring(#Players:GetPlayers())
end

--// ======================================================
--// WEBHOOK (ANTI-DUPLICATE)
--// ======================================================
local function sendWebhook(eventName)
    local key = JOB_ID .. "_" .. eventName
    if getgenv().ServerCache.Sent[key] then return end

    getgenv().ServerCache.Sent[key] = true
    FoundSomething = true

    local payload = {
        username = "Blox Fruits Finder",
        embeds = {{
            title = "Event Found",
            color = 16776960,
            fields = {
                { name = "Event", value = eventName, inline = true },
                { name = "Players", value = getPlayerCount(), inline = true },
                { name = "JobId", value = "`" .. JOB_ID .. "`", inline = false }
            },
            footer = { text = "Blox Fruits Server Finder" }
        }}
    }

    http_request({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode(payload)
    })
end

--// ======================================================
--// DETECTIONS
--// ======================================================
local function checkFullMoon()
    if Lighting:GetAttribute("MoonPhase") == "FullMoon" then
        sendWebhook("Full Moon")
    end
end

local function checkIslands(obj)
    local name = obj.Name:lower()
    if name:find("mirage") then
        sendWebhook("Mirage Island")
    elseif name:find("kitsune") then
        sendWebhook("Kitsune Island")
    elseif name:find("prehistoric") then
        sendWebhook("Prehistoric Island")
    end
end

local function checkSwordDealer()
    if workspace:FindFirstChild("NPCs") then
        for _, npc in ipairs(workspace.NPCs:GetChildren()) do
            if npc.Name == "LegendarySwordDealer" then
                sendWebhook("Legendary Sword Dealer")
            end
        end
    end
end

--// ======================================================
--// INITIAL SCAN
--// ======================================================
checkFullMoon()
checkSwordDealer()

for _, v in ipairs(workspace:GetDescendants()) do
    checkIslands(v)
end

--// ======================================================
--// LIVE LISTENERS
--// ======================================================
workspace.DescendantAdded:Connect(checkIslands)

Lighting.AttributeChanged:Connect(function(attr)
    if attr == "MoonPhase" then
        checkFullMoon()
    end
end)

--// ======================================================
--// SMART SERVER HOP (NO REJOIN)
--// ======================================================
local function hopServer()
    if not AUTO_HOP or FoundSomething then return end

    local url =
        "https://games.roblox.com/v1/games/"
        .. PLACE_ID
        .. "/servers/Public?sortOrder=Asc&limit=100"

    local success, data = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)

    if not success or not data.data then return end

    for _, server in ipairs(data.data) do
        if not getgenv().CheckedServers[server.id]
        and server.playing < server.maxPlayers then

            getgenv().CheckedServers[server.id] = true

            TeleportService:TeleportToPlaceInstance(
                PLACE_ID,
                server.id,
                LocalPlayer
            )
            return
        end
    end
end

task.spawn(function()
    task.wait(HOP_DELAY)
    hopServer()
end)

--// ======================================================
--// MANUAL JOIN (OPTIONAL)
--// ======================================================
getgenv().JoinServer = function(jobId)
    TeleportService:TeleportToPlaceInstance(
        PLACE_ID,
        jobId,
        LocalPlayer
    )
end
