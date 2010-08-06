require 'socket'

def running?
  #puts "Testing running: #{@running}"
  @running
end

def start
  @running = true
end

def stop
  @running = false
end

server = TCPServer.new(1981)

connector = Thread.new do
  sleep(0.5) until running?
  while running?
    begin
      sock = server.accept_nonblock
    rescue Errno::EAGAIN, Errno::ECONNABORTED, Errno::EPROTO, Errno::EINTR
      sock = nil
      IO.select([server])
      retry if running?
    end
    if sock #&& running?
      a = Thread.new(sock) do |s|
        puts "Spinning up and writing data"
        s.puts("220 Welcome")
        puts "Data was written!"
        buff = ""
        loop do
          puts "Reading on Server"
          begin
            inp = s.read()
            break if inp.empty?
            buff += inp
          rescue Exception => err
            puts "EXCEPTION: #{err}"
            break
          end
        end
        s.shutdown
        puts "Read #{buff.size} bytes"
        puts "Last 10 read: #{buff[-10..-1]}"
        s.close
      end
      a.join
      stop
      sock = nil
    end
  end
end

start

sleep(1)

client = TCPSocket.open('127.0.0.1', 1981)

cl_buff = 'abcde' * 10000
puts "Reading on Client"
client.write(cl_buff)
puts "Wrote #{cl_buff.size} bytes"
puts "Last 10 written: #{cl_buff[-10..-1]}"
client.shutdown(1)
from_server = client.read()
puts "From server: #{from_server}"

client.close

connector.join
