require 'rubygems'
require 'nokogiri'

require_relative 'config/boot'
require_relative 'models/team'
require_relative 'models/game'
require_relative 'models/drive'
require_relative 'models/play'
require_relative 'models/punt'
require_relative 'models/goforit'
require_relative 'models/field_goal'


def normalize(str)
  return str.gsub(/(\n\r)|\s+/, ' ').strip
end

def processPlayByPlay(filename)
  page = Nokogiri::HTML(open(filename))
  puts page.class
  # extract the names of the teams
  roadteam, hometeam = page.css('div.align-center')[0].css('div')[0].text.split(' vs. ')
  puts "#{roadteam} at #{hometeam}"
  # extract the score
  home = Team.find_or_create_by(school: hometeam)
  road = Team.find_or_create_by(school: roadteam)
#  game= Game.find_or_create_by(home_id: home.id, road_id: road.id, home_score: 28, road_score: 27, date: date, gamecode: gamecodes)
  dategame=filename.match(/(\d+{8})/)
  date=dategame.captures
  date = date.join(" ")
  date = date.to_s
  gamecodee=filename.match(/_(\w+)/)
  gamecodes=gamecodee.captures
  gamecodes = gamecodes.join(" ")
  gamecodes = gamecodes.to_s

  puts "Date is " + date
  puts "Gamecode is " + gamecodes







  roadscore = page.css('span.stats-header')[1].text
  homescore = page.css('span.stats-header')[3].text
  puts "roadscore: #{roadscore}, homescore: #{homescore}"
  # extract the shortened team names
  roadteamshort = page.css('span.stats-header')[0].text
  hometeamshort = page.css('span.stats-header')[2].text
  puts "shortened: #{roadteamshort} at #{hometeamshort}"


  game = Game.find_by(gamecode: gamecodes)
  if game == nil
    game= Game.find_or_create_by(home_id: home.id, road_id: road.id, home_score: homescore, road_score: roadscore, date: date, gamecode: gamecodes)

  end
  if game.invalid?
    # check for validation errors
    # see models/game.rb for the validations
    p game.errors.messages
    exit
  end



quaterrr='1st'
  # search for the table rows using a JQuery-like syntax
  page.css('tr.odd, tr.even').each do |e|
    # check if there is a "summary bold" class




    #if game.invalid?
    # check for validation errors
    # see models/game.rb for the validations
   # p game.errors.messages
   # exit
  #end


    summary = e.css('td[class="summary bold"]')
    if summary.length == 1
      # This happens at the end of a drive!
      puts summary.text
    else
      # get first td, which is down/distance
      # then second td, which is event
      downdist=normalize(e.css('td')[0].text)
      event=normalize(e.css('td')[1].text)
      printf("%s => %s\n", downdist, event)
      m = downdist.match(/(^.*) and (\d+) at ([A-Z]+\d+)/i)

      quarter=event.match(/Start of (\d..) quarter,/)
      aliteam=event.match(/(.*) drive start at (.*)./)
      if aliteam != nil
        locat = aliteam.captures[0]
        startime = aliteam.captures[1]

        locat = locat.to_s
        startime = startime.to_s

        puts "Locat is " + locat
        puts "Strttime is " + startime
        touchdawn=even.match(/(TOUCHDOWN)/i)
        team1 = hometeam.downcase
        team2 = locat.downcase

        boolean = team1 <=>  team2

        if (boolean == 1)
          teamid = home
        else
          teamid = road
        end

      end


      if quarter!=nil
        quarterr=quarter.captures
        quaterrr=quarterr.join(" ")
      end
      if touchdawn!=nil&&drive!=nil
        drive.update(points:7)
      end
=begin
      if m != nil
        down, dist, loc = m.captures
        downs=down.to_i
        dists=dist.to_i
        loc=loc.to_s
      end
=end





      if m != nil && startime!=nil && locat!=nil
        down, dist, loc = m.captures
        locationss = loc.to_s
        locations = locationss.match(/\d+/).to_s

        locate = locations.to_i
        locatetemp = locations.to_s
        puts "Location is " + locatetemp






        drive = Drive.find_by(game: game, team: teamid, quarter: quaterrr, starttime: startime, location: locate)
        if drive == nil
          drive = Drive.find_or_create_by(game: game, team: teamid, quarter: quaterrr, starttime: startime, location: locate, points: 0)
        end



      end

    #  team1=loca.downcas


      #if (boolean == 1)
       # team = home
      #else
      #  team = road
      #end

=begin
      drive = Drive.find_by(game: game, team: team, quarter: quaterrr, starttime: startimee, location:lo,points:0)
      if drive == nil
        drive = Drive.find_or_create_by(game: game, team: teamname, quarter: quarterz, starttime: time, location: locate, points: 0)
      end

      if drive.invalid?
        p drive.errors.messages
        exit
      end
=end
      #    # N. Edlund rush for 3 yards to the KC28 (Dakotah Jones).
      # We are going to try to match them with a regexp, one at a time
      if (m = event.match(/.* rush for (\d+) yards? to the ([A-Z]+\d+).*/i)) != nil
        yards, location = m.captures
        # TODO: put into the database
        puts "MATCH: #{yards} #{location}"
      elsif (m = event.match(/.* pass complete to .* for loss of (\d+) yard.*/)) != nil
        # M. McCaffrey pass complete to B. Powers for loss of 3 yards to the KC48 (Dyllan Bailey).
        yards = -m.captures[0].to_i
        puts "MATCH: #{yards}"
      elsif (m = event.match(/.* rush for no gain.*/)) != nil
        # N. Edlund rush for no gain to the KC48 (Adam Jackson).
        yards = 0
        puts "MATCH: #{yards}"
      elsif (m = event.match(/.* punt (\d+) yards to the ([A-Z]+\d+).*fair catch.*/)) != nil
        # M. McCaffrey punt 22 yards to the IC32, fair catch by Kyle Obertino.
        # punt with no return
        yards, location = m.captures
        net = yards
        puts "MATCH: #{yards}"
      elsif (m = event.match(/.* pass complete to .* for (\d+) yard.*/)) != nil
        # Blake Matson pass complete to Kyle Obertino for 6 yards to the IC38 (E. Economos).
        yards = m.captures[0]
        puts "MATCH: #{yards}"
      else
        puts "\n#{event}"
      end
    end
  end
end

def main
  root='play-by-play'
  Dir[root+'/2016/*'].each do |team|
    puts team
  end
  ['2016', '2015', '2014', '2013', '2012', '2011'].each do |year|
    puts year
    Dir[root+'/'+year].each do |team|
      puts team
      Dir[root+'/'+year+'/'+team].each do |file|
        puts file
        processPlayByPlay(root+'/'+year+'/'+team+'/'+file)
      end
    end
end

end

if __FILE__ == $0
  # test on only ony play-by-play record at a time
  # comment this out when you want to process records in bulk
  processPlayByPlay('play-by-play/2016/Knox/20161015_m72v.xml')

  # Use main to run through all data that we have
  #main
end