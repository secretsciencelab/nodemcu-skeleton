-- load credentials (e.g., 'SSID' and 'PASSWORD')
dofile("credentials.lua")

function syncClock()
	-- sync time
	sntp.sync("pool.ntp.org", 
	function()
		--print("[SNTP] synced time: " .. rtctime.get())
	end,
	function()
		--print("[SNTP] error")
	end, nil)
end

function startup()
  if file.open("init.lua") == nil then
    print("init.lua deleted or renamed")
		return
	end
  file.close("init.lua")

  if file.open("main.lua") == nil then
    print("main.lua deleted or renamed")
		return
	end
  file.close("main.lua")

	luatz_timetable = require("luatz_timetable")

	print('\nSecret Science Lab execute main.lua\n')

	-- set up sntp to sync clock
	syncClock()

  -- the actual application is stored in 'main.lua'
  dofile("main.lc")
end

print("Connecting WiFi...")
wifi.setmode(wifi.STATION)
print('set mode=STATION (mode='..wifi.getmode()..')')
print('MAC: ',wifi.sta.getmac())
print('chip: ',node.chipid())
print('heap: ',node.heap())
wifi.sta.config(SSID, PASSWORD)
-- wifi.sta.connect() not necessary because config() uses auto-connect=true by default
tmr.create():alarm(1000, tmr.ALARM_AUTO, function(cb_timer)
  if wifi.sta.getip() == nil then
      print("Connecting...")
  else
      cb_timer:unregister()
      print("WiFi online, IP address: " .. wifi.sta.getip())
      print("You have 3 seconds to abort")
      print("Waiting...")

      node.compile("main.lua")
      node.compile("luatz_timetable.lua")

      tmr.create():alarm(3000, tmr.ALARM_SINGLE, startup)
  end
end)
