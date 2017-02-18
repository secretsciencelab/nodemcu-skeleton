-- Globals
g_lastFetchTime = 0
g_lastFetchCode = 0
g_lastFetchData = ""

-- Functions
function getTime()
  local sec, usec = rtctime.get()
  sec = sec - 25200 -- -7 hours (PDT)
  return luatz_timetable.new_from_timestamp(sec)
end

-- Start a simple http server
srv=net.createServer(net.TCP)
function receiver(sck, data)
  --print data
  local now = getTime()
  local rssi = wifi.sta.getrssi()
  local quality = 0
  if (rssi ~= nil) then
    quality = (100 + rssi)*2
    if (quality > 100) then
      quality = 100
    end
  end
  local uptime = tmr.time() / 60
  local fsRemaining, fsUsed, fsTotal = file.fsinfo()
  local fsPctUsed = fsUsed * 100 / fsTotal

  local r = {"HTTP/1.0 200 OK\r\nServer: NodeMCU on ESP8266\r\nContent-Type: text/html\r\n\r\n"}
  r[#r + 1] = "<h1>:)</h1>"
  r[#r + 1] = "time: " .. now:rfc_3339() .. "</br>"
  r[#r + 1] = "uptime: " .. uptime .. "</br>"
  r[#r + 1] = "wifi: " .. quality .. "%</br>"
  r[#r + 1] = "heap_avail: " .. node.heap() .. " bytes</br>"
  r[#r + 1] = "fs_used: " .. fsPctUsed .. "% of " 
               ..  fsTotal .. " kB</br>"
  r[#r + 1] = "</br>"
  r[#r + 1] = "fetch_time: " .. g_lastFetchTime .. "</br>"
  r[#r + 1] = "fetch_code: " .. g_lastFetchCode .. "</br>"
  r[#r + 1] = "fetch_data: " .. g_lastFetchData .. "</br>"

  -- sends and removes the first element from the 'response' table
  local function send(localSocket)
    if #r > 0 then
      localSocket:send(table.remove(r, 1))
    else
      localSocket:close()
      r = nil
    end
  end

  -- triggers send() function again for remaining rows
  sck:on("sent", send)
  send(sck)
end
srv:listen(80, function(conn)
  conn:on("receive", receiver)
end)

-- Periodically sync clock
tmr.alarm(1, 60000, tmr.ALARM_AUTO, function()
  syncClock()
end)

-- Periodically fetch url
tmr.alarm(2, 10000, tmr.ALARM_AUTO, function()
  if (wifi.sta.getrssi() == nil) then
    return
  end

  g_lastFetchTime = getTime():rfc_3339()
  http.get("http://secretsciencelab.appspot.com/homebot/epochtime", nil, function(code, data)
    if (code < 0) then
      --print("HTTP request failed")
    else
      g_lastFetchCode = code
      g_lastFetchData = data
    end
  end)
end)
