--TODO: fix file name
--// idk this name, sorry 😭😭

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Replion = require(ReplicatedStorage.Packages.Replion)
local Freeze = require(ReplicatedStorage.Packages.Freeze)
local Trove = require(ReplicatedStorage.Packages.Trove)
require(ReplicatedStorage.Packages.Net)

local Statable = require(ReplicatedStorage.Shared.Statable)
local TradeInfo = require(ReplicatedStorage.Shared.Trading.TradeInfo)
require(ReplicatedStorage.Common.MarketplaceService)

local GuiHandler = require(ReplicatedStorage.ClientGameModules.GuiHandler)
local BitsUtil = require(ReplicatedStorage.Common.BitsUtil)
local DeviceListener = require(ReplicatedStorage.ClientGameModules.DeviceListener)
local ShopControllerAPI = require(ReplicatedStorage.Controllers.UI.ShopControllerAPI)
require(ReplicatedStorage.Shared.ItemInfo)
require(ReplicatedStorage.Shared.Inventory.InventoryTypes)

local SharedInventory = require(ReplicatedStorage.Shared.Inventory.Shared)

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local Trade = PlayerGui:WaitForChild("Trade")
local Main = Trade.Main
local RightBottom = Main.Right.Bottom
local Accept = RightBottom.Accept
local Decline = RightBottom.Decline
local Label = Main.Right.Label

local State = Statable.State
local TradeReplionState = State(nil)
local SwordState = State("Sword")
local NumberState = State(0)
local BoolStateFalse = State(false)
local PCState = State("PC")
local StringState = State("")

local currentItem = nil
local someVariable = nil
local Template = Main.Left.Items.UIGridLayout.Template

local function invokeServer(p40, ...)
    local response = { p40:InvokeServer(...) }
    if not response[1] then
        ReplicatedStorage.Misc.error:Play()
        local errorMessage = response[2]
        if type(errorMessage) == "string" then
            warn(("Request failed for %s:\n%s"):format(p40:GetFullName(), errorMessage))
        else
            warn(("Request failed for %s:\nno output"):format(p40:GetFullName()))
        end
    end
    return table.unpack(response)
end

local function createInventory(param1, param2, param3, param4)
    if table.find(TradeInfo.TradeableItemTypes, param2) then
        local tempVar = param4
        if param1 == "LOCAL" then
            param4 = nil
        end

        local troveInstance = Trove.new()
        local itemList = {}

        local function findItemsWithKey(inventoryType, key, value, additionalParam)
            if param1 == "LOCAL" then
                if tempVar and additionalParam then
                    local item = SharedInventory:KeyToItem(tempVar, additionalParam)
                    if item and item.IsSelected then
                        additionalParam = SharedInventory:ItemToKey(key, Freeze.Dictionary.removeValue(item, "IsSelected"), { "Id" })
                    end
                end
            end

            local targetInventory = (inventoryType == "Trade" and tempVar) or param4
            local items = SharedInventory:FindItemsWithKey(targetInventory, key, value, additionalParam)

            if inventoryType == "Inventory" and param1 == "LOCAL" and tempVar then
                local localItems = SharedInventory:FindItemsWithKey(tempVar, key, value, additionalParam)
                items = Freeze.List.removeValue(items, table.unpack(localItems))
            end

            return items
        end
    end
end

        local function updateSlot(item) 
    -- upvalues: (copy) inventoryType, (ref) SharedInventory, (copy) itemSlots, (copy) findItemsWithKey
    local itemKey = SharedInventory:ItemToKey(inventoryType, item, { "Id" })
    if itemKey then
        local slot = itemSlots[itemKey]
        if slot then
            local stack = slot:FindFirstChild("Stack")
            local lock = slot:FindFirstChild("Lock")
            local finisher = slot:FindFirstChild("Finisher")
            local items = findItemsWithKey(item.IsSelected and "Trade" or "Inventory", inventoryType, item.Name, itemKey)
            
            if stack and items then
                stack.Visible = #items >= 2 and inventoryType ~= "Ability"
                stack.Label.Text = ("x%d"):format(#items)
            end
            
            if inventoryType == "Sword" then
                finisher.Visible = item and item.Finisher ~= nil
            end
            
            if lock then
                lock.Visible = item and (item.TradeLock ~= nil and inventoryType ~= "Ability")
            end
            
            local elements = { stack, finisher }
            for i = #elements, 1, -1 do
                if elements[i] == nil then
                    table.remove(elements, i)
                end
            end
            
            local elementPositions = {}
            for _, element in ipairs(elements) do
                local position = element:GetAttribute("Position") or element.Position
                element:SetAttribute("Position", position)
                elementPositions[_] = position
            end
            
            local posIndex = 1
            for _, element in ipairs(elements) do
                if element.Visible then
                    element.Position = elementPositions[posIndex] or element.Position
                    posIndex = posIndex + 1
                end
            end
        end
    end
end

local function createSlot(item)
    -- upvalues: (copy) inventoryType, (ref) SharedInventory, (copy) findItemsWithKey, (copy) itemSlots, (copy) updateSlot, (ref) ShopControllerAPI, (copy) slotContainer, (ref) slotTemplate, (ref) itemInfo, (ref) state, (ref) isLocal, (ref) ReplicatedStorage, (ref) invokeServer
    local itemKey = SharedInventory:ItemToKey(inventoryType, item, { "Id" })
    if itemKey then
        if #findItemsWithKey(item.IsSelected and "Trade" or "Inventory", inventoryType, item.Name, itemKey) <= 0 then
            return
        elseif itemSlots[itemKey] then
            updateSlot(item)
        else
            local itemData = ShopControllerAPI:GetItemInfo(inventoryType, item.Name)
            if itemData then
                local slot = slotTemplate:Clone(slotContainer)
                itemSlots[itemKey] = slot
                slot.ItemName.Text = itemData.DisplayName or itemData.Name
                slot.Vector.Image = itemData.Icon
                slot:SetAttribute("InventoryType", inventoryType)
                slot:SetAttribute("HoverKey", itemKey)
                slot:AddTag("HoverInfo")
                
                local rarity = itemData.Rarity
                if rarity then
                    local slotColor = itemInfo.SlotColors[rarity] or itemInfo.SlotColors.Default
                    slot.Image = slotColor.Image
                    slot.HoverImage = slotColor.HoverImage
                    slot.ItemName.UIStroke.Color = slotColor.StrokeColor
                end
                
                local computedCheckmark = state.setPropertyComputed(slot.Checkmark, "Visible", function(currentState)
                    return item.IsSelected ~= nil and not currentState(state)
                end)
                if computedCheckmark then
                    slotContainer:Add(computedCheckmark)
                end
                
                if inventoryType == "Sword" or inventoryType == "Explosion" then
                    local itemDetails = ShopControllerAPI:GetItemData(itemData)
                    local rarityOrder = ShopControllerAPI.RarityOrder[itemData.Rarity] or 0
                    if itemData.Name ~= "Base Sword" and itemData.Name ~= "Explosion Normal" then
                        rarityOrder = rarityOrder + 1
                    end
                    local slotName = ("%s%s|%s"):format(not item.TradeLock and "" or string.char(126), rarityOrder, itemData.Name)
                    state.setPropertyComputed(slot, "Name", function(currentState)
                        local isFavorited = currentState(itemDetails.IsFavorited)
                        if item.IsSelected then
                            return ("%s%s"):format(string.char(32), slotName)
                        elseif isFavorited and not item.TradeLock then
                            return ("!%s"):format(slotName)
                        else
                            return slotName
                        end
                    end)
                    state.setPropertyState(slot.FavoritedTemplate, "Visible", itemDetails.IsFavorited)
                else
                    local slotName = ("%s%s"):format(not item.TradeLock and "" or string.char(126), itemData.Name)
                    if item.IsSelected then
                        slotName = ("%s%s"):format(string.char(32), slotName)
                    end
                    slot.Name = slotName
                end
                
                slot.Parent = slotContainer
                if isLocal == "LOCAL" then
                    local computedVisible = state.setPropertyComputed(slot, "Visible", function(currentState)
                        return currentState(state) == inventoryType and not currentState(state) or item.IsSelected
                    end)
                    if computedVisible then
                        slotContainer:Add(computedVisible)
                    end
                    
                    if not item.TradeLock then
                        slotContainer:Add(slot.ActivationButton.Activated:Connect(function()
                            if state:Get() then return end
                            local items = findItemsWithKey(item.IsSelected and "Trade" or "Inventory", inventoryType, item.Name, itemKey)
                            if #items <= 0 then
                                ReplicatedStorage.Misc.error:Play()
                            elseif item.IsSelected then
                                invokeServer(itemInfo.Remotes.RemoveItemFromTrade, inventoryType, items[1])
                            else
                                invokeServer(itemInfo.Remotes.AddItemToTrade, inventoryType, items[1])
                            end
                        end))
                    end
                end
                
                slot.Destroying:Once(function()
                    pcall(slotContainer.Remove, slotContainer, slot)
                end)
                updateSlot(item)
                return slot
            end
            warn(("Failed to find info for %s: \"%s\""):format(inventoryType, item.Name))
        end
    end
end

local function tryRemoveSlot(item)
    -- upvalues: (copy) inventoryType, (ref) SharedInventory, (copy) itemSlots, (copy) findItemsWithKey
    local itemKey = SharedInventory:ItemToKey(inventoryType, item, { "Id" })
    if itemKey and itemSlots[itemKey] then
        if #findItemsWithKey(item.IsSelected and "Trade" or "Inventory", inventoryType, item.Name, itemKey) <= 0 then
            local slot = itemSlots[itemKey]
            if slot then
                slot:Destroy()
            end
            itemSlots[itemKey] = nil
            return true
        end
    end
end

local function onChange(item, changeType, previousItem)
    -- upvalues: (copy) createSlot, (copy) tryRemoveSlot, (copy) updateSlot
    if changeType == "Insert" then
        createSlot(item)
    elseif changeType == "Remove" then
        if not tryRemoveSlot(item) then
            updateSlot(item)
        end
    elseif changeType == "Change" then
        createSlot(item)
        if previousItem and not tryRemoveSlot(previousItem) then
            updateSlot(previousItem)
        end
    end
end

        local itemList = v_u_13:Get(p_u_46, p_u_44)
if itemList then
    for _, item in itemList do
        onChange(item, "Insert", nil)
    end
end

local changeHandler = v_u_13:OnChange(p_u_46, p_u_44, onChange)
if changeHandler then
    v_u_48:Add(changeHandler)
end

if p_u_43 == "LOCAL" then
    local function onChange(localItem, changeType, previousItem) -- line: 359
        -- upvalues: (ref) v_u_5, (copy) createSlot, (copy) tryRemoveSlot, (copy) updateSlot
        local newItem = v_u_5.Dictionary.merge(localItem, { ["IsSelected"] = true })
        if previousItem then
            previousItem = v_u_5.Dictionary.merge(previousItem, { ["IsSelected"] = true })
        end
        
        if changeType == "Insert" then
            createSlot(newItem)
        elseif changeType == "Remove" then
            if not tryRemoveSlot(newItem) then
                updateSlot(newItem)
            end
            createSlot(localItem)
        elseif changeType == "Change" then
            createSlot(newItem)
            if previousItem and not tryRemoveSlot(previousItem) then
                updateSlot(previousItem)
            end
        end

        if not tryRemoveSlot(localItem) then
            updateSlot(localItem)
        end
    end

    local localItemList = v_u_13:Get(v_u_47, p_u_44)
    if localItemList then
        for _, item in localItemList do
            onChange(item, "Insert", nil)
        end
    end

    local localChangeHandler = v_u_13:OnChange(v_u_47, p_u_44, onChange)
    if localChangeHandler then
        v_u_48:Add(localChangeHandler)
    end
end

return v_u_48

function v39.StartTrade(_, tradePartner) -- line: 407
    -- upvalues: (copy) v_u_9, (copy) v_u_24
    v_u_9:CloseCurrent(true)
    v_u_9:Lock("Trade", true)
    v_u_24:Set(tradePartner)
end

function v39.Clear(_) -- line: 414
    -- upvalues: (copy) v_u_9, (copy) v_u_24
    v_u_9:Unlock("Trade", true)
    v_u_24:Set(nil)
end

function v39.Start(context) -- line: 419
    -- upvalues: (ref) v_u_21, (copy) v_u_4, (ref) v_u_22, (copy) v_u_24, (copy) v_u_15, (copy) v_u_8, (copy) v_u_16, (copy) v_u_7, (copy) v_u_25, (copy) v_u_27, (copy) v_u_10, (copy) v_u_26, (copy) invokeServer, (copy) v_u_14, (copy) v_u_18, (copy) v_u_19, (copy) v_u_36, (copy) v_u_37, (copy) v_u_28, (copy) v_u_31, (copy) v_u_33, (copy) v_u_30, (copy) v_u_20, (copy) v_u_17, (ref) v_u_38, (copy) v_u_11, (copy) v_u_34, (copy) v_u_35, (copy) v_u_29, (copy) v_u_32, (copy) v_u_5, (copy) createInventory, (copy) v_u_2

    v_u_21 = v_u_4.Client:WaitReplion("Data")
    v_u_22 = v_u_4.Client:WaitReplion("Inventory")

    v_u_4.Client:OnReplionAddedWithTag("Trade", function(newTrade)
        if v_u_24:Get() then
            warn("[OnReplionAddedWithTag] There is a Trade running already")
        else
            context:StartTrade(newTrade)
        end
    end)

    v_u_4.Client:OnReplionRemovedWithTag("Trade", function(removedTrade)
        if removedTrade == v_u_24:Get() then
            context:Clear()
        else
            warn("[OnReplionRemovedWithTag] Failed to clear Trade")
        end
    end)

    v_u_15:GetPropertyChangedSignal("Enabled"):Connect(function()
        if not v_u_15.Enabled and v_u_24:Get() then
            v_u_8.Remotes.CancelTrade:InvokeServer()
        end
    end)

    for _, sideButton in v_u_16.SideButtons:GetChildren() do
        if sideButton:IsA("ImageButton") then
            v_u_7.Computed(function(getState)
                local isActive = getState(v_u_25) == sideButton.Name
                sideButton.Image = isActive and "rbxassetid://18123223527" or "rbxassetid://18123248161"
                sideButton.HoverImage = isActive and "rbxassetid://18123872657" or "rbxassetid://18123874724"
                sideButton.Label.UIStroke.Color = isActive and Color3.fromRGB(149, 67, 0) or Color3.fromRGB(21, 56, 169)
                sideButton.Visible = not getState(v_u_27)
                return nil
            end)

            sideButton.Activated:Connect(function()
                v_u_16.Left.Items.CanvasPosition = Vector2.zero
                v_u_25:Set(sideButton.Name)
            end)
        end
    end

    local tokensPath = v_u_7.getReplionPathState(v_u_22, "Tokens")
    v_u_7.setPropertyComputed(v_u_16.Currency.Coins.Amount, "Text", function(getState)
        return v_u_10.ValueConvertor:AddCommas(getState(tokensPath))
    end)

    local tokenInput = v_u_16.Left.Tokens.EnterAmount
    local abbreviations = { "k", "m", "b", "t" }
    tokenInput.FocusLost:Connect(function()
        local userInput = string.lower(tokenInput.Text)
        for i, abbreviation in ipairs(abbreviations) do
            local matchValue = string.match(userInput, ("^([%d%.]*)%s*$"):format(abbreviation)) or ""
            local numberValue = tonumber(matchValue)
            if not numberValue then
                continue
            end
            local convertedValue = numberValue * 1000 ^ i
            userInput = tostring(convertedValue)
            break
        end

        local numericValue = tonumber(string.gsub(userInput, "%D+", "")) or 0
        local clampedValue = math.clamp(numericValue, 0, tokensPath:Get())
        v_u_26:Set(clampedValue)
        tokenInput.Text = v_u_10.ValueConvertor:AddCommas(clampedValue)

        local tradeUpdateSuccess = not invokeServer(v_u_8.Remotes.AddTokensToTrade, clampedValue) and v_u_24:Get()
        if tradeUpdateSuccess then
            v_u_26:Set(tradeUpdateSuccess:Get({tostring(v_u_14.UserId), "Tokens"}) or 0)
            tokenInput.Text = v_u_10.ValueConvertor:AddCommas(v_u_26:Get())
        end
    end)

    local confirmButton = v_u_18
    local confirmState = v_u_7.State("Green")
    local readyState = v_u_7.State("Ready")

    v_u_7.Computed(function(getState)
        local state = getState(confirmState)
        local label = getState(readyState)
        confirmButton.Label.Text = label

        if state == "Green" then
            confirmButton.Active = true
            confirmButton.Image = "rbxassetid://18123799353"
            confirmButton.HoverImage = "rbxassetid://18123825435"
            confirmButton.Label.UIStroke.Color = Color3.fromRGB(1, 86, 0)
        elseif state == "Red" then
            confirmButton.Active = true
            confirmButton.Image = "rbxassetid://18123810348"
            confirmButton.HoverImage = "rbxassetid://18123830153"
            confirmButton.Label.UIStroke.Color = Color3.fromRGB(86, 0, 0)
        else
            confirmButton.Active = false
            confirmButton.Image = "rbxassetid://18526787517"
            confirmButton.HoverImage = "rbxassetid://18526787649"
            confirmButton.Label.UIStroke.Color = Color3.fromRGB(41, 41, 41)
        end

        return nil
    end)

    local declineButton = v_u_19
    local declineState = v_u_7.State("Red")
    local declineLabel = v_u_7.State("Decline")

    v_u_7.Computed(function(getState)
        local state = getState(declineState)
        local label = getState(declineLabel)
        declineButton.Label.Text = label

        if state == "Green" then
            declineButton.Active = true
            declineButton.Image = "rbxassetid://18123799353"
            declineButton.HoverImage = "rbxassetid://18123825435"
            declineButton.Label.UIStroke.Color = Color3.fromRGB(1, 86, 0)
        elseif state == "Red" then
            declineButton.Active = true
            declineButton.Image = "rbxassetid://18123810348"
            declineButton.HoverImage = "rbxassetid://18123830153"
            declineButton.Label.UIStroke.Color = Color3.fromRGB(86, 0, 0)
        else
            declineButton.Active = false
            declineButton.Image = "rbxassetid://18526787517"
            declineButton.HoverImage = "rbxassetid://18526787649"
            declineButton.Label.UIStroke.Color = Color3.fromRGB(41, 41, 41)
        end

        return nil
    end)
    
    return v_u_48
end

    local function getCountdown() -- line: 621
    -- upvalues: (ref) v_u_24, (ref) v_u_8
    local tradeInfo = v_u_24:Get()
    if tradeInfo then
        local currentTime = workspace:GetServerTimeNow()
        local confirmedTime = tradeInfo:Get("ConfirmedTime") or 0
        local lastChangeTime = tradeInfo:Get("LastChange") or 0

        if confirmedTime > 0 then
            local elapsed = currentTime - confirmedTime
            return v_u_8.ConfirmedCountdown + 0.05 - elapsed, elapsed
        else
            local elapsed = currentTime - lastChangeTime
            return v_u_8.ItemChangeCountdown + 0.05 - elapsed, elapsed
        end
    end
end

local function updateCountdown() -- line: 643
    -- upvalues: (copy) getCountdown, (ref) v_u_36, (ref) v_u_38
    local remainingTime, _ = getCountdown()
    if remainingTime and remainingTime <= 0 then
        v_u_36:Set(0)
    elseif remainingTime then
        v_u_36:Set(remainingTime)
    end

    if not remainingTime and v_u_38 then
        v_u_38:Disconnect()
        v_u_38 = nil
    end
end

local countdownHandler = v_u_11.new()
local chatMessages = {}

local function updateChatMessages(forceUpdate) -- line: 666
    -- upvalues: (ref) v_u_16, (copy) chatMessages
    local chatFrame = v_u_16.Chat.PC.Visible and v_u_16.Chat.PC.Frame or v_u_16.Chat.Misc.Frame
    for _, message in ipairs(chatMessages) do
        if not message.Parent or forceUpdate then
            message.Parent = chatFrame.ChatList
        end
    end
end

local function onDeviceChanged(deviceType) -- line: 678
    -- upvalues: (ref) v_u_34
    v_u_34:Set(deviceType)
end

countdownHandler:RegisterDeviceChanged(onDeviceChanged)
task.spawn(onDeviceChanged, countdownHandler.Device)

v_u_7.Computed(function(getState)
    -- upvalues: (ref) v_u_34, (ref) v_u_35, (ref) v_u_16, (copy) updateChatMessages
    local deviceType = getState(v_u_34)
    v_u_16.Chat.PC.Visible = deviceType == "PC"
    
    local chatMiscVisible = not v_u_16.Chat.PC.Visible and deviceType ~= "Console"
    v_u_16.Chat.Misc.Visible = chatMiscVisible

    updateChatMessages()
end)

v_u_7.setPropertyComputed(v_u_16, "Size", function(getState)
    -- upvalues: (ref) v_u_34
    local deviceType = getState(v_u_34)
    return deviceType == "Phone" or deviceType == "Tablet" 
        and UDim2.fromScale(0.65, 0.75) or UDim2.fromScale(0.65, 0.65)
end)

v_u_7.setPropertyComputed(v_u_16.Left.Items.UIGridLayout, "CellSize", function(getState)
    -- upvalues: (ref) v_u_34
    local deviceType = getState(v_u_34)
    return (deviceType == "Phone" or deviceType == "Tablet")
        and UDim2.fromScale(0.4, 0.4) or UDim2.fromScale(0.31, 0.31)
end)

v_u_7.setPropertyComputed(v_u_16.Right.Items.UIGridLayout, "CellSize", function(getState)
    -- upvalues: (ref) v_u_34
    local deviceType = getState(v_u_34)
    return (deviceType == "Phone" or deviceType == "Tablet")
        and UDim2.fromScale(0.56, 0.56) or UDim2.fromScale(0.43, 0.43)
end)

local lastChatSendTime = 0

local function sendText(inputBox) -- line: 716
    -- upvalues: (ref) v_u_10, (ref) v_u_8, (ref) lastChatSendTime, (ref) invokeServer
    local messageText = inputBox.Text
    local placeholderText = ""
    inputBox.TextEditable = false

    local cooldownHandler
    cooldownHandler = task.delay(2, function()
        inputBox.TextEditable = true
        cooldownHandler = nil
    end)

    local function cancelCooldown()
        inputBox.Text = placeholderText
        if cooldownHandler then
            inputBox.TextEditable = true
            v_u_10.Thread.SafeCancel(cooldownHandler)
            cooldownHandler = nil
        end
    end

    if #messageText > v_u_8.Chat.MaxMessageLength then
        inputBox.Text = ("Text too long (%*/%*)"):format(messageText, v_u_8.Chat.MaxMessageLength)
        task.delay(0.5, cancelCooldown)
    elseif #messageText < v_u_8.Chat.MinMessageLength and messageText ~= "" then
        inputBox.Text = ("Text too small (%*/%*)"):format(messageText, v_u_8.Chat.MinMessageLength)
        task.delay(0.5, cancelCooldown)
    else
        local currentTime = os.clock()
        if currentTime - lastChatSendTime < v_u_8.Chat.Cooldown then
            inputBox.Text = "Please wait before sending another message"
            placeholderText = messageText
            task.delay(0.5, cancelCooldown)
        else
            inputBox.Text = ""
            lastChatSendTime = currentTime
            invokeServer(v_u_8.Remotes.SendChatMessage, messageText)
            inputBox.Text = placeholderText
            if cooldownHandler then
                inputBox.TextEditable = true
                v_u_10.Thread.SafeCancel(cooldownHandler)
                cooldownHandler = nil
            end
        end
    end
end

local chatPC = v_u_16.Chat.PC
local chatPCInput = chatPC.Frame.InputBox.EnterAmount

chatPCInput.FocusLost:Connect(function(entered)
    -- upvalues: (copy) sendText, (copy) chatPCInput
    if entered then
        sendText(chatPCInput)
    end
end)

chatPC.Frame.InputBox.Activated:Connect(function()
    -- upvalues: (copy) chatPCInput
    chatPCInput:CaptureFocus()
end)

local chatMisc = v_u_16.Chat.Misc
local chatMiscButton = chatMisc.Frame.ChatButton.EnterText

chatMisc.Frame.ChatButton.SendButton.Activated:Connect(function()
    -- upvalues: (copy) sendText, (copy) chatMiscButton
    sendText(chatMiscButton)
end)

chatMisc.Frame.ChatButton.Activated:Connect(function()
    -- upvalues: (copy) chatMiscButton
    chatMiscButton:CaptureFocus()
end)

chatMisc.Frame.Close.Activated:Connect(function()
    -- upvalues: (copy) chatMisc
    chatMisc.Frame.Visible = false
end)

chatMisc.ChatButton.Activated:Connect(function()
    -- upvalues: (copy) chatMisc
    chatMisc.Frame.Visible = not chatMisc.Frame.Visible
end)

local inventoryHandlers = {}

v_u_7.Computed(function(getState)
    -- upvalues: (ref) v_u_24, (ref) v_u_15, (copy) inventoryHandlers, (copy) chatMessages, (ref) v_u_38, (ref) v_u_37, (ref) v_u_25, (ref) v_u_26, (ref) v_u_36, (ref) v_u_27, (ref) v_u_28, (ref) v_u_29, (ref) v_u_30, (ref) v_u_31, (ref) v_u_32, (ref) v_u_33, (ref) v_u_35, (copy) updateChatMessages, (ref) v_u_10, (copy) chatMisc, (copy) chatPC, (ref) v_u_5, (ref) v_u_8, (ref) createInventory, (copy) getCountdown, (ref) v_u_2, (copy) updateCountdown
    local tradeData = getState(v_u_24)
    v_u_15.Enabled = tradeData ~= nil

    if tradeData then
        local tradeId = getState(v_u_7.getReplionPathState(tradeData, "TradeId"))
        local lastChange = getState(v_u_7.getReplionPathState(tradeData, "LastChange"))
        local processing = getState(v_u_7.getReplionPathState(tradeData, "Processing"))
        local confirmedTime = getState(v_u_7.getReplionPathState(tradeData, "ConfirmedTime"))
        local players = getState(v_u_7.getReplionPathState(tradeData, "Players"))

        v_u_35:Set(getState(v_u_7.getReplionPathState(tradeData, "CanChat")))

        for id, chatMessage in pairs(getState(v_u_7.getReplionPathState(tradeData, "Chat"))) do
            local chatEntry = chatMessages[id] or v_u_16.Chat.Templates:FindFirstChild(chatMessage.Sender == v_u_14 and "Player1" or "Player2"):Clone()
            chatEntry.Text = ("[%*]: %*"):format(chatMessage.Sender.DisplayName, chatMessage.Message)
            chatMessages[id] = chatEntry
        end
        updateChatMessages()

        local allReady = true
        local allConfirmed = true

        for _, player in pairs(players) do
            local userId = tostring(player.UserId)
            local ready = getState(v_u_7.getReplionPathState(tradeData, { userId, "Ready" }))
            local confirmed = getState(v_u_7.getReplionPathState(tradeData, { userId, "Confirmed" }))
            getState(v_u_7.getReplionPathState(tradeData, { userId, "Tokens" }))

            if not ready then allReady = false end
            if not confirmed then allConfirmed = false end
        end

        for _, player in pairs(players) do
            local userId = tostring(player.UserId)
            local isLocal = player == v_u_14
            local playerFrame = isLocal and v_u_16.Left or v_u_16.Right
            local playerId = isLocal and "LOCAL" or userId

            playerFrame.Top.ProfilePicture.Headshot.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=100&h=100"):format(userId)

            local readyOverlay = playerFrame.ReadyOverlay
            local confirmedOverlay = playerFrame.ConfirmedOverlay

            local ready = getState(v_u_7.getReplionPathState(tradeData, { userId, "Ready" }))
            local confirmed = getState(v_u_7.getReplionPathState(tradeData, { userId, "Confirmed" }))
            local tokens = getState(v_u_7.getReplionPathState(tradeData, { userId, "Tokens" }))

            readyOverlay.Visible = ready and not allReady
            confirmedOverlay.Visible = confirmed or processing

            if isLocal then
                v_u_28:Set(ready)
                v_u_31:Set(confirmed)
                if allReady then
                    playerFrame.Tokens.EnterAmount.Text = v_u_10.ValueConvertor:AddCommas(tokens or 0)
                end
            else
                v_u_29:Set(ready)
                v_u_32:Set(confirmed)
                playerFrame.Top.PlayerName.Text = ("%*\'s Offer"):format(player.DisplayName)
                playerFrame.TokenOffer.Amount.Amount.Text = v_u_10.ValueConvertor:AddCommas(tokens or 0)
                chatMisc.Frame.Title.Text = ("Chat with %*"):format(player.DisplayName)
                chatPC.Frame.Title.Text = ("Chat with %*"):format(player.DisplayName)
            end

            if not inventoryHandlers[playerId] then
                inventoryHandlers[playerId] = {}
                local inventoryData = {
                    ["Type"] = "FakeCaller",
                    ["CustomType"] = "Trading",
                    ["ModifyPath"] = function(path)
                        -- upvalues: (ref) v_u_5, (copy) playerId
                        local newPath = { playerId, "Items" }
                        return v_u_5.List.concat(newPath, v_u_5.List.shift(path))
                    end,
                    ["Replion"] = tradeData
                }

                for _, itemType in ipairs(v_u_8.TradeableItemTypes) do
                    inventoryHandlers[playerId][itemType] = createInventory(playerId, itemType, playerFrame.Items, inventoryData)
                end
            end
        end

        if getCountdown() then
            if not v_u_38 then
                v_u_38 = v_u_2.PostSimulation:Connect(updateCountdown)
            end
        elseif v_u_38 then
            v_u_38:Disconnect()
            v_u_38 = nil
        end

        v_u_27:Set(allReady)
        v_u_30:Set(allConfirmed)
        v_u_33:Set(processing)

        if processing or confirmedTime > 0 then
            v_u_37:Set("Processing Trade")
        elseif allConfirmed or not allReady then
            v_u_37:Set("")
        else
            v_u_37:Set("Countdown starts when both players confirm")
        end
    else
        -- Clean up if no trade data
        for _, handlerGroup in pairs(inventoryHandlers) do
            for _, handler in pairs(handlerGroup) do
                handler:Destroy()
            end
        end
        table.clear(inventoryHandlers)

        for _, message in pairs(chatMessages) do
            message:Destroy()
        end
        table.clear(chatMessages)

        if v_u_38 then
            v_u_38:Disconnect()
            v_u_38 = nil
        end

        -- Reset UI elements
        v_u_37:Set("")
        v_u_25:Set("Sword")
        v_u_26:Set(0)
        v_u_36:Set(0)
        v_u_27:Set(false)
        v_u_28:Set(false)
        v_u_29:Set(false)
        v_u_30:Set(false)
        v_u_31:Set(false)
        v_u_32:Set(false)
        v_u_33:Set(false)
        v_u_35:Set(false)
        v_u_121.Text = ""
    end
end)

return v39

