%w{rubygems Hpricot open-uri rserve fileutils}.each{|r|require r}
include Rserve

# Skip if you have Rserve running
begin
  puts "Creating a new Rserve Connection."
  $c = Connection.new
rescue
  puts "Could not create an Rserve Connection: #{$!}"
  puts "Trying to start one now..."
  File.open('tmp.R','w'){|f|f.puts "library(Rserve)\nRserve()"} 
  system('"R.exe" --no-save < tmp.R')
  sleep 3
  $c = Connection.new
  puts "Rserve Started."
end 

#
# Get Google GeoCode location for location specified in the string
#
  def get_location(str)
    u=URI.encode("http://maps.google.com/maps/api/geocode/xml?sensor=false&address=#{str}")
    loc=(Hpricot.XML(open(u)))/'//location'
    h={} 
    h['lat']=(loc/:lat).inner_text
    h['lng']=(loc/:lng).inner_text
    h
  end

#
# Get the list of conferences  - this is customized to a page.
#
def get_conference_list()
  u='http://blog.sphereinc.com/2010/08/13-upcoming-ruby-and-rails-conferences-you-dont-want-to-miss'
  doc=Hpricot(open(u))
  recs=[]
  (doc/"//div[@id='post-216']/div/p/strong").entries.each_with_index{|e,i|    
     h={} 
     e.inner_text.split("\n").each{|d|
       p=d.split(':')
       unless [nil,''].include?(p[0]) or  [nil,''].include?(p[1])
         #  puts ">>#{p[0].strip} = #{p[1].strip}<<"
         h[p[0].strip]= p[1].strip       
       end
     }
     recs << h
  }
  recs
end

#
# Main Processing
#
puts "Get the List of Conferences.."
recs=get_conference_list()

puts "Geocoding the Conference Locations"
locations=[]
recs.each_with_index{|r,i|locations<<r.merge(get_location(r['Location']))}
cols=%w{Location Date Price Length lat lng}

puts "Writing data to txt file"
File.open('ruby_conference_locations.txt','w'){|f|
    f.puts cols.join(";")
    locations.each{|l|
      str=''
      cols.each{|k|str+="#{l[k]};"}
      f.puts str.chop
    }
}

puts "Running the R Program to read the data and Create the Maps"
r_program=File.open('upcoming_ruby_conferences.R').readlines.join
r_program.gsub!('<PresentWorkingDirectory>',FileUtils.pwd+'/')
$c.eval(r_program)