require("socket")
require("bitstring")

-- a blynk message is 8bit type, 16bit mid, 16bit length, payload and '\0'
function create_message ( cmd, mid, payload )
   -- > is big endian
   -- B char, I2 is 2 bytes
   -- sn is a 2byte length followed by the bytes
   local msg
   if payload ~= nil then
      -- print ( "message is: " .. cmd .. " " .. mid .. " " .. string.len(payload) .. ' ' .. payload)
      msg = bitstring.pack ( "8:int,16:int,16:int", cmd, mid, string.len(payload))
      msg = msg .. payload
   else
      -- print ( "message is: " .. cmd .. " " .. mid )
      msg = bitstring.pack ( "8:int,16:int,16:int", cmd, mid, 0)
   end
   return msg
end

function sendCmd(pSock, pCmd, pMsgId, pData)
  local buf = create_message(pCmd, pMsgId, pData)
  local result, err, index = pSock:send(buf)
  -- get answer, !!! some server cmd can be arrived before response so check if resp or cmd if cmd put in queue to treat later
  -- while data in receive buffer, check for response (with timeout of 1s)
  result, err = pSock:receive(5)
  if result ~= nil then
    cmd, mid, code = bitstring.unpack("8:int,16:int,16:int",result)
    print(cmd, mid, code)
  else
    print(err)
  end
end

blynk = {}
blynk.__index = blynk
blynk.commands = { register = 1, login = 2, ping = 6, activate = 7, deactivate = 8, notify = 14, hardware = 20, tweet = 12, email = 13  }
blynk.status = { success = 200, illegal_command = 2, not_registered = 3, not_authenticated = 5, invalid_token = 9 }
blynk.server = "blynk-cloud.com"
blynk.port = 8442
blynk.token = ""
blynk.tcpClient = nil

function blynk.init(pToken, pServer, pPort, pConfig)
  blynk.token = pToken
  if pServer then blynk.server = pServer end
  if pPort then blynk.port = pPort end
    
end

function blynk.run()
  -- If tcpClient nil, create, connect and authenticate
  if blynk.tcpClient == nil then
    local client, err = socket.connect(blynk.server, blynk.port)
    if client ~= nil then
      blynk.tcpClient = client
      -- try to authenticate
      sendCmd(client,blynk.commands.login,1,blynk.token)
    else
      
    end
  -- If not nil, check connection
  else
  
  end
end

return blynk
