require 'socket'


3.times do
  puts "\n"
  puts "Starting new connection"

  client = TCPSocket.open('127.0.0.1', 1981)

  cl_buff = 'abcde' * 100000
  puts "Reading on Client"
  client.write(cl_buff)
  puts "Wrote #{cl_buff.size} bytes"
  puts "Last 10 written: #{cl_buff[-10..-1]}"
  # Uncommenting the following will resolve the issue of not all data being transmitted.
  #client.shutdown
  #from_server = client.read()
  #puts "From server: #{from_server}"

  client.close

  puts "\n"
end
