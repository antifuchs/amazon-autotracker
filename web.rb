require 'sinatra'
require 'twitter'

$stdout.sync = true

TRACK_ACCOUNT='TrackThis'

post '/amazon' do
  subject = params[:subject]
  body = clean_body(params[:plain])
  if tracking_no = extract_tracking_no(body)
    shipped_thing = extract_title(subject)
    message = "D #{TRACK_ACCOUNT} #{tracking_no} #{shipped_thing}"
    $stdout.puts message
    Twitter.update message
    "Tweeted"
  else
    halt 400, "No tracking number found in:\n\n #{body.inspect}"
  end
end

def extract_title(subject)
  re = /Your Amazon.com order of (.*) has shipped!/
  if thing = subject.match(re) && $1
    thing.gsub!(/^"(.*)"$/, $1)
    thing = thing[0..100]
  else
    '(huh?)'
  end
end

def extract_tracking_no(body)
  re = /Your package is being shipped .* and the tracking number is (\w+)\./
  body.match(re) && $1
end

def clean_body(body)
  body.gsub(/^> /m, '').gsub(/\s+/, ' ')
end
