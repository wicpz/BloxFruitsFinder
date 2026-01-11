--// ======================================================
--// BLOX FRUITS EVENT FINDER (ALL-IN-ONE)
--// ======================================================

--// AUTO EXECUTE ON TELEPORT
if queue_on_teleport then
    queue_on_teleport(game:HttpGet("PASTE_RAW_SCRIPT_URL_HERE"))
end

--// GLOBAL CACHE (ANTI-DUPLICATE)
getgenv().ServerCache = getgenv().ServerCache or {
    Sent = {}
}

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
local HOP_DELAY = 15 -- seconds

local PLACE_ID = game.PlaceId
local JOB_ID = game.JobId

local FoundSomething = false

--// ======================================================
--// AFK PROTECTION
--// ======================================================
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

--// ======================================================
--// WEBHOOK (ANTI-SPAM)
--// ======================================================
local function sendWebhook(eventName, info)
    local key = JOB_ID .. "_" .. eventName
    if getgenv().ServerCache.Sent[key] then
        return
    end

    getgenv().ServerCache.Sent[key] = true
    FoundSomething = true

    local payload = {
        username = "Blox Fruits Finder",
        embeds = {{
            title = "Event Found",
            color = 16776960,
            fields = {
                { name = "Event", value = eventName, inline = true },
                { name = "JobId", value = "`" .. JOB_ID .. "`", inline = false },
                { name = "Info", value = info or "N/A", inline = false }
            },
            footer = {
                text = "Blox Fruits Server Finder"
            }
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

-- Full Moon
local function checkFullMoon()
    if Lighting:GetAttribute("MoonPhase") == "FullMoon" then
        sendWebhook("Full Moon", "Moon phase is full")
    end
end

-- Islands
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

-- Legendary Sword Dealer
local function checkSwordDealer()
    if workspace:FindFirstChild("NPCs") then
        for _, npc in pairs(workspace.NPCs:GetChildren()) do
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

for _, v in pairs(workspace:GetDescendants()) do
    checkIslands(v)
end

--// ======================================================
--// LIVE LISTENERS (NO LOOPS)
--// ======================================================
workspace.DescendantAdded:Connect(checkIslands)

Lighting.AttributeChanged:Connect(function(attr)
    if attr == "MoonPhase" then
        checkFullMoon()
    end
end)

--// ======================================================
--// AUTO SERVER HOP
--// ======================================================
local function hopServer()
    if AUTO_HOP and not FoundSomething then
        TeleportService:Teleport(PLACE_ID, LocalPlayer)
    end
end

task.spawn(function()
    task.wait(HOP_DELAY)
    hopServer()
end)

--// ======================================================
--// OPTIONAL: MANUAL JOIN FUNCTION
--// ======================================================
getgenv().JoinServer = function(jobId)
    TeleportService:TeleportToPlaceInstance(
        PLACE_ID,
        jobId,
        LocalPlayer
    )
end
