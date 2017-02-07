require ("bit")
ME={}
DEV200 = {}
scl = {sysclock = function() return math.random(999) end}
BacnetObjs = {
  {Name = "ETH1", Attributs = {Status_Mac = 0, Status_Ip = "192.168.0.18", Hostname = ""}},
  {Name = "CFG1", Attributs = {Node_Id = "N003193", Node_Instance = 100, Time = 1466163698, CPU_Usage = 85.3, Time_Boot = 1466163000, Tags = "{SoftwareVersion = \"2.1.0\", Zones = \"Chambre;Salon\"}", Version = "2.19.1.32"}},
  {Name = "SCH1", Attributs = {}},
  {Name = "SCH2", Attributs = {}},
  {Name = "SCH3", Attributs = {}},
  {Name = "SCH4", Attributs = {}},
  {Name = "SCH5", Attributs = {}},
  {Name = "BO1", Attributs = {}},
  {Name = "BO2", Attributs = {}},
  {Name = "AO1", Attributs = {}},
  {Name = "AO2", Attributs = {}},
  {Name = "BI1", Attributs = {}},
  {Name = "BI2", Attributs = {}},
  {Name = "BI3", Attributs = {}},
  {Name = "BI4", Attributs = {}},
  {Name = "BI5", Attributs = {}},
  {Name = "BI6", Attributs = {}}
}
for i=1,#BacnetObjs do
  local Name = BacnetObjs[i].Name
  local strValueField = Name.."_Present_Value"
  local strNameField = Name.."_Object_Name"
  local strFlagField = Name.."_Flags"
  local strTagField = Name.."_Tags"
  local strDescriptionField = Name.."_Description"
  ME[strValueField]= {time=0, value=0}
  ME[strNameField]= {value = ""}
  ME[strTagField]= {value = ""}
  ME[strDescriptionField]= {value = ""}
  ME[strFlagField]={time=0, value=0}
  for k,v in pairs(BacnetObjs[i].Attributs) do
    local key = BacnetObjs[i].Name .. "_" .. k
    ME[key] = {time=0, value=0}
    if v ~= nil then
      ME[key].value = v
    end
  end
end

for i=1,200,1 do
    local avName = string.format("AV%d",i)
    local strValueField = avName.."_Present_Value"
    local strNameField = avName.."_Object_Name"
    local strFlagField = avName.."_Flags"
    local strTagField = avName.."_Tags"
    local strDescriptionField = avName.."_Description"
    local strUnitField = avName.."_Units"
    ME[strValueField]= {time=0, value=0}
    ME[strNameField]= {value = ""}
    ME[strDescriptionField]= {value = ""}
    ME[strTagField]= {value = ""}
    ME[strFlagField]={time=0, value=0x81}
    ME[strUnitField]= {time=0, value=0}
    DEV200[strValueField]= {time=0, value=0}
    DEV200[strNameField]={value = ""}
    DEV200[strFlagField]={time=0, value=0x81}
end

for i=1,200,1 do
    local avName = string.format("BV%d",i)
    local strValueField = avName.."_Present_Value"
    local strNameField = avName.."_Object_Name"
    local strFlagField = avName.."_Flags"
    local strTagField = avName.."_Tags"
    local strDescriptionField = avName.."_Description"
    local strUnitField = avName.."_Units"
    ME[strValueField]= {time=0, value=0}
    ME[strNameField]={value = ""}
    ME[strDescriptionField]= {value = ""}
    ME[strTagField]= {value = ""}
    ME[strFlagField]={time=0, value=0x81}
    ME[strUnitField]= {time=0, value=0}
    DEV200[strValueField]= {time=0, value=0}
    DEV200[strNameField]={value = ""}
    DEV200[strFlagField]={time=0, value=0}
end
for i=1,10,1 do
    local avName = string.format("AI%d",i)
    local strValueField = avName.."_Present_Value"
    local strNameField = avName.."_Object_Name"
    local strFlagField = avName.."_Flags"
    local strTagField = avName.."_Tags"
    local strDescriptionField = avName.."_Description"
    local strUnitField = avName.."_Units"
    ME[strValueField]= {time=0, value=0}
    ME[strNameField]={value = ""}
    ME[strDescriptionField]= {value = ""}
    ME[strTagField]= {value = ""}
    ME[strFlagField]={time=0, value=0x81}
    ME[strUnitField]= {time=0, value=0}
    DEV200[strValueField]= {time=0, value=0}
    DEV200[strNameField]={value = ""}
    DEV200[strFlagField]={time=0, value=0}
end

ME["PG1_OUTPUT"]=""
ME["PG1_ENABLE"]=""
ME["SCH0_Present_Value"] = {time=0, value=0}
ME["SCH1_Present_Value"] = {time=0, value=0}
ME["CAL1_Present_Value"] = {time=0, value=0}
ME['CFG1_CPU_Usage_Lua_Script'] = {time=0, value=0}
ME['CFG1_Malloc_Bytes_Used'] = {time=0, value=0}
ME['CFG1_Malloc_Bytes_Used'] = {time=0, value=0}
ME['CFG1_Malloc_Bytes_Max'] = {time=0, value=10000}

ME["CO1_Proportional_Constant"] = {time=0, value=0}
ME["CO1_Deadband"] = {time=0, value=0}
ME["CO1_Integral_Constant"] = {time=0, value=0}
ME["CO1_Reset_Band"] = {time=0, value=0}
ME["CO1_Derivative_Constant"] = {time=0, value=0}
ME["CO1_Sample_Time"] = {time=0, value=0}
ME["CO1_Action"] = {time=0, value=0}
ME["CO1_Controlled_Variable_Value"] = {time=0, value=0}
ME["CO1_Setpoint"] = {time=0, value=0}
ME["CO1_Present_Value"] = {time=0, value=0}


vm = {
    eo_read = function(deviceID)
    
    return nil
    end
}

modbus = {
    close = function()
    
    end,
    
    open = function(dho, baud, databits, parity, stopbits)
    
    end,
    
    hr_read = function(slaveAddr, firstRegAddr, regCount)
        local ret = {}
        for i=1,regCount,1 do
            ret[i] = 0
        end
        return 0, ret
    end,
    
    hr_write = function(slaveAddr, firstRegAddr, value)
        return 0
    end,
}

--bit = {
--    bor = function()
--        return 0
--    end,
--    band = function(a, b)
--        return bit.band(a, b)
--    end,
--    rshift = function()
--        return 0
--    end,
--    lshift = function()
--        return 0
--    end,
--}

scale=function(...) return 0 end

vm = {
  eo_flush = function() end,
  eo_read = function() end,
  eo_write = function() return "Sending" end
}