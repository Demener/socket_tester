require 'socket'
require 'yaml'

class SocketTesterHost
  attr_accessor :sock
  def launch_server (port=2000)
    puts "Launching Server on Port " + port.to_s + "."
    @sock= TCPServer.open(port)
    loop{
      client =  @sock.accept
      puts "Client Connected."
      data =  client.read
      puts data
      write_to_file(data)
      client.close
      puts "Closing Connection."
    }
  end
  
  def write_port s_send
    puts "Sending: " + s_send
    @sock.write(s_send)
  end
  
  def close_port
    @sock.close
    puts "Connection Closed"
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
  
  def load_config arg
    if (arg.length > 0)
      # Load the IP address and Port from the YAML file.
      config_name = arg[0]
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
    launch_server(port)
  end
end

mytester = SocketTesterHost.new
mytester.load_config(ARGV)