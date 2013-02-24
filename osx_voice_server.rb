#
# Make OSX talk through a web browser (iPhone for instance)
#
%w{rubygems sinatra}.each{|r|require r}
# Maybe better to use builder or something
def makeTag(tag, name=nil, value=nil, content=nil)
  return "<#{tag}/>"                                            if name.nil? and value.nil? and content.nil?
  return"<#{tag} name='#{name}' content='#{content}'></#{tag}>" if tag=='meta'
  "<#{tag} name='#{name}' value='#{value}'>#{content}</#{tag}>"
end

def inp(name,value, type='hidden'); "<input type='#{type}' name='#{name}' value='#{value}' />"; end

# Get the List of voices
voices=`say -v?`.split("\n").map{|l|l.gsub('en_US','').split('#')[0].strip}
s=makeTag('select', 'v', '', voices.map{|v|makeTag('option','',v,v)}.join)

# The default form
@@form=makeTag('br') + makeTag('meta', 'viewport', nil, 'width=320') + 
       "<form method='GET' action='/say'>" + 
          inp('p','', 'text') + s + 
       "<input type='submit'/></form>"

# Home Page
get '/' do; @@form; end

# Say Server
get '/say' do
  @@form+="<br/><form method='GET' action='/say'>
      #{inp('v', params['v'].gsub('\'',''))}
      #{inp('p', params['p'].gsub('\'',''))}
      #{params['p']}<input type='submit'/></form>"
  `say -v #{params['v']} #{params['p']}`; params['p'] + @@form 
end
