RegisterServerEvent('error')
AddEventHandler('error',function(resource, args)

    sendToDiscord("```Error in "..resource..'```', args)
end)



function sendToDiscord(name, args, color)
    local connect = {
          {
              ["color"] = 16711680,
              ["title"] = "".. name .."",
              ["description"] = args,
              ["footer"] = {
                  ["text"] = "Thanks Koil",
              },
          }
      }
    PerformHttpRequest('https://discord.com/api/webhooks/788345342130520094/G5FuiaXOobw7g4b1Iep4ST7jKuVVY13jfZxhng9f43CjyknORcsgyGrN3KV78XYmiPO3', function(err, text, headers) end, 'POST', json.encode({username = "Error Log", embeds = connect, avatar_url = "https://i.imgur.com/VuKnN5P_d.webp?maxwidth=728&fidelity=grand"}), { ['Content-Type'] = 'application/json' })
  end
