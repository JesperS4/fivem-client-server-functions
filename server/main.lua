---@param callback function
---@param src string
function useClientFunction(callback, src)
    if type(callback) == "function" then
        local info = debug.getinfo(callback, "S")

        if info and info.source and info.linedefined then
            local source = info.source:sub(2)
            local startLine = info.linedefined
            local endLine = info.lastlinedefined

            local file = io.open(source, "r")
            if file then
                local lines = {}
                local currentLine = 1
                for line in file:lines() do
                    if currentLine > startLine and currentLine < endLine then
                        table.insert(lines, line)
                    end
                    currentLine = currentLine + 1
                end
                file:close()
                local code = table.concat(lines, "\n")
                TriggerClientEvent("lq-lib:client:runClientFunction", src, code)
            else
                print("Cannot open source file " .. source)
            end
        else
            print("Cannot get function error.")
        end
    else
        print("Error: Callback not a function.")
    end
end

RegisterNetEvent('lq-lib:client:runServerFunction', function(code)

    if GetInvokingResource() then
        return -- server => server then return
    end

    print("Inserting code..")
    local func, err = load(code)

    if not func then 
        print("Cannot run client function " .. err)
        return
    end

    local ok, runCode = pcall(func)

    if not ok then
        print("Execution error: ", runCode)
        return
    end

    runCode()

end)