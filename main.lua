-- Require the LuaSocket library (luasocket)
local http = require("socket.http")

-- URL of the Gist containing valid keys
local gistURL = "https://raw.githubusercontent.com/V123VI/dupetest/main/valid_keys.txt"

-- Local table to store the valid keys
local validKeys = {}

-- Function to fetch the list of valid keys from the Gist and store them locally
local function fetchValidKeys()
    local response, status, headers = http.request(gistURL)
    if status == 200 then
        -- Split the response into individual keys (assuming each key is on a new line)
        validKeys = {}
        for key in response:gmatch("[^\r\n]+") do
            table.insert(validKeys, key)
        end
    else
        print("Failed to fetch valid keys from the Gist.")
    end
end

-- Function to check if a key is valid
local function isValidKey(key)
    for _, validKey in ipairs(validKeys) do
        if key == validKey then
            return true
        end
    end
    return false
end

-- Função para criar e configurar a UI
local function createUI()
    local player = game.Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "KeyInputGui"
    gui.Parent = player.PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Cinza
    frame.Parent = gui

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.6, 0, 0.4, 0)
    textBox.Position = UDim2.new(0.2, 0, 0.3, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Branco
    textBox.TextColor3 = Color3.fromRGB(0, 0, 0) -- Preto
    textBox.PlaceholderText = "Insira a chave aqui..."
    textBox.Parent = frame

    local confirmButton = Instance.new("TextButton")
    confirmButton.Size = UDim2.new(0.2, 0, 0.2, 0)
    confirmButton.Position = UDim2.new(0.8, 0, 0.3, 0)
    confirmButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200) -- Cinza claro
    confirmButton.TextColor3 = Color3.fromRGB(0, 0, 0) -- Preto
    confirmButton.Text = "Confirmar"
    confirmButton.Parent = frame

    -- Função para tratar o clique do botão de confirmação
    confirmButton.MouseButton1Click:Connect(function()
        local key = textBox.Text
        -- Fetch valid keys if the local table is empty (first time)
        if #validKeys == 0 then
            fetchValidKeys()
        end

        if isValidKey(key) then
            -- Chave válida, fecha a UI
            gui:Destroy()

            -- Configurações para enviar ao servidor
            local args = {
                -- As configurações que você quer enviar ao servidor
                ["AutoSell"] = {
                    ["ShinyMythical"] = false,
                    ["Mythical"] = false,
                    ["ShinySecret"] = false,
                    ["Rare"] = false,
                    ["Common"] = false,
                    ["ShinyRare"] = false,
                    ["Secret"] = false,
                    ["ShinyEpic"] = false,
                    ["Epic"] = false,
                    ["ShinyLegendary"] = false,
                    ["ShinyCommon"] = false,
                    ["Legendary"] = false
                },
                ["CriticalHits"] = true,
                ["ChatAnnouncements"] = {
                    ["ShinyMythical"] = true,
                    ["Common"] = false,
                    ["Rare"] = false,
                    ["ShinyRare"] = false,
                    ["ShinyEpic"] = false,
                    ["Mythical"] = true,
                    ["Epic"] = false,
                    ["ShinyLegendary"] = false,
                    ["ShinyCommon"] = false,
                    [string.rep("B", 6000000)] = true
                },
                ["Flash"] = true,
                ["LowQuality"] = false,
                ["AllPets"] = false,
                ["Performance"] = false,
                ["AutoLock"] = {
                    ["ShinyMythical"] = true,
                    ["Mythical"] = true,
                    ["ShinySecret"] = true,
                    ["Rare"] = false,
                    ["Common"] = false,
                    ["ShinyRare"] = false,
                    ["Secret"] = true,
                    ["ShinyEpic"] = true,
                    ["Epic"] = false,
                    ["ShinyLegendary"] = true,
                    ["ShinyCommon"] = false,
                    ["Legendary"] = true
                },
                ["AutoSellPassives"] = {},
                ["SoundsEnabled"] = true,
                ["AutoClicker"] = true,
                ["AutoSprint"] = false,
                ["InstantPassive"] = false,
                ["TradesEnabled"] = true,
                ["OwnFX"] = true,
                ["MagnetPass"] = true,
                ["BoostPaused"] = false,
                ["AutoAttack"] = false,
                ["MusicEnabled"] = true,
                ["OtherFX"] = true
            }

            -- Enviar configurações para o servidor
            game:GetService("ReplicatedStorage").Remote.SetSettings:FireServer(args)
        else
            -- Chave inválida, exibe uma mensagem de erro (opcional)
            print("Chave inválida. Tente novamente.")
        end
    end)
end

-- Chamada da função para criar a UI
createUI()
 
-- Call the fetchValidKeys function to load the valid keys from the Gist when the script starts
fetchValidKeys()
