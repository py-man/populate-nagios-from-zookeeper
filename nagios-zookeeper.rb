#!/opt/local/bin/ruby
##Name: ruby-parse.rb
##created by : kevin brannigan
##program to parse custom zookeeper json output & create a nagios config

##Required Ruby gems
require 'rubygems'
require 'pp'
require 'json'
require "erb"
require "yaml"
require 'wd_class'
require 'curl'

#load and parse json
json_to_use = './output.json'
latest_json =  Json_Parser.new(json_to_use)
latest_json.load
wd_custom_json = latest_json.do_parse

##process the json and display as text or properties(json)
processed_data = Process_wd_json.new(wd_custom_json)
processed_data.get_data
processed_data.show_data_as_text
processed_data.show_properties


##Helper function for ERB config population
def hosts_by_label(label)
  @hosts = []
  @host_labels.each { |host,labels|
    @hosts << host if labels.include?(label)
  }
  return @hosts
end

##Create nagios config using erb template  (load yaml files) call method to create files
@host_labels = YAML::load(File.new("hostlabels.yaml"))
@label_checks = YAML::load(File.new("labelchecks.yaml"))
nConfig =  Nagios_wd_Config.new(@host_labels,@label_checks)
nConfig.create
nConfig.show_config

def test
##test again a dynamic ec2 instance
url_so = 'zk instance goes here '
curl = Curl::Easy.new(url_so)
curl.username = '***'
curl.password = '***'
curl.perform
data_obj = JSON.parse(curl.body_str)
j_file = '/location/of/file'
if File.exist?(j_file)
      puts "\n\nFile: " + j_file + "...Exists"
      res = File.delete(j_file)
      res = "OK" if res == 1

      puts "\nDelting..." + res.to_s
    end    
outFile = File.new(j_file, "w")
outFile.puts(data_obj)
outFile.close
end
