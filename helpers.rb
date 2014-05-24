require 'csv'
require 'net/http'
require 'uri'

def make_data()
  links = []
  CSV.foreach('data/linklist.csv', headers: true, header_converters: :symbol) do |row|
    links << row.to_hash
  end
  links
end

def fix_url(url)
  if url[0..6] != "http://" && url[0..7] != "https://"
    url = "http://" + url
  end
  if url[-1] == "/"
    url = url.chop
  end
  url
end

def check_url(url)
  begin
    if Net::HTTP.get_response(URI.parse(url)).code != "200"
      return true
    else
      return false
    end
  rescue
    return true
  end
  false
end

def check_dupurl(url, data)
  data.each do |line|
    if url == line[:url]
      return true
    end
  end
  false
end

def check_blank(url)
  if url == ""
    return true
  end
  false
end

def save_link(url, data)
  link = "http://ni.ck/" + rand(36**6).to_s(36)
  while check_dupurl(link, data) == true
    link = "http://ni.ck/" + rand(36**6).to_s(36)
  end

  File.open('data/linklist.csv', 'a') do |file|
    file.puts url + "," + link + "," + "0"
  end
end

def find_url(url, data)
  data.each do |line|
    if url[-6..-1] == line[:short][-6..-1]
      return line[:url]
    end
  end
  return false
end

def update_data(url, data)
  File.open('data/linklist1.csv', "w") do |file|
    file.puts "url,short,clicked"
    data.each do |line|
      num = 0
      if line[:short] == url
        num = 1
      end
      file.puts line[:url] + "," + line[:short] + "," + (line[:clicked].to_i + num).to_s
    end
  end
  File.delete('data/linklist.csv')
  File.rename('data/linklist1.csv', 'data/linklist.csv')
end



