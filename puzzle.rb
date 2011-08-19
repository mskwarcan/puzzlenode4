require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'

get "/" do
  text_file = []
  
  File.open("public/input.txt").each do |line|
      text_file << line.strip
  end
  
  north_side = []
  south_side = []
  pattern = []
  
  text_file.each_with_index do |line, i|
    if line.include? "X"
      pattern << line
      north_side << text_file[i-1]
      south_side << text_file[i+1]
    end 
  end
  
  @total = []
  
  pattern.each_with_index do |line, i|
    west_side = line.partition(/X/).first.size
    west_side_north = north_side[i][0,west_side].reverse
    west_side_south = south_side[i][0,west_side].reverse
    
    west_count = laser_hits(west_side_north, west_side_south)
    
    east_side = -(line.partition(/X/).last.size)
    east_side_north = north_side[i][east_side,(line.size - east_side)]
    east_side_south = south_side[i][east_side,(line.size - east_side)]
    
    east_count = laser_hits(east_side_north, east_side_south)
    
    if east_count < west_count
      @total << "GO EAST"
      
    else
      @total << "GO WEST"
    end
  end
  
  @total
  
  erb :total
  
end

def laser_hits(north, south)
  count = 0
  
  count += (0..north.size).find_all  {|i| i.odd? and north[i..i] == "|" }.count
  count += (0..south.size).find_all  {|i| i.even? and south[i..i] == "|" }.count
  return count
end
