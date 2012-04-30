require 'eventmachine'
require 'yaml'

module EchoServer
  def post_init
    puts "-- someone connected to the echo server!"
  end

  def receive_data data
    #send_data ">>>you sent: #{data}"
    puts data
    write_to_file(data)
    close_connection if data =~ /quit/i
  end

  def unbind
    puts "-- someone disconnected from the echo server!"
  end
  
  def write_to_file s_data
    # Write the incoming data to a file
    data_time = Time.now
    data = {"Data" => s_data}
    File.open("Incoming.yml","w") {|f| f.write(data.to_yaml) }
  end
end

EventMachine::run {
  EventMachine::start_server "127.0.0.1", 2000, EchoServer
}