require 'eventmachine'
require 'yaml'

module EchoServer
  def post_init
    puts "-- someone connected to the echo server!"
  end

  def receive_data data
    # send_data ">>>you sent: #{data}"
    puts data
    write_to_file(data)
    close_connection if data =~ /quit/i
  end

  def unbind
    puts "-- someone disconnected from the echo server!"
  end
  
  def write_to_file s_data
    # Write the incoming data to a file
    data_time = Time.new
    format = data_time.hour.to_s + ":" + data_time.min.to_s + ":" + data_time.sec.to_s
    #data = {format => s_data}
    data = {"Time" => format, "Message" => s_data}
    if(ARGV.length > 1)
      # ARGV[1] is the file we want to write to.
      filename = ARGV[1]
    else
      # Default the file we are writing to.
      filename = "Incoming.yml"
    end
    File.open(filename,"a") {|f| f.write(data.to_yaml) }
  end
end

if (ARGV.length > 0)
  # Load the IP address and Port from the YAML file.
  config_name = ARGV[0]
  config = YAML::load (File.open(config_name))
  ip_addr = config.to_a[0][1] 
  port = config.to_a[1][1]
else
  # No Config File loaded, run with defaults and place in config file.
  puts "No Arguments passed in. ARGV[0] = Config File. ARGV[1] = Log File."
  puts "Using defaults: Config file: Config.yml, Log File: Incoming.yml."
  ip_addr = "127.0.0.1"
  port = 2000
  config_name = "Config.yml"
  config_data = {"IP" => ip_addr, "Port" => port}
  
  File.open(config_name,"w") {|f| f.write(config_data.to_yaml) }
end

EventMachine::run {
  EventMachine::start_server ip_addr, port, EchoServer
}