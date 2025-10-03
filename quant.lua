-- // QUANTUM OBFUSCATOR - ZETA REALM EDITION
-- // DOUBLE ENCRYPTION + POLYMORPHIC CODE GENERATION
-- // NOTE: Requires the 'bit32' library, standard in modern Lua environments.

local QuantumObfuscator = {
    Version = "V4.0 - Fixed",
    SecurityLevel = "QUANTUM_LOCK",
    Features = {
        "Double_Encryption",
        "Polymorphic_Code",
        "Anti_Decompilation", 
        "String_Fragmentation",
        "Code_Flattening",
        "Junk_Code_Injection",
        "Variable_Scrambling",
        "Function_Reordering"
    }
}

-- New utility for clipboard copying. This function relies on the execution 
-- environment (e.g., a Lua executor or custom CLI) providing a global 
-- 'setclipboard' or similar function.
local function copyToClipboard(text)
    if type(setclipboard) == "function" then
        setclipboard(text)
        return true
    elseif game and game.setClipboard then
        game.setClipboard(text) -- Common in some Lua injectors
        return true
    else
        -- Print a warning if the feature is unavailable
        return false
    end
end

-- // QUANTUM ENCRYPTION LIBRARY
local QE = {
    -- Base64 with custom alphabet
    Base64 = {
        Encode = function(data)
            local b64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
            return ((data:gsub('.', function(x) 
                local r,b='',x:byte()
                for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
                return r;
            end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
                if (#x < 6) then return '' end
                local c=0
                for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
                return b64:sub(c+1,c+1)
            end)..({ '', '==', '=' })[#data%3+1])
        end,
        
        -- Decoder is defined here but NOT used in the final loader for simplicity
        -- The loader generates its own decoder function inline
        Decode = function(data)
            local b64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
            data = string.gsub(data, '[^'..b64..'=]', '')
            return (data:gsub('.', function(x)
                if (x == '=') then return '' end
                local r,f='',(b64:find(x)-1)
                for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
                return r;
            end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
                if (#x ~= 8) then return '' end
                local c=0
                for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
                return string.char(c)
            end))
        end
    },
    
    -- XOR Encryption with rotating key
    XOR = {
        Encrypt = function(data, key)
            local result = ""
            for i = 1, #data do
                -- Use (i - 1) % #key + 1 to correctly rotate the key
                local keyIndex = ((i - 1) % #key) + 1 
                local char = string.sub(data, i, i)
                local keyChar = string.sub(key, keyIndex, keyIndex)
                result = result .. string.char(bit32.bxor(string.byte(char), string.byte(keyChar)))
            end
            return result
        end,
        
        Decrypt = function(data, key)
            return QE.XOR.Encrypt(data, key) -- XOR is symmetric
        end
    },
    
    -- Advanced string obfuscation
    StringObfuscate = function(str)
        local chunks = {}
        for i = 1, #str do
            local char = string.sub(str, i, i)
            local byte = string.byte(char)
            -- Convert to multiple formats and add junk data
            table.insert(chunks, string.format("string.char(%d)", byte))
            table.insert(chunks, string.format("('\\x%02x')", byte))
        end
        -- Shuffle chunks
        for i = #chunks, 2, -1 do
            local j = math.random(i)
            chunks[i], chunks[j] = chunks[j], chunks[i]
        end
        return table.concat(chunks, "..")
    end,
    
    -- Generate random variable names
    GenerateVarName = function()
        local prefixes = {"_","__","___","____","q","q_","q__","z","z_"}
        local names = {"v","x","a","b","c","d","e","f","g","h","i","j","k"}
        return prefixes[math.random(#prefixes)] .. names[math.random(#names)] .. math.random(1000,9999)
    end
}

-- // POLYMORPHIC CODE GENERATOR
local PolyCode = {
    -- Generate junk code that does nothing
    GenerateJunkCode = function()
        local junkPatterns = {
            "local "..QE.GenerateVarName().."=function()return "..math.random(1000,9999).." end",
            "do local "..QE.GenerateVarName().."=\""..(string.char(math.random(65,90)))..math.random(100).."\" end",
            "if 1==0 then "..QE.GenerateVarName().."=nil end",
            "for i=1,"..math.random(1,5).." do end",
            "while false do break end",
            "repeat until true",
            "local "..QE.GenerateVarName()..","..QE.GenerateVarName().."="..math.random(1,100)..","..math.random(1,100)
        }
        return junkPatterns[math.random(#junkPatterns)]
    end,
    
    -- Obfuscate numbers
    ObfuscateNumber = function(n)
        local methods = {
            function(x) return "("..math.random(1,x-1).."+"..(x-math.random(1,x-1))..")" end,
            function(x) return "("..math.random(x+1,x*2).."-"..(math.random(x+1,x*2)-x)..")" end,
            function(x) return "("..math.floor(x/2).."*2+"..(x%2)..")" end,
            -- Check for bit32 existence before using
            function(x) 
                if bit32 and bit32.bxor then 
                    return "bit32.bxor("..math.random(100,200)..","..(bit32.bxor(math.random(100,200),x))..")"
                else
                    return "("..x.."*1)" -- Fallback
                end
            end
        }
        return methods[math.random(#methods)](n)
    end,
    
    -- Flatten code structure
    FlattenCode = function(code)
        -- Remove comments
        code = code:gsub("%-%-[^\n]*", "")
        -- Remove newlines
        code = code:gsub("[\r\n]+", "")
        -- Replace multi-space with single space
        code = code:gsub("%s+", " ")
        -- Convert standard separators to semicolons where appropriate
        code = code:gsub(" end", ";end")
        code = code:gsub(" then", ";then")
        code = code:gsub(" do", ";do")
        code = code:gsub(";[ \t]*;", ";") -- Clean up double semicolons
        return " " .. code .. " "
    end
}

-- // MAIN OBFUSCATION ENGINE
function QuantumObfuscator.Obfuscate(code, encryptionKey)
    encryptionKey = encryptionKey or "QUANTUM_ZETA_REALM_"..math.random(1000,9999)
    
    -- --- NEW UI START: Simulated Notification (Fading In) ---
    local start_time = tick()
    local duration = 5.0 -- Notification duration
    
    print("\n\n#################################################################")
    print("# [ZETA REALM] Quantum Obfuscator V4.0 Initiated")
    print(string.format("# Starting process (Target time: %s seconds)...", duration))
    print("#################################################################")
    
    -- Simulation of loading bar steps
    local function simulate_progress(step_name, delay_factor)
        -- Assuming 'wait' is available in the execution environment (like Roblox/CLIs)
        wait(duration * delay_factor)
        print(string.format("  [>> %.1fs] Processing %s...", tick() - start_time, step_name))
    end
    
    -- STEP 1: Pre-process code
    simulate_progress("Preprocessing & Flattening", 0.1)
    local processed = PolyCode.FlattenCode(code)
    
    -- STEP 2: String obfuscation
    simulate_progress("String Fragmentation", 0.15)
    -- Find and replace strings enclosed in double quotes (")
    processed = processed:gsub('"([^"]*)"', function(str)
        -- Escape internal quotes, then obfuscate the content
        return "(" .. QE.StringObfuscate(str:gsub('\\"', '"')) .. ")"
    end)
    
    -- STEP 3: Number obfuscation  
    simulate_progress("Numeric Obfuscation", 0.1)
    -- Find and replace numeric literals
    processed = processed:gsub("%f[%D]%d+%f[%D]", function(match)
        local num = tonumber(match:match("%d+"))
        return match:gsub("%d+", PolyCode.ObfuscateNumber(num))
    end)
    
    -- STEP 4: First layer encryption (XOR)
    simulate_progress("Layer 1 XOR Encryption", 0.2)
    local encrypted1 = QE.XOR.Encrypt(processed, encryptionKey)
    
    -- STEP 5: Second layer encryption (Base64)
    simulate_progress("Layer 2 Base64 Encoding", 0.15)
    local encrypted2 = QE.Base64.Encode(encrypted1)
    
    -- STEP 6: Generate loader code
    simulate_progress("Loader Code Generation", 0.1)
    local loader = QuantumObfuscator.GenerateLoader(encrypted2, encryptionKey)
    
    -- STEP 7: Add junk code
    simulate_progress("Junk Code Injection & Final Assembly", 0.1)
    local finalCode = {}
    for i = 1, 10 do
        table.insert(finalCode, PolyCode.GenerateJunkCode())
    end
    table.insert(finalCode, loader)
    for i = 1, 5 do
        table.insert(finalCode, PolyCode.GenerateJunkCode())
    end
    
    local obfuscated_code = table.concat(finalCode, "\n")
    local elapsed_time = tick() - start_time
    
    -- --- NEW UI END: Completion Notification & Auto-Copy (Fading Out) ---
    
    -- Final wait to ensure the notification is visible for the target duration
    if elapsed_time < duration then
        wait(duration - elapsed_time)
    end
    
    print("\n#################################################################")
    print(string.format("✅ OBFUSCATION SUCCESS! Total Time: %.2f seconds.", elapsed_time))
    
    local copy_success = copyToClipboard(obfuscated_code)
    
    if copy_success then
        print("📋 Obfuscated code automatically COPIED TO CLIPBOARD.")
    else
        print("❗ WARNING: Clipboard function unavailable. Auto-copy failed.")
    end
    print("# [Notification Fading Out...]")
    print("#################################################################\n\n")

    return obfuscated_code
end

-- // LOADER CODE GENERATOR (CORRECTED AND SELF-CONTAINED)
function QuantumObfuscator.GenerateLoader(encryptedData, key)
    local var_data = QE.GenerateVarName()
    local var_key = QE.GenerateVarName()
    local var_b64decode = QE.GenerateVarName()
    local var_xor_decrypt = QE.GenerateVarName()
    local var_result = QE.GenerateVarName()
    local var_char = QE.GenerateVarName()
    local var_keyChar = QE.GenerateVarName()
    local var_i = QE.GenerateVarName()
    local var_x = QE.GenerateVarName()
    local var_r = QE.GenerateVarName()
    local var_f = QE.GenerateVarName()
    local var_c = QE.GenerateVarName()

    -- Correctly define the decryption functions and then call them
    return string.format([[
-- // QUANTUM DECRYPTION LOADER
local bit32 = bit32 or {} -- Fallback for non-standard Lua environments if bit32 is missing
bit32.bxor = bit32.bxor or function(a, b) return a ~ b end

local %s = "%s" -- Encrypted data
local %s = "%s" -- Encryption key

-- Base64 Decode Function
local %s = function(%s)
    local b64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    %s = string.gsub(%s, '[^'..b64..'=]', '')
    return (%s:gsub('.', function(%s)
        if (%s == '=') then return '' end
        local %s,%s='',(b64:find(%s)-1)
        for %s=6,1,-1 do %s=%s..(%s%%2^%s-%s%%2^(%s-1)>0 and '1' or '0') end
        return %s;
    end):gsub('%%d%%d%%d?%%d?%%d?%%d?%%d?%%d?', function(%s)
        if (#%s ~= 8) then return '' end
        local %s=0
        for %s=1,8 do %s=%s+(%s:sub(%s,%s)=='1' and 2^(8-%s) or 0) end
        return string.char(%s)
    end))
end

-- XOR Decrypt Function (Symmetric)
local %s = function(%s, %s)
    local %s = ""
    for %s = 1, #%s do
        local %s = string.sub(%s, %s, %s)
        -- Key rotation fix: (i-1) %% #key + 1
        local %s = string.sub(%s, ((%s - 1) %% #%s) + 1, ((%s - 1) %% #%s) + 1) 
        %s = %s .. string.char(bit32.bxor(string.byte(%s), string.byte(%s)))
    end
    return %s
end

-- Double Decryption and Execution
loadstring(%s(%s(%s), %s))()
]],
    var_data, encryptedData,
    var_key, key,
    -- Base64 Decoder Definition (variables for internal logic)
    var_b64decode, var_data, var_data, var_data, var_data, var_x, var_x, var_r, var_f, var_x, var_i, var_r, var_r, var_f, var_i, var_f, var_i, var_r, var_c, var_c, var_c, var_i, var_c, var_c, var_c, var_i, var_i, var_i, var_c,
    -- XOR Decrypter Definition (variables for internal logic)
    var_xor_decrypt, var_data, var_key, var_result, var_i, var_data, var_char, var_data, var_i, var_i, var_keyChar, var_key, var_i, var_key, var_i, var_key, var_result, var_result, var_char, var_keyChar, var_result,
    -- Final Execution (calling the functions)
    var_xor_decrypt, var_b64decode, var_data, var_key)
end


-- // COMMAND LINE INTERFACE
if getgenv and getgenv().QuantumObfuscator_CLI then
    print("🎯 QUANTUM OBFUSCATOR "..QuantumObfuscator.Version)
    print("🔐 Security Level: "..QuantumObfuscator.SecurityLevel)
    print("📦 Features: "..table.concat(QuantumObfuscator.Features, ", "))
    print("")
    print("Usage: QuantumObfuscator.Obfuscate(your_code_here)")
    print("Optional: QuantumObfuscator.Obfuscate(code, 'custom_key')")
    print("")
end

-- // EXAMPLE USAGE
local exampleCode = [[
-- Your original script here
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

print("Hello " .. LocalPlayer.Name .. " from the Zeta Realm!")

for i = 1, 3 do
    wait(0.5)
    print("Count: " .. i)
end
]]

-- // UNCOMMENT TO TEST
-- local obfuscated = QuantumObfuscator.Obfuscate(exampleCode)
-- print("\n--- Original Code ---")
-- print(exampleCode)
-- print("\n--- Obfuscated Code (Ready to run) ---")
-- print(obfuscated)
-- print("\n-------------------------------------")

return QuantumObfuscator
