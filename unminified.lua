function decode_chunk(a)local b={}local function c(d)local e=false;local f=false;local g=''local h,i="",""local j=0;local function k(l)if l=='AA'then return 1 end;if l=='AB'then return 2 end;if l=='AC'then return 3 end;return 0 end;local function m()g=""end;local function n(o,p,q,r)b[#b+1]={Enum=o,register=tonumber(p),idx=tonumber(q),const=r}end;local s={}local function t(u)s[#s+1]=u end;local v=0;d:gsub('.',function(w)g=g..w;j=k(g)if j==1 then if e==false then m()i=''e=true;v=j end elseif j==2 then if e==false then m()i=''e=true;v=j end elseif j==3 then if e==false then m()i=''e=true;v=j end end;if e==true then i=i..w;if w==','then local x=i:gsub('.',function(w)if w==','or w==':'or w==';'then return""end;if w=='A'then return""end;if w=='B'then return""end;if w=='C'then return""end end)t(x)i=""end;if w==';'then local x=i:gsub('.',function(w)if w==','or w==':'or w==';'then return""end end)t(x)g=""e=false;if v==1 then n(v,s[1],s[2],s[3])s={}i=''elseif v==2 then n(v,s[1],s[2],s[3])s={}i=''elseif v==3 then local y,z,A,B=s[1],s[2],s[3],s[4]local r={{idx=tonumber(A),reg=tonumber(B)}}n(v,y,z,r)end end end end)end;local function C(D)if D:sub(-1)~="\n"then D=D.."\n"end;return D:gmatch("(.-)\n")end;local E=C(a)for F in E do c(F)end;return b end

local function wrap(chunk)
    return function(...)
        chunk=decode_chunk(chunk)
        local ip = 0
        local registers = {}
        local environment = getfenv(0)
        while true do
            if ip>#chunk then break end
            ip=ip+1
            local instruction = chunk[ip]
            
            if type(instruction) == 'table' then
                local instr = instruction
                local Enum = instr.Enum
                local reg = instr.register
                local idx = instr.idx
                local const = instr.const
                if Enum == 1 then
                    if registers[reg] == nil then
                        registers[reg] = {}
                    end
                    registers[reg][idx] = environment[const]
                elseif Enum == 2 then
                    if registers[reg] == nil then
                        registers[reg] = {}
                    end
                    registers[reg][idx] = const
                elseif Enum == 3 then
                    local arguments = {}
                    for i, v in pairs(const) do
                        arguments[#arguments+1] = registers[v.reg][v.idx]
                    end
                    registers[reg][idx](unpack(arguments))
                end
            end
            
        end
    end
end

wrap('AA:1,0,print;AB:1,1,hello world;AC:1,0,1,1;')()
