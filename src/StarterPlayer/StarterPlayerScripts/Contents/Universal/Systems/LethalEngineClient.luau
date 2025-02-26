local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LethalEnginePath = ReplicatedStorage.LethalEngine

local components = {
	"Shared/QuickNet",
	"Shared/Keybinds",
	"Shared/Movement",
}

local modules = {}

local LethalEngineClient = {}

local function getPath(component: string)
	local directory, moduleName = component:match("([^/]+)/(.+)")
	return directory == "Shared" and LethalEnginePath or LethalEnginePath, moduleName
end

function LethalEngineClient.init()
	for _, component in ipairs(components) do
		local basePath, moduleName = getPath(component)
		modules[moduleName] = require(basePath:WaitForChild(moduleName))
		if modules[moduleName].init then
			modules[moduleName].init()
		end
	end
end

return LethalEngineClient
