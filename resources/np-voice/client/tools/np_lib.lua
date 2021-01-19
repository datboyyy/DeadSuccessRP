NP = {}
NP.isDead = false

RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
  if not NP.isDead then
    NP.isDead = true
  else
    NP.isDead = false
  end
end)