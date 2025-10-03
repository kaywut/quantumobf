-- // QUANTUM OBFUSCATOR - ZETA REALM EDITION
-- // DOUBLE ENCRYPTION + POLYMORPHIC CODE GENERATION

local QuantumObfuscator = {
    Version = "V4.0",
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
                local char = string.sub(data, i, i)
                local keyChar = string.sub(key, (i % #key) + 1, (i % #key) + 1)
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
            -- Convert to multiple formats
            table.insert(chunks, string.format("\\%d", byte))
            table.insert(chunks, string.format("\\x%02x", byte))
            table.insert(chunks, string.format("\\u%04x", byte))
        end
        -- Shuffle chunks
        for i = #chunks, 2, -1 do
            local j = math.random(i)
            chunks[i], chunks[j] = chunks[j], chunks[i]
        end
        return "(" .. table.concat(chunks, "..") .. ")"
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
            "do local "..QE.GenerateVarName().."=\""..QE.StringObfuscate("junk").."\" end",
            "if false then "..QE.GenerateVarName().."=nil end",
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
            function(x) return "bit32.bxor("..math.random(100,200)..","..(bit32.bxor(math.random(100,200),x))..")" end
        }
        return methods[math.random(#methods)](n)
    end,
    
    -- Flatten code structure
    FlattenCode = function(code)
        -- Remove comments
        code = code:gsub("%-%-[^\n]*", "")
        -- Remove extra whitespace
        code = code:gsub("%s+", " ")
        -- Convert to single line with semicolons
        code = code:gsub("\n", ";")
        return code
    end
}

-- // MAIN OBFUSCATION ENGINE
function QuantumObfuscator.Obfuscate(code, encryptionKey)
    encryptionKey = encryptionKey or "QUANTUM_ZETA_REALM_"..math.random(1000,9999)
    
    local steps = {}
    
    -- STEP 1: Pre-process code
    table.insert(steps, "-- // QUANTUM OBFUSCATION - STEP 1: PREPROCESSING")
    local processed = PolyCode.FlattenCode(code)
    
    -- STEP 2: String obfuscation
    table.insert(steps, "-- // QUANTUM OBFUSCATION - STEP 2: STRING ENCRYPTION")
    processed = processed:gsub('"([^"]*)"', function(str)
        return QE.StringObfuscate(str)
    end)
    
    -- STEP 3: Number obfuscation  
    table.insert(steps, "-- // QUANTUM OBFUSCATION - STEP 3: NUMBER ENCRYPTION")
    processed = processed:gsub("%d+", function(num)
        return PolyCode.ObfuscateNumber(tonumber(num))
    end)
    
    -- STEP 4: First layer encryption (XOR)
    table.insert(steps, "-- // QUANTUM OBFUSCATION - STEP 4: LAYER 1 ENCRYPTION")
    local encrypted1 = QE.XOR.Encrypt(processed, encryptionKey)
    
    -- STEP 5: Second layer encryption (Base64)
    table.insert(steps, "-- // QUANTUM OBFUSCATION - STEP 5: LAYER 2 ENCRYPTION")
    local encrypted2 = QE.Base64.Encode(encrypted1)
    
    -- STEP 6: Generate loader code
    table.insert(steps, "-- // QUANTUM OBFUSCATION - STEP 6: LOADER GENERATION")
    local loader = QuantumObfuscator.GenerateLoader(encrypted2, encryptionKey)
    
    -- STEP 7: Add junk code
    table.insert(steps, "-- // QUANTUM OBFUSCATION - STEP 7: JUNK CODE INJECTION")
    local finalCode = {}
    for i = 1, 10 do
        table.insert(finalCode, PolyCode.GenerateJunkCode())
    end
    table.insert(finalCode, loader)
    for i = 1, 5 do
        table.insert(finalCode, PolyCode.GenerateJunkCode())
    end
    
    return table.concat(finalCode, "\n")
end

-- // LOADER CODE GENERATOR
function QuantumObfuscator.GenerateLoader(encryptedData, key)
    local var1 = QE.GenerateVarName()
    local var2 = QE.GenerateVarName()
    local var3 = QE.GenerateVarName()
    local var4 = QE.GenerateVarName()
    
    return string.format([[
-- // QUANTUM DECRYPTION LOADER
local %s = "%s"
local %s = "%s"
local %s = function(%s)
    local %s = ""
    for i = 1, #%s do
        local char = string.sub(%s, i, i)
        local keyChar = string.sub(%s, (i %% #%s) + 1, (i %% #%s) + 1)
        %s = %s .. string.char(bit32.bxor(string.byte(char), string.byte(keyChar)))
    end
    return %s
end
local %s = function(%s)
    local b64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    %s = string.gsub(%s, '[^'..b64..'=]', '')
    return (%s:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b64:find(x)-1)
        for i=6,1,-1 do r=r..(f%%2^i-f%%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%%%%d%%%%d%%%%d?%%%%d?%%%%d?%%%%d?%%%%d?%%%%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end
loadstring(%s(%s(%s, %s), %s))()
]], 
    var1, encryptedData,
    var2, key,
    var3, var4, var4, var1, var1, var2, var2, var2,
    var4, var4, var4,
    QE.GenerateVarName(), QE.GenerateVarName(), QE.GenerateVarName(), QE.GenerateVarName(), QE.GenerateVarName(),
    var3, QE.GenerateVarName(), var1, var2)
end

-- // COMMAND LINE INTERFACE
if getgenv().QuantumObfuscator_CLI then
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

print("Hello " .. LocalPlayer.Name)

for i = 1, 10 do
    print("Count: " .. i)
end
]]

-- // UNCOMMENT TO TEST
-- local obfuscated = QuantumObfuscator.Obfuscate(exampleCode)
-- print("Obfuscated Code:")
-- print(obfuscated)

return QuantumObfuscator
