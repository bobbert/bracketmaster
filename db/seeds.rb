# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'nokogiri'
require 'open-uri'

Season.delete_all

string_fields = [:school, :conference]
fields = [:rank, :school, :conference, :wins, :losses, :pct, 
          :cwins, :closses, :cpct, :ppg, :oppg, :srs, :sos]

Time.now.year.downto(2010).each do |year|
  # get web page and tabular data within page
  url = "http://localhost:3000/static/#{year}-standings.html"
  doc = Nokogiri::HTML(open(url))
  stat_tbl = doc.at_css('table#standings')

  season = Season.new
  season.year = year

  # create subdocument for each team within a given season
  stat_tbl.css('tbody tr').each do |row|
    team_data = {}
    row.css('td').each_with_index do |cell, cellindex|
      field = fields[cellindex]
      if field
        if string_fields.include? field
          team_data[field] = cell.text.strip
        else
          team_data[field] = cell.text.to_f
        end
      end
    end
    puts team_data.inspect
    season.teams.build team_data
  end

  # save data for entire season (includes saving teams)
  season.save!
  puts season.inspect
end

