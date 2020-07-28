#!/usr/bin/env ruby
require 'optparse'
require 'net/http'
require 'json'
require 'time'
require './colourize'

def get_JSON(url)
  uri = URI(url)
  response = Net::HTTP.get(uri)
  return JSON.parse(response)
end


OptionParser.new do |parser|

  parser.on("-l", "--logo") do 
    puts "
    ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄       ▄▄  ▄         ▄  ▄            ▄▄▄▄▄▄▄▄▄▄▄          ▄▄▄▄     
    ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░▌     ▐░░▌▐░▌       ▐░▌▐░▌          ▐░░░░░░░░░░░▌       ▄█░░░░▌    
    ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌░▌   ▐░▐░▌▐░▌       ▐░▌▐░▌          ▐░█▀▀▀▀▀▀▀█░▌      ▐░░▌▐░░▌    
    ▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌▐░▌ ▐░▌▐░▌▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌       ▀▀ ▐░░▌    
    ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌ ▐░▐░▌ ▐░▌▐░▌       ▐░▌▐░▌          ▐░█▄▄▄▄▄▄▄█░▌          ▐░░▌    
    ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌  ▐░▌  ▐░▌▐░▌       ▐░▌▐░▌          ▐░░░░░░░░░░░▌          ▐░░▌    
    ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌▐░█▀▀▀▀█░█▀▀ ▐░▌   ▀   ▐░▌▐░▌       ▐░▌▐░▌          ▐░█▀▀▀▀▀▀▀█░▌          ▐░░▌    
    ▐░▌          ▐░▌       ▐░▌▐░▌     ▐░▌  ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌          ▐░░▌    
    ▐░▌          ▐░█▄▄▄▄▄▄▄█░▌▐░▌      ▐░▌ ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌      ▄▄▄▄█░░█▄▄▄ 
    ▐░▌          ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌     ▐░░░░░░░░░░░▌
     ▀            ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀       ▀▀▀▀▀▀▀▀▀▀▀         
    v1.0                                                                                                   
    "
  end

  parser.on("-r", "--results", "Results for the latest race") do
    
    race = get_JSON('https://ergast.com/api/f1/current/last/results.json')["MRData"]["RaceTable"]["Races"][0]

    raceDetails = " Latest Race Results
------------------------------
Round ##{race['round']} - #{race['raceName'].light_blue} 
#{race['Circuit']['circuitName']}, #{race['Circuit']['Location']['locality']}, #{race['Circuit']['Location']['country'] } on #{race['date']}
"
    results = race['Results'].map{ |driver| "#{driver['position']}. #{driver['Driver']['familyName'].green} - pts: #{driver['points'].yellow}" }
    puts(raceDetails)
    puts("\nResults".yellow)
    puts(results)
    puts("\n")
  end

  parser.on("-s", "--schedule", "Schedule for the current season") do
    
    races = get_JSON('https://ergast.com/api/f1/current.json')["MRData"]["RaceTable"]["Races"]

    races = races.map { |race| "#{race['round']}. #{race['raceName'].light_blue} 
   #{race['Circuit']['circuitName']}, #{race['Circuit']['Location']['locality']}, #{race['Circuit']['Location']['country'] }
   #{race['date']} @ #{Time.parse(race['time'].tr('Z', '')).getlocal} \n\n" }
   
    puts('')
    puts(races)
  end

  parser.on("-c", "--constructors", "Constructor standings for the current season") do
    constructor_standings = get_JSON('https://ergast.com/api/f1/current/constructorStandings.json')["MRData"]["StandingsTable"]["StandingsLists"][0]["ConstructorStandings"]
    constructor_standings = constructor_standings.map { |constructor| "#{constructor['position']}. #{constructor['Constructor']["name"].green} - #{constructor["points"].yellow} pts
    " }

    puts("Constructor Standings")
    puts(constructor_standings)
  end

  parser.on("-d", "--drivers", "Driver standings for the current season") do
    driver_standings = get_JSON('https://ergast.com/api/f1/current/driverStandings.json')["MRData"]["StandingsTable"]["StandingsLists"][0]["DriverStandings"]
    driver_standings = driver_standings.map { |driver| "#{driver['position']}.  #{driver['Driver']['givenName'].green} #{driver['Driver']['familyName'].green}  (#{driver['Constructors'][0]['name']}) - #{driver['points'].yellow} pts
    " }
    
    puts("Driver Standings")
    puts(driver_standings)
  end

end.parse!
