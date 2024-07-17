return function(payload)
    local table = {}
    return function(data)
        -- upvalues: (copy) table, (copy) payload
        local unknown_integer = (table[data] or 0) + 1
        
        table[data] = unknown_integer
        if payload <= unknown_integer then
            table[data] = nil
            task.wait()
        end
    end
end
