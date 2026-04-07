local petList = {

	["pet1"] = {
		probability = 0.5,
		boost = 2,
		luckRate = 0.3,
	},

	["pet2"] = {
		probability = 0.3,
		boost = 3,
		luckRate = 0.7,
	},

	["pet3"] = {
		probability = 0.15,
		boost = 4.5,
		luckRate = 0.85,
	},

	["pet4"] = {
		probability = 0.045,
		boost = 7,
		luckRate = 0.93,
	},

	["pet5"] = {
		probability = 0.00495,
		boost = 12,
		luckRate = 0.97,
	},

	["pet6"] = {
		probability = 0.00005,
		boost = 25,
		luckRate = 0.99,
	}

}

local LUCK_BOOST         = 0
local MOST_COMMON_PET_PROBA = petList.pet1.probability
-- Coder une fonction pour le trouver manuellement a partir d'un oeuf

local function calculateProbabilityFromPlacement(placement, center)
	local insideExp = -1/2 * math.pow((placement - center), 2)
	local result    = MOST_COMMON_PET_PROBA * math.exp(insideExp)
	return result
end

local function calculatePlacementFromProbability(probability, center)
	local insideLn   = probability/MOST_COMMON_PET_PROBA
	local insideSqrt = -2*math.log(insideLn, math.exp(1))
	local result     = center + math.sqrt(insideSqrt)
	return result
end

-- En théorie cette fonction devra s'exécuter à l'ouverture du serveur / quand un joueur ouvre un oeuf
local function setupPets(petList)
	for petName,petStats in petList do
		petList[petName].initialPlacement = calculatePlacementFromProbability(petList[petName].probability, 0)
	end
end

local function newProbabilityTable(petList, newCenter)
	
	local movementRatio = math.abs(newCenter)
	local newPetTable   = {}
	local saveTable     = {}
	local ratio         = 0
	
	for petName,petStats in petList do
		local petProba = calculateProbabilityFromPlacement(petStats.initialPlacement+(movementRatio*petStats.luckRate), newCenter)
		ratio += petProba
		table.insert(saveTable, petProba)
	end

	for petName, petStats in petList do
		newPetTable[petName] = {
			probability = saveTable[1]/ratio,
			boost       = petStats.boost
		}
		table.remove(saveTable, 1)
	end

	return newPetTable

end

setupPets(petList)
local luckInfluencedTable = newProbabilityTable(petList, 0)

-----------------

local gui = script.Parent
local scroll = gui.scroll
local scroller = scroll.scroller
local petValues = gui.petValues

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

local mouseDown = false

local function showNewValues(petList2)
	for petName,petStats in petList2 do
		local power = math.floor(math.log10(1/petList[petName].probability))+1
		petValues[petName].probability.Text = tostring(math.round(petStats.probability*100*math.pow(10,power))/math.pow(10,power)).."%"
		if petStats.probability < petList[petName].probability and petList[petName].probability <= 0.01 then
			petValues[petName].probability.Text = tostring(math.round(petList[petName].probability*100*math.pow(10,power))/math.pow(10,power)).."%"
		end
	end
	gui.luckboost.Text = "CURRENT LUCK BOOST : "..tostring(math.round(100*LUCK_BOOST)/100).."x"
end

showNewValues(petList)

scroller.MouseButton1Down:Connect(function(x,y)
	
	mouseDown = true
	
	repeat
		scroller.Position = UDim2.new(math.clamp(mouse.X/workspace.CurrentCamera.ViewportSize.X,0,1),0,-4.5,0)
		task.wait(0.01)
	until mouseDown == false
	
end)

mouse.Button1Up:Connect(function()
	mouseDown = false
end)

scroller.Changed:Connect(function(property)
	
	if property == "Position" then
		LUCK_BOOST = scroller.Position.X.Scale*20
		luckInfluencedTable = newProbabilityTable(petList, math.pow(LUCK_BOOST,1.35))
		showNewValues(luckInfluencedTable)
	end
	
end)

gui.plusButton.MouseButton1Click:Connect(function()
	if LUCK_BOOST <= 19.9 then
		LUCK_BOOST += 0.1
		luckInfluencedTable = newProbabilityTable(petList, math.pow(LUCK_BOOST,1.35))
		showNewValues(luckInfluencedTable)
	end
end)

gui.minusButton.MouseButton1Click:Connect(function()
	if LUCK_BOOST >= 0.1 then
		LUCK_BOOST -= 0.1
		luckInfluencedTable = newProbabilityTable(petList, math.pow(LUCK_BOOST,1.35))
		showNewValues(luckInfluencedTable)
	end
end)

gui.luckSmall.MouseButton1Click:Connect(function()
	task.spawn(function()
		local BOOST = 2
		
		LUCK_BOOST += BOOST
		luckInfluencedTable = newProbabilityTable(petList, math.pow(LUCK_BOOST,1.35))
		showNewValues(luckInfluencedTable)
		task.wait(5)
		LUCK_BOOST -= BOOST
		luckInfluencedTable = newProbabilityTable(petList, math.pow(LUCK_BOOST,1.35))
		showNewValues(luckInfluencedTable)
	end)
end)

gui.luckMedium.MouseButton1Click:Connect(function()
	task.spawn(function()
		local BOOST = 4

		LUCK_BOOST += BOOST
		luckInfluencedTable = newProbabilityTable(petList, math.pow(LUCK_BOOST,1.35))
		showNewValues(luckInfluencedTable)
		task.wait(5)
		LUCK_BOOST -= BOOST
		luckInfluencedTable = newProbabilityTable(petList, math.pow(LUCK_BOOST,1.35))
		showNewValues(luckInfluencedTable)
	end)
end)

gui.luckHuge.MouseButton1Click:Connect(function()
	task.spawn(function()
		local BOOST = 7

		LUCK_BOOST += BOOST
		luckInfluencedTable = newProbabilityTable(petList, math.pow(LUCK_BOOST,1.35))
		showNewValues(luckInfluencedTable)
		task.wait(5)
		LUCK_BOOST -= BOOST
		luckInfluencedTable = newProbabilityTable(petList, math.pow(LUCK_BOOST,1.35))
		showNewValues(luckInfluencedTable)
	end)
end)

gui.luckUber.MouseButton1Click:Connect(function()
	task.spawn(function()
		local BOOST = 10

		LUCK_BOOST += BOOST
		luckInfluencedTable = newProbabilityTable(petList, math.pow(LUCK_BOOST,1.35))
		showNewValues(luckInfluencedTable)
		task.wait(5)
		LUCK_BOOST -= BOOST
		luckInfluencedTable = newProbabilityTable(petList, math.pow(LUCK_BOOST,1.35))
		showNewValues(luckInfluencedTable)
	end)
end)