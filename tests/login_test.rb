require 'peach'
require 'selenium-webdriver'

caps1 = Selenium::WebDriver::Remote::Capabilities.safari
caps1['platform'] = 'OS X 10.9'
caps1['version'] = '7.0'
caps1["name"] = "Selenium with Sauce on Safari"

caps2 = Selenium::WebDriver::Remote::Capabilities.new
caps2["browserName"] = "Chrome"
caps2["version"] = "27"
caps2["platform"] = "Linux"
caps2["name"] = "Selenium with Sauce on Chrome"

caps3 = Selenium::WebDriver::Remote::Capabilities.new
caps3["browserName"] = "Firefox"
caps3["version"] = "35.0"
caps3["platform"] = "OS X 10.10"
caps3["name"] = "Selenium with Sauce on Firefox"

caps4 = Selenium::WebDriver::Remote::Capabilities.new
caps4["browserName"] = "Internet Explorer"
caps4["platform"] = 'Windows 8.1'
caps4["version"] = '11.0'
caps4["name"] = "Selenium with Sauce on IE 11"

caps = [caps1, caps2, caps3, caps4]

caps.peach do |cap|
  # In order to connect to Sauce Labs you will need your Sauce Labs username and access key.
  # Your username and access key can be found here https://saucelabs.com/account
  driver = Selenium::WebDriver.for(:remote,
                                   :url => "http://" + ENV['SAUCE_USERNAME'] + ":" +  ENV['SAUCE_ACCESS_KEY'] + "@ondemand.saucelabs.com:80/wd/hub",
                                   :desired_capabilities => caps)

  driver.navigate.to "http://0.0.0.0:9292/login"
  element = driver.find_element(:id, 'username')
  element.send_keys "tomsmith"
  element = driver.find_element(:id, 'password')
  element.send_keys "SuperSecretPassword!"
  #element = driver.find_element(:id, 'gbqfb').click
  element.submit
  puts "Page header is: #{driver.title}"
  driver.quit

  #  if (!driver.findElement(By.tagName("html")).getText().contains("Secure Area")) {
  #     System.out.println("verifyTextPresent failed");
end
