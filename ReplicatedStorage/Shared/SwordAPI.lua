local collection = script.Collection

return {
    _getAnimationInCollections = function(_, collections, attributeName)
        local animations = {}
        
        for _, collectionItem in pairs(collections) do
            if collectionItem then
                local found = false
                
                for _, child in ipairs(collectionItem:GetChildren()) do
                    if child:GetAttribute(attributeName) then
                        table.insert(animations, child)
                        found = true
                    end
                end
                
                if found then
                    break
                end
            end
        end
        
        return animations
    end,
    
    GetAnimations = function(self, attributeName, collectionName1, collectionName2, defaultCollectionName)
        local searchCollections = {}
        
        if collectionName1 then
            collectionName1 = collection:FindFirstChild(collectionName1)
        end
        
        if collectionName2 then
            collectionName2 = collection:FindFirstChild(collectionName2)
        end
        
        local defaultCollection = not defaultCollectionName and collection.Default or defaultCollectionName
        
        table.insert(searchCollections, collectionName1)
        table.insert(searchCollections, collectionName2)
        table.insert(searchCollections, defaultCollection)
        
        if type(attributeName) == "string" then
            return self:_getAnimationInCollections(searchCollections, attributeName)
        end
        
        for _, attrName in ipairs(attributeName) do
            local animations = self:_getAnimationInCollections(searchCollections, attrName)
            
            if #animations > 0 then
                return animations
            end
        end
        
        return {}
    end
}