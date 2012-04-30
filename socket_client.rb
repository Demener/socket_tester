require 'socket'

class SocketTester
  attr_accessor :sock
  def open_port (hostname='127.0.0.1', port=2000)
    puts "Opening Host " + hostname + " on Port " + port.to_s + "."
    @sock= TCPSocket.open(hostname, port)
  end
  
  def write_port s_send
    puts "Sending: " + s_send
    @sock.write(s_send)
  end
  
  def close_port
    @sock.close
    puts "Connection Closed"
  end
  
  def parse_command arg
    if(arg.length > 2)
      # Data, IP Address, and Port Given
      open_port(arg[1],arg[2])
      write_port(arg[0])
    elsif (arg.length > 0)
      # Data given, Default IP Address and Port
      open_port
      write_port(arg[0])
    else
      # We did not pass any data in.  Default test
      s_default = "ARG[0] = Data, ARG[1] = Host, ARG[2] = Port.  Default Localhost 8081."
      open_port
      write_port(s_default)
    end
    close_port
  end
end

mytester = SocketTester.new
mytester.parse_command(ARGV)