local HttpService = game:GetService("HttpService")
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

-- Função para obter o conteúdo do arquivo no GitHub
local function getGitHubFileContents(url)
    local response = game:GetService("HttpService"):RequestAsync({
        Url = url,
        Method = "GET"
    })

    if response.Success then
        return response.Body
    end

    return nil
end

-- Função para tratar o clique do botão de confirmação
confirmButton.MouseButton1Click:Connect(function()
    local key = textBox.Text

    -- URL do arquivo no GitHub (substitua pela URL do seu arquivo)
    local githubFileURL = "https://raw.githubusercontent.com/seu_usuario/seu_repositorio/master/settings.json"
    local fileContents = getGitHubFileContents(githubFileURL)

    if fileContents then
        local settings = HttpService:JSONDecode(fileContents)
        local allowedKey = settings.allowedKey

        if key == allowedKey then
            -- Chave válida, fecha a UI
            gui:Destroy()

            -- Restante do código permanece o mesmo...
        else
            -- Chave inválida, exibe uma mensagem de erro (opcional)
            print("Chave inválida. Tente novamente.")
        end
    else
        -- Não foi possível obter o conteúdo do arquivo, exibe uma mensagem de erro (opcional)
        print("Erro ao obter a chave. Verifique a URL do arquivo no GitHub.")
    end
end)
