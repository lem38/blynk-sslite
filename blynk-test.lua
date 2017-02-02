
local blynk = dofile("blynk-sslite.lua")
blynk.init("880c27c64b47419997eaef86e81c1184",nil,nil,nil)
--client:settimeout(2)
i=0
while i < 10 do
  blynk.run()
  i = i + 1
end