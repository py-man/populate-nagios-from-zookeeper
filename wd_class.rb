class Properties
  attr_accessor :ots_info, :ots_url, :esb_url, :service_type, :state, :connector, :esb, :hostname
  def initialize(ots_info, ots_url, esb_url, service_type, state, connector, esb, hostname)
    @ots_info = ots_info
    @ots_url = ots_url
    @esb_url = esb_url
    @hostname = hostname
    @service_type = service_type
    @state = state
    @connector = connector
    @esb = esb
  end
end

class Process_wd_json
  attr_accessor :json
  def initialize(json)
    @json = json
    $properties = []
  end
   
  def get_data
    i=0
    members = @json
    ##Traverse the JSON levels to get the nodeName Key and nodeData values
    members['childNodes'].each do |json_level1|
      json_level1["childNodes"].each do |json_level2|
        json_level2['childNodes'].each do |json_level3|
          json_level3['childNodes'].each do |json_level4|
            json_level4['childNodes'].each do |json_level5|

            ##Get and set Key , Value pair and print if they have a value
              service_type = json_level5['nodeName']
              service_type.gsub!( '/', "" )
      
              ##Iterate through lists of tenants and display values
              tenant_list = json_level5['nodeData'].keys.grep(/tenant/)
              tenant_list.sort
              ots_info = Array.new
              tenant_list.each do |tenant_data|
                m = " , " + json_level5['nodeData'][tenant_data] unless json_level5['nodeData'][tenant_data].nil?
                ots_info.push(m)
              end

              ##Define all the property types
              hostname = json_level5['nodeData']['wd.host'] unless json_level5['nodeData']['wd.host'].nil?
              state = json_level5['nodeData']['member.state'] unless json_level5['nodeData']['member.state'].nil?
              connector = json_level5['nodeData']["wd.connector.port"] unless json_level5['nodeData']["wd.connector.port"].nil?
              actor = json_level5['nodeData']["wd.actor.port"] unless json_level5['nodeData']["wd.actor.port"].nil?
              esb_type = json_level5['nodeData']["wd.esb.supported.types"] unless json_level5['nodeData']["wd.esb.supported.types"].nil?
              ots_url = json_level5['nodeData']['service.url'] unless json_level5['nodeData']['service.url'].nil?
              esb_url = json_level5['nodeData']['wd.service.url'] unless json_level5['nodeData']['wd.service.url'].nil?

              i+=1
              a = Properties.new( "#{ots_info}", "#{ots_url}", "#{esb_url}", "#{service_type}",  "#{state}", "#{connector}",  "#{esb_type}", "#{hostname}#{i}")
              $properties.push(a)
            end
          end
        end
      end
    end
  end
  
  def show_data_as_text
    #$properties = []
    i=0
    members = @json
    puts "-------------------------------------------------------------------------------"
    ##Traverse the JSON levels to get the nodeName Key and nodeData values
    members['childNodes'].each do |json_level1|
      json_level1["childNodes"].each do |json_level2|
        json_level2['childNodes'].each do |json_level3|
          json_level3['childNodes'].each do |json_level4|
            json_level4['childNodes'].each do |json_level5|

            ##Get and set Key , Value pair and print if they have a value
              service_type = json_level5['nodeName']
              service_type.gsub!( '/', "" )
              puts "Name: #{service_type}".upcase
              puts 'Running_on_Host: '=>json_level5['nodeData']['wd.host'] unless json_level5['nodeData']['wd.host'].nil?
              puts 'State: '=>json_level5['nodeData']['member.state'] unless json_level5['nodeData']['member.state'].nil?
              puts 'Connector: '=>json_level5['nodeData']["wd.connector.port"] unless json_level5['nodeData']["wd.connector.port"].nil?
              puts 'Actor: '=>json_level5['nodeData']["wd.actor.port"] unless json_level5['nodeData']["wd.actor.port"].nil?
              puts 'Esb_Type: '=>json_level5['nodeData']["wd.esb.supported.types"] unless json_level5['nodeData']["wd.esb.supported.types"].nil?

              ##Iterate through lists of tenants and display values
              tenant_list = json_level5['nodeData'].keys.grep(/tenant/)
              tenant_list.sort
              ots_info = Array.new
              tenant_list.each do |tenant_data|
                puts "#{tenant_data}: "=>json_level5['nodeData'][tenant_data] unless json_level5['nodeData'][tenant_data].nil?
                m = " , " + json_level5['nodeData'][tenant_data] unless json_level5['nodeData'][tenant_data].nil?
                ots_info.push(m)
              end

              puts 'OTS Service URL: '=>json_level5['nodeData']['service.url'] unless json_level5['nodeData']['service.url'].nil?
              puts 'ESB Service URL: '=>json_level5['nodeData']['wd.service.url'] unless json_level5['nodeData']['wd.service.url'].nil?
              puts 'Service Updated: '=>json_level5['nodeData']['last.update'] unless json_level5['nodeData']['last.update'].nil?
              puts "-------------------------------------------------------------------------------"
              puts " "

              ##Define all the property types
              hostname = json_level5['nodeData']['wd.host'] unless json_level5['nodeData']['wd.host'].nil?
              state = json_level5['nodeData']['member.state'] unless json_level5['nodeData']['member.state'].nil?
              connector = json_level5['nodeData']["wd.connector.port"] unless json_level5['nodeData']["wd.connector.port"].nil?
              actor = json_level5['nodeData']["wd.actor.port"] unless json_level5['nodeData']["wd.actor.port"].nil?
              esb_type = json_level5['nodeData']["wd.esb.supported.types"] unless json_level5['nodeData']["wd.esb.supported.types"].nil?
              ots_url = json_level5['nodeData']['service.url'] unless json_level5['nodeData']['service.url'].nil?
              esb_url = json_level5['nodeData']['wd.service.url'] unless json_level5['nodeData']['wd.service.url'].nil?

              i+=1
              #b = {"#{hostname}#{i}" => [ 'service_type' => "#{service_type}", 'state' => "#{state}", 'connector' => "#{connector}", 'esb' => "#{esb_type}" ] }
              #m
              a = Properties.new( "#{ots_info}", "#{ots_url}", "#{esb_url}", "#{service_type}",  "#{state}", "#{connector}",  "#{esb_type}", "#{hostname}#{i}")
              $properties.push(a)

            #all_hosts["#{hostname}#{i}"] = [ 'service_type' => "#{service_type}", 'state' => "#{state}", 'connector' => "#{connector}", 'esb' => "#{esb_type}" ]

            end
          end
        end
      end
    end
  end

  def show_properties
      prop_array = {}
      $properties.each do |a|
      prop_array[a.hostname] ||= []
      prop_array[a.hostname] << a.service_type << a.state << a.connector << a.esb << a.ots_info << a.ots_url << a.esb_url
    end
      pp prop_array
  end
end

class Json_Parser
  attr_accessor :json_output_file
  def initialize(json_output_file)
    @json_output = json_output_file
    @json_array = []
    @members = []
  end
  
  def load
    #read in JSON file and Parse to an array
    @json_array = File.read(@json_output)
  end
  
  def do_parse
    #read in JSON file and Parse to an array
    @members = JSON.parse(@json_array)
    return @members
  end
end  


class Nagios_wd_Config
  attr_accessor :hlabels, :llabels
  def initialize(hlabels, llabels)
  @host_labels = hlabels
  @label_checks = llabels
  @hosts = []
  @template =[]
  end
  
 def create
    def hosts_by_label(label)
      @hosts = []
      @host_labels.each { |host,labels|
        @hosts << host if labels.include?(label)
      }
      return @hosts
    end

    config_template = File.new("nagios.cfg.erb").read

    # see ERB.new docs for 'trim_mode' for info on "%>" below
    @template =  ERB.new(config_template, nil, "%<>")

    ##create a nagios host file
    nagios_config_file = "host-services.cfg"

    if File.exist?(nagios_config_file)
      puts "\n\nFile: " + nagios_config_file + "...Exists"
      res = File.delete(nagios_config_file)
      res = "OK" if res == 1

      puts "\nDelting..." + res.to_s
    end    
    outFile = File.new(nagios_config_file, "w")
    outFile.puts(@template.result)
    outFile.close
    
     puts "\nJob Completed...OK\n " unless File.size(nagios_config_file) <= 10
  end
  
  def show_config
     puts @template.result
  end

  def show_config_as_json
     pp @template.result
  end
  
end 

