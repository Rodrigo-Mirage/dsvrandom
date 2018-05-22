
module PlayerRandomizer
  def randomize_player_sprites
    players = game.players
    
    # Shuffle player attributes which are related to the sprite the player uses.
    remaining_players = players.dup
    players.each do |player|
      next unless remaining_players.include?(player) # Already randomized this player
      
      remaining_players.delete(player)
      
      break if remaining_players.empty?
      
      other_player = remaining_players.sample(random: rng)
      remaining_players.delete(other_player)
      
      [
        "GFX list pointer",
        "Sprite pointer",
        "Palette pointer",
        "State anims ptr",
        "GFX asset index",
        "Sprite asset index",
        "Filename pointer",
        "Sprite Y offset",
        "Hitbox pointer",
        "Face icon frame",
        "Palette unknown 1",
        "Palette unknown 2",
      ].each do |attr_name|
        player[attr_name], other_player[attr_name] = other_player[attr_name], player[attr_name]
      end
      
      # Horizontal flip bit
      player["??? bitfield"][0], other_player["??? bitfield"][0] = other_player["??? bitfield"][0], player["??? bitfield"][0]
    end
    
    # Randomize player trails, and player size. 
    players.each_with_index do |player, player_index|
      player["Trail scale"]         =  rng.rand(0x0D00..0x1200)
      player["Enable player scale"] =  rng.rand(0..1)
      player["Player height scale"] =  player["Trail scale"]
      player["Number of trails"]    =  rng.rand(0x00..0x14)
      
      ["Trail start color", "Trail end color"].each do |attr_name|
        color = 0
        color |= rng.rand(0..0x1F)
        color |= rng.rand(0..0x1F) << 8
        color |= rng.rand(0..0x1F) << 16
        color |= rng.rand(0..0x1F) << 24
        player[attr_name] = color
      end
      
      player.write_to_rom()
    end
  end
  
  def randomize_players
    players = game.players
    
    # Make sure at least one player from each mode in PoR is female, or Astarte can bug out, and one is male, or they won't be able to push heavy objects.
    female_player_indexes = []
    female_player_indexes << [0, 1].sample(random: rng)
    female_player_indexes << [2, 3].sample(random: rng)
    female_player_indexes << [4, 5].sample(random: rng)
    female_player_indexes << 6
    
    players.each_with_index do |player, player_index|
      player["Walking speed"]       =  rng.rand(0x1400..0x2000)
      player["Jump force"]          = -rng.rand(0x5A00..0x6000)
      player["Double jump force"]   = -rng.rand(0x4A00..0x6000)
      player["Slide force"]         =  rng.rand(0x1800..0x5000)
      player["Backdash force"]      = -rng.rand(0x3800..0x5800)
      player["Backdash friction"]   =  rng.rand(0x100..0x230)
      player["Backdash duration"]   =  rng.rand(20..60)
      
      [
        "Actions",
        "??? bitfield",
        "Damage types",
      ].each do |bitfield_attr_name|
        next if player[bitfield_attr_name].nil?
        
        player[bitfield_attr_name].names.each_with_index do |bit_name, i|
          next if bit_name == "Horizontal flip"
          next if bit_name == "Is currently AI partner"
          
          if ["Can slide", "Can use weapons", "Can up-pose", "Can absorb glyphs", "Can superjump"].include?(bit_name)
            player[bitfield_attr_name][i] = true
            next
          end
          
          if bit_name == "Is female"
            if female_player_indexes.include?(player_index)
              player[bitfield_attr_name][i] = true
            else
              player[bitfield_attr_name][i] = false
            end
            next
          end
          
          player[bitfield_attr_name][i] = [true, false].sample(random: rng)
        end
      end
    end
    
    players.each_with_index do |player, i|
      player["Actions"][1] = true # Can use weapons
      player["Actions"][6] = true # Can superjump
      if ["Stella", "Loretta"].include?(player.name)
        player["Actions"][16] = true # No gravity
      else
        player["Actions"][16] = false # No gravity
      end
      if player["Damage types"]
        player["Damage types"][17] = false # Take half damage & Reflect projectiles
        player["Damage types"][18] = true # Can be hit
      end
      
      player.write_to_rom()
    end
  end
end
