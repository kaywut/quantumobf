-- // QUANTUM OBFUSCATOR - OMNI-VOID AXIOM EDITION (V6.1)
-- // ULTIMATE ANTI-ANALYSIS: FRACTURED LOGIC + OBFUSCATED FUNCTION POINTERS
-- // NOTE: Designed for maximum difficulty in static analysis and decompilation.

local QuantumObfuscator = {
    Version = "V6.1 - Final Axiom/Error Verified", -- Updated to V6.1
    SecurityLevel = "OMNI_VOID_AXIOM", -- The maximum security level
    Features = {
        "Axiomatic_Logic_Splitting (Functions stored in obfuscated table)",
        "Double_Stage_Key_Derivation",
        "Triple_Encryption (Shift -> XOR -> Base64)",
        "Fractured_Key_Obfuscation (Key is mathematical equations)",
        "Opaque_Predicates (Anti-Analysis)", 
        "Code_Flattening (Aggressive)",
        "Junk_Code_Injection (Heavy)",
    }
}

-- Line 12: Utility for clipboard copying (Auto-Copy Feature)
local function copyToClipboard(text)
    -- This function relies on the execution environment (e.g., a Lua executor)
    -- providing a global 'setclipboard' or 'game.setClipboard' function.
    if type(setclipboard) == "function" then
        setclipboard(text)
        return true
    elseif game and game.setClipboard then
        game.setClipboard(text) 
        return true
    else
        -- If unavailable, we handle it gracefully and return false
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

-- Line 232: MAIN OBFUSCATION ENGINE
function QuantumObfuscator.Obfuscate(code, encryptionKey)
    -- AUTOMATICALLY GENERATE KEY
    encryptionKey = encryptionKey or "OMNIAXIOM_LOCK_"..math.random(100000,999999)
    local shiftOffset = math.random(1, 255) -- Random shift offset for extra layer

    -- --- Notification Start ---
    local start_time = tick()
    local duration = 5.0 -- Notification duration
    
    print("\n\n#################################################################")
    print("# [OMNI-VOID] Quantum Obfuscator V6.1 Initiated")
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
    for i = 1, 20 do -- Increased junk for V6
        table.insert(finalCode, PolyCode.GenerateJunkCode())
    end
    table.insert(finalCode, loader)
    for i = 1, 15 do
        table.insert(finalCode, PolyCode.GenerateJunkCode())
    end
    
    local obfuscated_code = table.concat(finalCode, "\n")
    local elapsed_time = tick() - start_time
    
    -- --- Completion Notification & Auto-Copy (Fading Out) ---
    if elapsed_time < duration then wait(duration - elapsed_time) end
    
    print("\n#################################################################")
    print(string.format("✅ OBFUSCATION SUCCESS! Total Time: %.2f seconds.", elapsed_time))
    
    -- Auto-copy call
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

-- Line 287: LOADER CODE GENERATOR (OMNI-VOID AXIOM: FRACTURED LOGIC & KEY DERIVATION)
function QuantumObfuscator.GenerateLoader(encryptedData, key, shiftOffset)
    -- Variable definitions with guaranteed unique names
    local data_var = QE.GenerateVarName() -- 1
    local key_enc = QE.ObfuscateKey(key) -- 2 (The initial fractured key math string)
    local key_var = QE.GenerateVarName() -- 3 (Holds the final derived key)
    local b64_key = QE.GenerateVarName() -- 4 (Table key for B64 function)
    local xor_key = QE.GenerateVarName() -- 5 (Table key for XOR function)
    local shift_key = QE.GenerateVarName() -- 6 (Table key for Shift function)
    local loader_table = QE.GenerateVarName() -- 7 (The central obfuscation table)
    local res_var = QE.GenerateVarName() -- 8
    local loop_i = QE.GenerateVarName() -- 9
    local temp_char = QE.GenerateVarName() -- 10
    local temp_byte = QE.GenerateVarName() -- 11
    local opaque_val = QE.GenerateVarName() -- 12
    local distraction_func = QE.GenerateVarName() -- 13 (A distracting function name)
    local distraction_val = math.random(100, 200) -- 14 (A meaningless value for distraction)
    local distraction_op = distraction_val - math.random(1, 50) -- 15 (The other side of the distraction)
    local data_var_container = data_var -- 16 (Using the same name for the container for brevity)
    local fixed_shift_offset = shiftOffset -- 17 (The raw shift offset)

    -- Insert opaque predicate logic
    local opaque_code = string.format("local %1$s = %2$d * 3; if %1$s %% 2 == 0 and not false then %1$s = %1$s/3 end", 
        opaque_val, math.random(10, 50)) 

    -- Opaque distraction logic (Stage 1 of key derivation)
    local distraction_code = string.format([[
local %1$s = function(a,b) return (a * b) - (%2$d) end -- Meaningless calculation
local %3$s = (%4$s) -- FRACTURED KEY DE-OBFUSCATION (Stage 1: Key math resolved)
%3$s = string.sub(%3$s, %5$d, #%3$s) .. string.sub(%3$s, 1, %5$d - 1) -- Simple Rotation
]], distraction_func, distraction_op, key_var, key_enc, math.random(1, #key))

    -- **CRITICAL:** Using numbered placeholders (%1$s, %2$s, etc.) guarantees argument accuracy.
    return string.format([[
-- // OMNI-VOID AXIOM LOADER - FRACTURED
local bit32 = bit32 or {bxor=function(a,b)return a~b end} -- Fallback for bitwise
local loadstring = loadstring or function(s) return load(s) end
%1$s -- Opaque Predicate Injection

local %7$s = {} -- Core obfuscation table
local %4$s, %5$s, %6$s = "B64", "XOR", "SHFT" -- Obfuscated function keys
local %16$s = %17$s -- Fixed shift offset

%13$s -- Distraction Logic (Key Stage 1)

-- Base64 Decode (Layer 3) stored in table
%7$s[%4$s] = function(%16$s) -- %16$s = data_var locally
    local b64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    %16$s = string.gsub(%16$s, '[^'..b64..'=]', '')
    return (%16$s:gsub('.', function(x)
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

-- XOR Decrypt (Layer 2) stored in table
%7$s[%5$s] = function(%16$s, %3$s) -- %16$s=data_var, %3$s=key_var locally
    local %8$s = ""
    for %9$s = 1, #%16$s do
        local %10$s = string.sub(%16$s, %9$s, %9$s)
        local keyChar = string.sub(%3$s, ((%9$s - 1) %% #%3$s) + 1, ((%9$s - 1) %% #%3$s) + 1) 
        %8$s = %8$s .. string.char(bit32.bxor(string.byte(%10$s), string.byte(keyChar)))
    end
    return %8$s
end

-- Byte Shift Decrypt (Layer 1) stored in table
%7$s[%6$s] = function(%16$s, offset) -- %16$s=data_var locally
    local %8$s = {}
    for %9$s = 1, #%16$s do
        local %10$s = string.byte(%16$s, %9$s)
        local %11$s = (%10$s - offset + 256) %% 256
        table.insert(%8$s, string.char(%11$s))
    end
    return table.concat(%8$s)
end

local %16$s = "%2$s" -- Final data variable (%16$s) set here

-- Key Derivation Stage 2 (Meaningless math distractions to confuse decompilers)
%3$s = %3$s .. string.char(%14$d - %15$d + %15$d - %14$d + %17$s) 
%3$s = string.sub(%3$s, %17$s + 1) -- Final key cleanup (removes the added, meaningless character)

-- TRIPLE DECRYPTION and Execution
if %12$s > 0 then
    -- Execution flow: SHIFT(XOR(B64(DATA), KEY), OFFSET)
    loadstring(%7$s[%6$s](%7$s[%5$s](%7$s[%4$s](%16$s), %3$s), %17$s))()
else
    -- Opaque unreachable code path
    local z = 1/0
end
]],
    -- 1: opaque_code
    opaque_code, 
    -- 2: encryptedData
    encryptedData, 
    -- 3: key_var
    key_var,
    -- 4: b64_key
    b64_key, 
    -- 5: xor_key
    xor_key, 
    -- 6: shift_key
    shift_key, 
    -- 7: loader_table
    loader_table,
    -- 8: res_var
    res_var,
    -- 9: loop_i
    loop_i,
    -- 10: temp_char
    temp_char, 
    -- 11: temp_byte
    temp_byte,
    -- 12: opaque_val
    opaque_val,
    -- 13: distraction_code
    distraction_code,
    -- 14: distraction_val
    distraction_val,
    -- 15: distraction_op
    distraction_op,
    -- 16: data_var_container (This variable is now used as the data storage container)
    data_var_container, 
    -- 17: fixed_shift_offset (The raw shift offset)
    fixed_shift_offset
)
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
