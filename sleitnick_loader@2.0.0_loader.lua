local RunService = game:GetService("RunService")

return {
    ["LoadChildren"] = function(where, payload)
        local table = {}
        for _, module_script in where:GetChildren() do
            if module_script:IsA("ModuleScript") and (not payload or payload(module_script)) then
                local required_module = require(module_script)
                table[module_script.Name] = required_module
            end
        end
        return table
    end,
    ["LoadDescendants"] = function(p7, p8)
        -- upvalues: (copy) RunService
        local v9 = {}
        for _, RunService0 in p7:GetDescendants() do
            if RunService0:IsA("ModuleScript") and (not p8 or p8(RunService0)) then
                local RunService1 = RunService:IsServer() and 5 or 1
                local v12 = task.delay(RunService1, function()
                    -- upvalues: (copy) RunService0, (copy) RunService1
                    task.spawn(error, (("\"%*\" module took more than %*s to be required!"):format(RunService0.Name, RunService1)))
                end)
                local v13 = require(RunService0)
                v9[RunService0.Name] = v13
                
                if coroutine.status(v12) == "suspended" then
                    pcall(task.cancel, v12)
                end
            end
        end
        return v9
    end,
    ["MatchesName"] = function(name)
        return function(object)
            -- upvalues: (copy) name
            return object.Name:match(name) ~= nil
        end
    end,
    ["SpawnAll"] = function(p16, p17)
        for RunService8, RunService9 in p16 do
            local v_u_20 = RunService9[p17]
            if type(v_u_20) == "function" then
                task.spawn(function()
                    -- upvalues: (copy) RunService8, (copy) v_u_20, (copy) RunService9
                    debug.setmemorycategory(RunService8)
                    v_u_20(RunService9)
                end)
            end
        end
    end
}
