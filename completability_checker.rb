
require 'yaml'

class CompletabilityChecker
  attr_reader :game,
              :rng,
              :current_items,
              :defs,
              :enemy_locations
  
  def initialize(game, enable_glitches)
    @game = game
    @enable_glitches = enable_glitches
    
    @rng = Random.new
    load_room_reqs()
    @current_items = []
    @debug = false
  end
  
  def load_room_reqs
    yaml = YAML::load_file("./dsvrandom/requirements/#{GAME}_pickup_requirements.txt")
    @room_reqs = {}
    
    defs = yaml["Defs"]
    @defs = {}
    defs.each do |name, reqs|
      name = name.strip.tr(" ", "_").to_sym
      reqs = parse_reqs(reqs)
      @defs[name] = reqs
    end
    
    glitch_defs = yaml["Glitch defs"]
    @glitch_defs = {}
    glitch_defs.each do |name, reqs|
      name = name.strip.tr(" ", "_").to_sym
      reqs = parse_reqs(reqs)
      @glitch_defs[name] = reqs
    end
    
    if @enable_glitches
      @defs.merge!(@glitch_defs)
    end
    
    rooms = yaml["Rooms"]
    
    @enemy_locations = []
    
    rooms.each do |room_str, yaml_reqs|
      @room_reqs[room_str] ||= {}
      @room_reqs[room_str][:room] = nil
      @room_reqs[room_str][:entities] = {}
      
      yaml_reqs.each do |applies_to, reqs|
        parsed_reqs = parse_reqs(reqs)
        
        if applies_to == "room"
          @room_reqs[room_str][:room] = parsed_reqs
        else
          entity_index = applies_to.to_i(16)
          @room_reqs[room_str][:entities][entity_index] = parsed_reqs
          
          if applies_to.end_with?(" (Enemy)")
            entity_str = "#{room_str}_%02X" % entity_index
            @enemy_locations << entity_str
          end
        end
      end
    end
  end
  
  def parse_reqs(reqs)
    if reqs.is_a?(Integer) || reqs.nil?
      return reqs
    end
    
    or_reqs = reqs.split("|")
    or_reqs.map! do |or_req|
      and_reqs = or_req.split("&")
      and_reqs.map! do |and_req|
        and_req = and_req.strip.tr(" ", "_").to_sym
        and_req = nil if and_req.empty?
        and_req
      end
    end
  end
  
  def game_beatable?
    check_reqs([[:beat_game]])
  end
  
  def check_reqs(reqs)
    @cached_checked_reqs = {}
    check_multiple_reqs_recursive(reqs)
  end
  
  def check_req_recursive(req)
    puts "Checking req: #{req}" if @debug
    
    if @defs[req]
      if @defs[req].is_a?(Integer)
        item_global_id = @defs[req]
        has_item = @current_items.include?(item_global_id)
        @cached_checked_reqs[@defs[req]] = has_item
        return has_item
      end
      
      if @cached_checked_reqs[req] == :currently_checking
        # Don't recurse infinitely checking the same two interdependent requirements.
        return false
      elsif @cached_checked_reqs[req] == true || @cached_checked_reqs[req] == false
        return @cached_checked_reqs[req]
      end
      @cached_checked_reqs[req] = :currently_checking
      
      req_met = check_multiple_reqs_recursive(@defs[req])
      puts "Req #{req} is true" if @debug && req_met
      puts "Req #{req} is false" if @debug && !req_met
      @cached_checked_reqs[req] = req_met
      return req_met
    else
      if !@enable_glitches && @glitch_defs.include?(req)
        # When glitches are disabled, always consider a glitch requirement false.
        return false
      end
      raise "Invalid requirement: #{req}"
    end
  end
  
  def check_multiple_reqs_recursive(or_reqs)
    return true if or_reqs.nil?
    
    or_reqs.each do |and_reqs|
      or_req_met = and_reqs.all? do |and_req|
        check_req_recursive(and_req)
      end
      
      puts "Req #{req} is true (OR req: #{and_reqs})" if @debug && or_req_met
      return true if or_req_met
    end
    
    puts "Req #{req} is false" if @debug
    return false
  end
  
  def all_locations
    @all_locations ||= begin
      all_locations = {}
      
      @room_reqs.each do |room_str, room_req|
        room_access_reqs = room_req[:room]
        room_entities_reqs = room_req[:entities]
        
        room_entities_reqs.each do |entity_index, entity_reqs|
          entity_str = "#{room_str}_%02X" % entity_index
          all_locations[entity_str] = {room_reqs: room_access_reqs, entity_reqs: entity_reqs}
        end
      end
      
      all_locations
    end
  end
  
  def get_accessible_locations
    accessible_locations = []
    
    all_locations.each do |entity_str, reqs|
      room_reqs = reqs[:room_reqs]
      entity_reqs = reqs[:entity_reqs]
      
      if check_reqs(room_reqs) && check_reqs(entity_reqs)
        accessible_locations << entity_str
      end
    end
    
    return accessible_locations
  end
  
  def all_progression_pickups
    @all_progression_pickups ||= begin
      pickups = []
      
      @defs.each do |name, req|
        pickups << req if req.is_a?(Integer)
      end
      
      pickups
    end
  end
  
  def pickups_by_current_num_locations_they_access
    orig_current_items = @current_items
    
    possibly_useful_pickups = all_progression_pickups - @current_items
    
    currently_accessible_locations = get_accessible_locations()
    
    pickups_by_locations = {}
    
    possibly_useful_pickups.each do |pickup_global_id|
      @current_items = orig_current_items + [pickup_global_id]
      next_accessible_pickups = get_accessible_locations() - currently_accessible_locations
      
      pickups_by_locations[pickup_global_id] = next_accessible_pickups.length
    end
    
    return pickups_by_locations
  ensure
    @current_items = orig_current_items
  end
  
  def add_item(new_item_global_id)
    @current_items << new_item_global_id
  end
  
  def generate_empty_item_requirements_file
    File.open("./dsvrandom/#{GAME}_pickup_requirements.txt", "w+") do |f|
      prev_area_name = nil
      prev_sector_name = nil
      game.each_room do |room|
        pickups = room.entities.select{|e| e.is_pickup? || e.is_item_chest? || e.is_money_chest?}
        next if pickups.empty?
        
        area_name = AREA_INDEX_TO_AREA_NAME[room.area_index]
        if area_name != prev_area_name
          f.puts "#%s:" % area_name
          prev_area_name = area_name
        end
        
        if SECTOR_INDEX_TO_SECTOR_NAME[room.area_index]
          sector_name = SECTOR_INDEX_TO_SECTOR_NAME[room.area_index][room.sector_index]
          if sector_name != prev_sector_name
            f.puts "#%s:" % sector_name
            prev_sector_name = sector_name
          end
        end
        
        f.puts "  %02X-%02X-%02X:" % [room.area_index, room.sector_index, room.room_index]
        f.puts "    room: "
        pickups.each do |e|
          i = room.entities.index(e)
          
          name = get_item_name_for_generated_reqs_file(e)
          hidden_string = ""
          hidden_string = " (Hidden)" if e.is_hidden_pickup?
          f.puts "    %02X (%s)#{hidden_string}: " % [i, name]
        end
      end
    end
  end
  
  def get_item_name_for_generated_reqs_file(pickup)
    if pickup.is_heart?
      return "Heart"
    end
    if pickup.is_money_bag?
      return "Money"
    end
    if pickup.is_item?
      if GAME == "ooe"
        item_id = pickup.var_b - 1
        item = game.items[item_id]
        return item.name
      else
        item_type_index = pickup.subtype
        item_index = pickup.var_b
        item = game.get_item_by_type_and_index(item_type_index, item_index)
        return item.name
      end
    end
    if pickup.is_skill?
      item_type_index = PICKUP_SUBTYPES_FOR_SKILLS.begin
      item_index = pickup.var_b
      item = game.get_item_by_type_and_index(item_type_index, item_index)
      return item.name
    end
    if pickup.is_item_chest?
      item_id = pickup.var_a - 1
      item = game.items[item_id]
      return item.name
    end
    if pickup.is_money_chest?
      return "Money Chest"
    end
  end
end