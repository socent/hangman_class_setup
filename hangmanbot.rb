# assumes hangman class is in a subfolder

require "socket"
require_relative 'hangman/hangman'

@channel = "#bitmaker"
@greeting_prefix = "privmsg #bitmaker :"
@guess_prefix = "guess"

def connect_to_server
  server = "chat.freenode.net"
  port = "6667"
  nick = "HangmanBot"
  irc_server = TCPSocket.open(server, port)
  irc_server.puts "USER bhangmanbot 0 * BHangmanBot"
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

def guess?(msg)
  msg.include? @guess_prefix
end

def output_board
  send_message "Board: #{@game.board}"
  send_message "Guessed letters: #{@game.guesses}"
  send_message "Chances: #{@game.chances}" 
  send_message "Take your best shot! Enter guess: "
end

def extract_guess(msg)
  msg.chomp[-1]
end

# Establish a connection and join the #bitmaker channel
@irc_server = connect_to_server
@game = Hangman.new
# Introduce itself to channel
send_message("Hello from Hangman Bot. Starting a new game") 
output_board

until @irc_server.eof? do
  msg = @irc_server.gets.downcase
  puts msg

  # Reply to "hello"
  next unless channel_message?(msg) && guess?(msg)
  guess = extract_guess(msg)
  puts "!!! GUESS ENCOUNTERED: #{guess}"
  send_message("You guessed #{guess}")

  begin
    if @game.guess(guess)
      send_message "Nice!"  
    else
      send_message "Nope!!!"  
    end
  rescue Hangman::InvalidGuessException => e
    send_message e.message
  end

  if @game.win?
    puts "\n\nCongratulations! You won!\n"
    break
  elsif @game.lost?
    puts "\n\nYou lost. The word was #{@game.word}\n" 
    break
  end

  output_board
  
end

