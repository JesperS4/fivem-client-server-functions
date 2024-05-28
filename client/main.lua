local randomSecret <const> = "randomSecret"

RegisterNetEvent('lq-lib:client:runClientFunction', function(code)

    if GetInvokingResource() then
        return -- client => client then return
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


---@param callback function
function useServerFunction(callback)
    if type(callback) == "function" then
        local info = debug.getinfo(callback, "S")

        if info and info.source and info.linedefined then
            local resourceName = GetInvokingResource()
            local sourceFile = info.source:sub(2)  -- Remove the '@' character at the start
            local startLine = info.linedefined
            local endLine = info.lastlinedefined

            local fileContent = LoadResourceFile(resourceName, sourceFile)
            if fileContent then
                local lines = {}
                local currentLine = 1
                for line in fileContent:gmatch("[^\r\n]+") do
                    if currentLine > startLine and currentLine < endLine then
                        table.insert(lines, line)
                    end
                    currentLine = currentLine + 1
                end
                local code = table.concat(lines, "\n")
                TriggerServerEvent("lq-lib:client:runServerFunction", code)
            else
                print("Cannot open source file " .. sourceFile)
            end
        else
            print("Cannot get function info.")
        end
    else
        print("Error: Callback is not a function.")
    end
end