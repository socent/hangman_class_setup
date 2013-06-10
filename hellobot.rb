require "socket"

@channel = "#bitmaker"
@greeting_prefix = "privmsg #bitmaker :"
@greeting = "hello"

def connect_to_server
  server = "chat.freenode.net"
  port = "6667"
  nick = "HelloBot"
  irc_server = TCPSocket.open(server, port)
  irc_server.puts "USER bhellobot 0 * BHelloBot"
  irc_server.puts "NICK #{nick}"
  irc_server.puts "JOIN #{@channel}"
  irc_server
end

def send_message(msg)
  @irc_server.puts "PRIVMSG #{@channel} :#{msg}"
end

def channel_message?(msg)
  msg.include?(@greeting_prefix)
end

def greeting?(msg)
  msg.include? @greeting  
end

# Establish a connection and join the #bitmaker channel
@irc_server = connect_to_server
# Introduce itself to channel
send_message("Hello from IRB Bot") 

until @irc_server.eof? do
  msg = @irc_server.gets.downcase
  puts msg

  # Reply to "hello"
  if channel_message?(msg) && greeting?(msg)
    send_message("Someone talked to us!!!! Hello!!!")
  end
end

