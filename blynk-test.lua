require("socket")
local blynk = dofile("blynk-sslite.lua")
blynk.init("880c27c64b47419997eaef86e81c1184",nil,nil,nil)

dofile("SSLSimulator.lua")

i=0
while i < 20 do
  blynk.run()
  i = i + 1
  socket.sleep(1)
end