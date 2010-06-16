require 'socket'

server = TCPServer.new(1981)
shutdown = false
r_pipes = []
total_bytes = 0

handler = lambda do |sig|
  lambda do
    puts "Installing default handler"
    trap(sig, "EXIT")
    r_pipes.each do |rp|
      ch_read = rp.read rescue nil
      if ch_read && ch_read.length > 0
        total_bytes += ch_read.to_i
        rp.close
      end
    end
    puts "Total bytes read: #{total_bytes}"
    sleep(1)
    puts "Restoring custom handler"
    trap(sig, &handler.call(sig))
  end
end

["INT", "TERM"].each do |sig|
  trap(sig, &handler.call(sig))
end

loop do

  client = server.accept
  cur_read, cur_write = IO.pipe
  r_pipes << cur_read
  fork do
    cur_read.close
    puts "\n"
    puts "New Client Connected"
    read_buffer = ""
    client.puts("220 Hello World")
    loop do
      begin
        inp = client.read
        break if inp.nil? || inp.empty?
        read_buffer += inp
      rescue Exception => ex
        puts "Reading Error: #{ex}"
        break
      end
    end
    #client.shutdown
    cur_write.write(read_buffer.size.to_s)
    puts "Read a total of #{read_buffer.size} bytes"
    puts "Last 10 chars read: #{read_buffer[-10..-1]}"
    puts "\n"
    client.close
    cur_write.close
  end
  cur_write.close
end

