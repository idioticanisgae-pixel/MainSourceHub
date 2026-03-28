local scriptSettings: { [string]: any } = {
Url = "",
Debug = false,
Timeout = 10
}
local runService: RunService = game:GetService("RunService")
local coreGui: CoreGui = game:GetService("CoreGui")
local players: Players = game:GetService("Players")
local localPlayer: Player = players.LocalPlayer
local function executeScript(url: string): boolean
    local success: boolean, result: any = pcall(function()
        local scriptData: string = game:HttpGet(url)
        local loadedScript: any = loadstring(scriptData)
        if typeof(loadedScript) == "function" then
            task.spawn(loadedScript)
            return true
        end
        return false
    end)
    return success and result
end
local function initializeLoader(): nil
    if getgenv()._LOADER_INITIALIZED then
        return
    end
    getgenv()._LOADER_INITIALIZED = true
    local executionState: boolean = false
    local retryCount: number = 0
    local maxRetries: number = 3
    while not executionState and retryCount < maxRetries do
        executionState = executeScript(scriptSettings.Url)
        if not executionState then
            retryCount += 1
            task.wait(1)
        end
    end
    return
end
task.spawn(initializeLoader)
