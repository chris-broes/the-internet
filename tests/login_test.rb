require 'peach'
require 'selenium-webdriver'
require 'rest-client'

caps1 = Selenium::WebDriver::Remote::Capabilities.internet_explorer
caps1['platform'] = 'Windows 7'
caps1['version'] = 'latest'
caps1["name"] = "Selenium with Sauce on IE 9"
#caps1["tunnelIdentifier"] = "35.1"


caps2 = Selenium::WebDriver::Remote::Capabilities.new
caps2["browserName"] = "Chrome"
caps2["version"] = "latest"
caps2["platform"] = "Linux"
caps2["name"] = "Selenium with Sauce on Chrome"
#caps2["tunnelIdentifier"] = "35.1"

caps3 = Selenium::WebDriver::Remote::Capabilities.new
caps3["browserName"] = "Firefox"
caps3["version"] = "45.0"
caps3["platform"] = "OS X 10.10"
caps3["name"] = "Selenium with Sauce on Firefox"
#caps3["tunnelIdentifier"] = "35.1"

caps4 = Selenium::WebDriver::Remote::Capabilities.new
caps4["browserName"] = "Internet Explorer"
caps4["platform"] = 'Windows 8.1'
caps4["version"] = '11.0'
caps4["name"] = "Selenium with Sauce on IE 11"
#caps4["tunnelIdentifier"] = "35.1"

caps = [caps1, caps2, caps3, caps4]

caps.peach do |cap|
  # In order to connect to Sauce Labs you will need your Sauce Labs username and access key.
  # Your username and access key can be found here https://saucelabs.com/account
  driver = Selenium::WebDriver.for(:remote,
                                   :url => "http://" + ENV['SAUCE_USERNAME'] + ":" +  ENV['SAUCE_ACCESS_KEY'] + "@ondemand.saucelabs.com:80/wd/hub",
                                   :desired_capabilities => cap)

  wait = Selenium::WebDriver::Wait.new(:timeout => 5)
  driver.navigate.to "http://localhost:9292/login"

  element = driver.find_element(:id, 'username')
  
  wait.until  { element }
  

  element.send_keys "tomsmith"
  element = driver.find_element(:id, 'password')
  element.send_keys "SuperSecretPassword!"
  element.submit
  
  pageload = driver.find_element(:id, 'flash-messages')
  wait.until { pageload }
  puts "Page header is: #{driver.title}"
  if not driver.find_element(:id, 'flash-messages').text.include? 'secure area'
    body = {"passed" => false}.to_json
    puts "Login has failed :("
  else
    body = {"passed" => true}.to_json
    puts "Login is a success!"
  end
  driver.quit

  job_id = driver.session_id

  http = "https://saucelabs.com/rest/v1/" + ENV['SAUCE_USERNAME'] + "/jobs/#{job_id}"

  

  RestClient::Request.execute(
    :method => :put,
    :url => http,
    :user => ENV['SAUCE_USERNAME'],
    :password => ENV['SAUCE_ACCESS_KEY'],
    :headers => {:content_type => "application/json"},
    :payload => body
  )

  puts "The test has #{body}, and the results are available here \n https://saucelabs.com/rest/v1/" + ENV['SAUCE_USERNAME'] + "/jobs/#{job_id}"

end
