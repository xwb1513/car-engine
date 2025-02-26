local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LethalEngineServerPath = ServerScriptService.Contents.Universal.Systems.LethalEngineServer
local LethalEngineSharedPath = ReplicatedStorage.LethalEngine

local components = {
	"Shared/QuickNet",
	"Server/StanceHandler",
}

local modules = {}

local LethalEngineServer = {}

local function getPath(component: string)
	local directory, moduleName = component:match("([^/]+)/(.+)")
	return directory == "Shared" and LethalEngineSharedPath or LethalEngineServerPath, moduleName
end

function LethalEngineServer.init()
	for _, component in ipairs(components) do
		local basePath, moduleName = getPath(component)
		modules[moduleName] = require(basePath:WaitForChild(moduleName))
		if modules[moduleName].init then
			modules[moduleName].init()
		end
	end
end

return LethalEngineServer
