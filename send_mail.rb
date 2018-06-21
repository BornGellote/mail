require 'pony'          #gem install pony
require 'io/console'    #hide get in console

def valid(email)
    i = 0
    while i != 1 do
        if email.match?('[a-z0-9]+[_a-z0-9\.-]*[a-z0-9]+@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})')
            puts 'Great Email correct!'
            i += 1
        else
            puts 'Email not correct'
            sleep 1
            puts "Try it again"
            email = STDIN.gets.chomp
        end
    end
    # if email.match?('[a-z0-9]+[_a-z0-9\.-]*[a-z0-9]+@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})')
    #     puts 'Great Email correct!'
    # else
    #     puts 'Email not correct'
    #     sleep 1
    #     puts "Try it again"
    # end
end
puts "Enter your email"
my_mail = STDIN.gets.chomp
valid(my_mail)

sleep 1

puts "Enter password from #{my_mail} for send email"
pass = STDIN.noecho(&:gets).chomp
# pass = STDIN.gets.chomp

sleep 1

puts "To whom to send a letter?"
send_to = STDIN.gets.chomp
valid(send_to)

sleep 1
puts "Write the text of the letter"
body = STDIN.gets.chomp

def send_mail(body, send_to, my_mail, pass)
    Pony.mail({
                  :subject  => "hello from the ruby",
                  :body     => body,
                  :to       => send_to,
                  :from     => my_mail,

                  :via => :smtp,
                  :via_options => {
                      :address              => 'smtp.gmail.com',
                      :port                 => '587',
                      :enable_starttls_auto => true,
                      :user_name            => my_mail,
                      :password             => pass,
                      :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
                      :domain               => "localhost.localdomain" #the HELO domain provided by the client to the server
                  }
              })

    sleep 1
    puts "Email successfully sent"
end

begin
    send_mail(body, send_to, my_mail, pass)

rescue SocketError
  sleep 1
  puts "I can't connect to server :)"
rescue Net::SMTPSyntaxError => error
  sleep 1
  puts "You wrote not correct params email: " + error.message
rescue Net::SMTPAuthenticationError => error #если произошла ошибка
  sleep 1
  puts "Something went wrong. Email could not be sent!!!"
  sleep 1
  puts "Not wrong password from your - #{my_mail} email. Try again!"
  pass = STDIN.noecho(&:gets).chomp
  send_mail(body, send_to, my_mail, pass)
# ensure #код выполниться в любом случае
#     sleep 1
#     puts "Yeahooo!!!"
end

