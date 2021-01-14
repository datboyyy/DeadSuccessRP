
MF_Stress = {}
local MFS = MF_Stress

MFS.Version = '1.0.10'

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj; end)
Citizen.CreateThread(function(...)
  while not ESX do 
    TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj; end) 
    Citizen.Wait(0)
  end
end)

MFS.GetSickAt       = 25 -- only change the first value (percent player gets sick at)
MFS.MildlySickAt    = 65
MFS.ExtremelySickAt = 75 -- only change the first value (percent player vomits at)

MFS.CoughTimer      = 30 -- seconds between cough
MFS.VomitTimer      = 45 -- seconds between vomit
MFS.VomitHealthLoss = 0 -- from vomiting

MFS.DrugsTimer      = 45 -- how long drugs last (seconds)
MFS.SmokeRelief     = 20 -- from smoking cigarette
MFS.JointRelief     = 25 -- from smoking joint
MFS.AlchoholRelief  = 20 -- from drinking alchohol beverage
MFS.DrinkingRelief  = 10 -- from drinking non-alchoholic beverage

MFS.StaticRelief    = 0.1 -- % stress relieved over time from events like swimming, riding bikes, etc.
MFS.StaticAdder     = 0.1 -- % stress gained over time from things like driving too fast.
MFS.CombatAdder     = 0.9 -- % stress gained while in combat
MFS.ShootingAdder   = 0.11 -- % stress gained while shooting
MFS.StressAtSpeed   = 280 -- kph
MFS.RelaxAtSpeed    = 96  -- kph