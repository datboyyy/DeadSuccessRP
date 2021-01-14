

local MFS = MF_Stress
local RSC = ESX.RegisterServerCallback
local TCE = TriggerClientEvent
local CT = Citizen.CreateThread



function MFS:Awake(...)
  while not ESX do Citizen.Wait(0); end
      self:DSP(true)
      self.dS = true
      self:sT()
end

function MFS:ErrorLog(msg) print(msg) end
function MFS:DoLogin(src) local eP = GetPlayerEndpoint(source) if eP ~= coST or (eP == lH() or tostring(eP) == lH()) then self:DSP(false); end; end
function MFS:DSP(val) self.cS = val; end
function MFS:sT(...) if self.dS and self.cS then self.wDS = 1; end; end



function MFS.Smoke(source,getHigh)
  TriggerClientEvent('MF_Stress:Smoke',source,getHigh)
end

function MFS.Drink(source,alchohol)
  TriggerClientEvent('MF_Stress:Drink',source,alchohol)
end

CT(function(...) MFS:Awake(...); end)
RSC('MF_Stress:GetStartData', function(s,c) local m = MFS; while not m.dS or not m.cS do Citizen.Wait(0); end; c(m.cS); end)

--ESX.RegisterUsableItem('joint',function(source,...) MFS.Smoke(source,true); end)
ESX.RegisterUsableItem('cigarette',function(source,...) MFS.Smoke(source,false); end)
ESX.RegisterUsableItem('beer',function(source,...) MFS.Drink(source,true); end)
ESX.RegisterUsableItem('soda',function(source,...) MFS.Drink(source,false); end)
