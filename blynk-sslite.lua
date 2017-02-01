require("socket")
require("bitstring")


MSG_CMD = {
  RSP = 0,
  LOGIN = 2,
  PING = 6,
  TWEET = 12,
  EMAIL = 13,
  NOTIFY = 14,
  BRIDGE = 15,
  HW_SYNC = 16,
  HW_INFO = 17,
  HW = 20
}
RESP_CODE = {
  SUCCESS = 200,
  QUOTA_LIMIT_EXCEPTION = 1,
  ILLEGAL_COMMAND = 2,
  USER_NOT_REGISTERED = 3,
  USER_ALREADY_REGISTERED = 4,
  USER_NOT_AUTHENTICATED = 5,
  NOT_ALLOWED = 6,
  DEVICE_NOT_IN_NETWORK = 7,
  NO_ACTIVE_DASHBOARD = 8,
  INVALID_TOKEN = 9,
  ILLEGAL_COMMAND_BODY = 11,
  GET_GRAPH_DATA_EXCEPTION = 12,
  
  NOTIFICATION_INVALID_BODY_EXCEPTION = 13,
  NOTIFICATION_NOT_AUTHORIZED_EXCEPTION = 14,
  NOTIFICATION_EXCEPTION = 15,
  
  -- reserved
    BLYNK_TIMEOUT_EXCEPTION = 16,
    
  NO_DATA_EXCEPTION = 17,
  DEVICE_WENT_OFFLINE = 18,
  SERVER_EXCEPTION = 19,
  NOT_SUPPORTED_VERSION = 20
}

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

function handleSock(pSock, pRequestsQueue)
  -- receive socket data and decode content
  -- put server commands in queue
  -- return server answer
  local headerBytes = 5
  -- timeout 500ms
  pSock.settimeout(0.5)
  while true do
    local header, errCode, partialResult = pSock:receive(headerBytes)
    if header ~= nil then
      -- result OK, check header
      cmd, msgId, misc = bitstring.unpack("8:int,16:int,16:int",header)
      if cmd == MSG_CMD.RSP then
        return msgId, misc
      else
        -- it is a server command
        -- get payload
        local dataLen = misc
        local data, errCode, partialResult = pSock:receive(dataLen)
        if data ~= nil then
          -- queue this command
          table.insert(pRequestsQueue,{['cmd'] = cmd, ['id'] = msgId, ['len'] = dataLen, ['data'] = data})
        else
          -- error reading data
          return nil, errCode
        end
      end
    else
      -- error
      if errCode == "timeout" then
        return nil, errCode
      elseif errCode == "closed" then
        return nil, errCode
      end
    end
  end
end

function sendCmd(pSock, pQueue, pCmd, pMsgId, pData)
  local buf = create_message(pCmd, pMsgId, pData)
  local result, err, index = pSock:send(buf)
  -- get answer, !!! some server cmd can be arrived before response so check if resp or cmd if cmd put in queue to treat later
  -- while data in receive buffer, check for response (with timeout of 1s)
   
  if result ~= nil then
    result, err = handleSock(pSock, pQueue)
    if result == nil then
      print("response error : ", err)
    end
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
blynk.serverCmdQueue = {}

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
      sendCmd(client,blynk.serverCmdQueue,blynk.commands.login,1,blynk.token)
    else
      
    end
  -- If not nil, check connection
  else
  
  end
end

return blynk
