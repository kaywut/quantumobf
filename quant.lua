-- // QUANTUM OBFUSCATOR - OMEGA VOID EDITION
-- // TRIPLE ENCRYPTION + FRACTURED KEY HIDING
-- // NOTE: Designed for maximum difficulty in static analysis.

local QuantumObfuscator = {
    Version = "V5.1 - Error Fixed/Void Finalized", -- Updated version number
    SecurityLevel = "OMEGA_QUANTUM_VOID", -- The ultimate security level
    Features = {
        "Triple_Encryption (Shift -> XOR -> Base64)",
        "Fractured_Key_Obfuscation (Key is mathematical equations)",
        "Polymorphic_Code",
        "Opaque_Predicates (Anti-Analysis)", 
        "String_Fragmentation",
        "Code_Flattening",
        "Junk_Code_Injection",
        "Variable_Scrambling",
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
    -- Base64 with custom alphabet (standard)
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
    },
    
    -- XOR Encryption with rotating key
    XOR = {
        Encrypt = function(data, key)
            local result = ""
            for i = 1, #data do
                local keyIndex = ((i - 1) % #key) + 1 
                local char = string.sub(data, i, i)
                local keyChar = string.sub(key, keyIndex, keyIndex)
                result = result .. string.char(bit32.bxor(string.byte(char), string.byte(keyChar)))
            end
            return result
        end,
    },

    -- NEW LAYER 1: Byte Shift Encryption
    ByteShift = {
        Encrypt = function(data, offset)
            local result = {}
            for i = 1, #data do
                -- Shift by the fixed offset, wrapping around 256
                local byte = string.byte(data, i)
                local shifted = (byte + offset) % 256
                table.insert(result, string.char(shifted))
            end
            return table.concat(result)
        end,
        Decrypt = function(data, offset)
            local result = {}
            for i = 1, #data do
                -- Decrypt by shifting back
                local byte = string.byte(data, i)
                local shifted = (byte - offset + 256) % 256 -- Add 256 to ensure positive result before modulo
                table.insert(result, string.char(shifted))
            end
            return table.concat(result)
        end,
    },
    
    -- Advanced string obfuscation
    StringObfuscate = function(str)
        local chunks = {}
        for i = 1, #str do
            local char = string.sub(str, i, i)
            local byte = string.byte(char)
            -- Store as fragmented math operations for confusion
            table.insert(chunks, string.format("string.char(%d+%d-%d)", byte-math.random(1, 10), math.random(1, 10), 0))
            table.insert(chunks, string.format("('\\x%02x')", byte))
        end
        -- Shuffle chunks
        for i = #chunks, 2, -1 do
            local j = math.random(i)
            chunks[i], chunks[j] = chunks[j], chunks[i]
        end
        return table.concat(chunks, "..")
    end,

    -- Fragment and encode the key using math
    ObfuscateKey = function(key)
        local fragments = {}
        for i = 1, #key do
            local byte = string.byte(key, i)
            local a = math.random(1, 25)
            local b = math.random(1, 25)
            local sum = byte + a + b
            -- Store as a subtraction problem requiring calculation
            table.insert(fragments, string.format("string.char(%d - (%d+%d))", sum, a, b))
        end
        return table.concat(fragments, "..")
    end,
    
    -- Generate random variable names
    GenerateVarName = function()
        local prefixes = {"_","__","___","q","z","omega","void","lock_"}
        local names = {"v","x","a","b","c","d","e","f","g","h","i","j","k"}
        return prefixes[math.random(#prefixes)] .. names[math.random(#names)] .. math.random(1000,9999)
    end
}

-- // POLYMORPHIC CODE GENERATOR
local PolyCode = {
    -- Generate complex junk code
    GenerateJunkCode = function()
        local junkPatterns = {
            "local "..QE.GenerateVarName().."=function(a,b)return a^b>0 and "..math.random(10,50).." or "..math.random(51,100).." end",
            "do local "..QE.GenerateVarName().."=\""..(string.char(math.random(65,90)))..math.random(100).."\" if (1==1) or (nil) then print(nil) end end",
            "if (not false) and (not (1==0)) then local "..QE.GenerateVarName().."=os.time() end",
            "for i=1,"..math.random(2,8).." do local a,b=1,2; a=b+a; end",
            "local "..QE.GenerateVarName().."="..math.random(1,100).."*2; repeat "..QE.GenerateVarName().."="..QE.GenerateVarName().."-1 until "..QE.GenerateVarName().."<"..math.random(1,50),
        }
        return junkPatterns[math.random(#junkPatterns)]
    end,
    
    -- Obfuscate numbers
    ObfuscateNumber = function(n)
        local methods = {
            function(x) return "("..math.random(1,x-1).."+"..(x-math.random(1,x-1))..")" end,
            function(x) return "("..math.random(x+1,x*2).."-"..(math.random(x+1,x*2)-x)..")" end,
            function(x) return "("..math.floor(x/2).."*2+"..(x%2)..")" end,
            -- Highly opaque predicate check
            function(x) 
                local r = math.random(10, 50)
                local p = math.random(1, 10)
                local q = math.random(1, 10)
                -- This IF statement always evaluates to the ELSE block, resulting in 'x'
                return string.format("((%d > %d) and (%d == %d)) and (%d) or (%d + %d - %d)", p, q, p, q, r, x, 0, 0)
            end,
            -- Bitwise op
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
        -- Remove comments and aggressive whitespace flattening
        code = code:gsub("%-%-[^\n]*", "")
        code = code:gsub("[\r\n]+", "")
        code = code:gsub("%s+", " ")
        code = code:gsub(" end", ";end")
        code = code:gsub(" then", ";then")
        code = code:gsub(" do", ";do")
        code = code:gsub(";[ \t]*;", ";") 
        return " " .. code .. " "
    end
}

-- // MAIN OBFUSCATION ENGINE
function QuantumObfuscator.Obfuscate(code, encryptionKey)
    encryptionKey = encryptionKey or "OMEGA_VOID_LOCK_"..math.random(10000,99999)
    local shiftOffset = math.random(1, 255) -- Random shift offset for extra layer

    -- --- Notification Start ---
    local start_time = tick()
    local duration = 5.0 -- Notification duration
    
    print("\n\n#################################################################")
    print("# [OMEGA VOID] Quantum Obfuscator V5.1 Initiated")
    print(string.format("# Starting process (Target time: %s seconds)...", duration))
    print("#################################################################")
    
    local function simulate_progress(step_name, delay_factor)
        wait(duration * delay_factor)
        print(string.format("  [>> %.1fs] Processing %s...", tick() - start_time, step_name))
    end
    
    -- STEP 1: Pre-process code
    simulate_progress("Preprocessing & Flattening", 0.1)
    local processed = PolyCode.FlattenCode(code)
    
    -- STEP 2: String & Number obfuscation
    simulate_progress("String Fragmentation & Numeric Obfuscation", 0.2)
    processed = processed:gsub('"([^"]*)"', function(str)
        return "(" .. QE.StringObfuscate(str:gsub('\\"', '"')) .. ")"
    end)
    processed = processed:gsub("%f[%D]%d+%f[%D]", function(match)
        local num = tonumber(match:match("%d+"))
        return match:gsub("%d+", PolyCode.ObfuscateNumber(num))
    end)
    
    -- STEP 3: Layer 1 Encryption (Byte Shift)
    simulate_progress(string.format("Layer 1 Byte Shift (Offset: %d)", shiftOffset), 0.15)
    local encrypted1 = QE.ByteShift.Encrypt(processed, shiftOffset)

    -- STEP 4: Layer 2 Encryption (XOR)
    simulate_progress("Layer 2 XOR Encryption", 0.2)
    local encrypted2 = QE.XOR.Encrypt(encrypted1, encryptionKey)
    
    -- STEP 5: Layer 3 Encryption (Base64)
    simulate_progress("Layer 3 Base64 Encoding", 0.15)
    local encrypted3 = QE.Base64.Encode(encrypted2)
    
    -- STEP 6: Generate loader code
    simulate_progress("Loader & Key Generation", 0.05)
    local loader = QuantumObfuscator.GenerateLoader(encrypted3, encryptionKey, shiftOffset)
    
    -- STEP 7: Add junk code
    simulate_progress("Final Assembly & Junk Code Injection", 0.05)
    local finalCode = {}
    for i = 1, 15 do -- Increased junk
        table.insert(finalCode, PolyCode.GenerateJunkCode())
    end
    table.insert(finalCode, loader)
    for i = 1, 10 do
        table.insert(finalCode, PolyCode.GenerateJunkCode())
    end
    
    local obfuscated_code = table.concat(finalCode, "\n")
    local elapsed_time = tick() - start_time
    
    -- --- Completion Notification & Auto-Copy (Fading Out) ---
    if elapsed_time < duration then wait(duration - elapsed_time) end
    
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

-- // LOADER CODE GENERATOR (ULTIMATE KEY HIDING AND TRIPLE DECRYPTION)
function QuantumObfuscator.GenerateLoader(encryptedData, key, shiftOffset)
    -- Highly confusing variable names for maximum obfuscation
    local data_var = QE.GenerateVarName()
    local key_enc = QE.ObfuscateKey(key) -- The key is now a chain of math
    local key_var = QE.GenerateVarName()
    local b64_dec = QE.GenerateVarName()
    local xor_dec = QE.GenerateVarName()
    local shift_dec = QE.GenerateVarName()
    local res_var = QE.GenerateVarName()
    local loop_i = QE.GenerateVarName()
    local temp_char = QE.GenerateVarName()
    local temp_byte = QE.GenerateVarName()
    local opaque_val = QE.GenerateVarName() -- For opaque predicate

    -- Insert opaque predicate logic that ensures 'loadstring' runs only if a meaningless condition is met
    local opaque_code = string.format("local %s = %d * 2; if %s %% 2 == 0 and true then %s = %s/2 end", 
        opaque_val, math.random(10, 50), opaque_val, opaque_val, opaque_val)

    -- Correctly define the decryption functions and then call them
    return string.format([[
-- // OMEGA VOID DECRYPTION LOADER - TRIPLE LAYER
local bit32 = bit32 or {bxor=function(a,b)return a~b end} -- Fallback for bitwise
local loadstring = loadstring or function(s) return load(s) end
%s

local %s = (%s) -- FRACTURED KEY DE-OBFUSCATION
local %s = "%s" -- Encrypted data

-- Base64 Decode (Layer 3)
local %s = function(%s)
    local b64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    %s = string.gsub(%s, '[^'..b64..'=]', '')
    return (%s:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b64:find(x)-1)
        for i=6,1,-1 do r=r..(f%%2^i-f%%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%%d%%d%%d?%%d?%%d?%%d?%%d?%%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

-- XOR Decrypt (Layer 2)
local %s = function(%s, %s)
    local %s = ""
    for %s = 1, #%s do
        local %s = string.sub(%s, %s, %s)
        local keyChar = string.sub(%s, ((%s - 1) %% #%s) + 1, ((%s - 1) %% #%s) + 1) 
        %s = %s .. string.char(bit32.bxor(string.byte(%s), string.byte(keyChar)))
    end
    return %s
end

-- Byte Shift Decrypt (Layer 1)
local %s = function(%s, offset)
    local %s = {}
    for %s = 1, #%s do
        local %s = string.byte(%s, %s)
        local %s = (%s - offset + 256) %% 256
        table.insert(%s, string.char(%s))
    end
    return table.concat(%s)
end

-- TRIPLE DECRYPTION and Execution (FIXED: Added the key_var argument to the XOR function call)
if %s > 0 then
    -- Correct nested call: shift_dec(xor_dec(b64_dec(data_var), key_var), shiftOffset)
    loadstring(%s(%s(%s(%s), %s), %s))()
else
    -- Opaque unreachable code path
    local z = 1/0
end
]],
    opaque_code,
    key_var, key_enc, -- Key retrieval
    data_var, encryptedData,
    -- B64 Dec (2 arguments)
    b64_dec, data_var, data_var, data_var, data_var,
    -- XOR Dec (10 arguments)
    xor_dec, data_var, key_var, res_var, loop_i, data_var, temp_char, data_var, loop_i, loop_i, key_var, loop_i, key_var, loop_i, res_var, res_var, temp_char, res_var,
    -- Shift Dec (9 arguments)
    shift_dec, data_var, res_var, loop_i, data_var, temp_byte, data_var, loop_i, temp_char, temp_byte, res_var, temp_char, res_var,
    -- Final Execution inside Opaque Predicate (7 arguments)
    opaque_val, shift_dec, xor_dec, b64_dec, data_var, key_var, shiftOffset) -- key_var is inserted here
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
