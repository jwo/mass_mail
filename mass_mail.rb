require 'bundler'
Bundler.require

require 'csv'
require 'erb'
Dotenv.load

gmail_username = ENV.fetch("GMAIL_USERNAME")
gmail_password = ENV.fetch("GMAIL_PASSWORD")
erb = ERB.new(File.read("mass_mail.text.erb"))

CSV.foreach('contacts.csv', headers: true) do |row|

  data = row.to_hash
  email = data.fetch('email')
  first_name = data.fetch('first_name')
  b = binding

  Pony.mail({
    :to => email,
    :subject => "Thanks for being awesome",
    :body => erb.result(b),
    :via => :smtp,
    :via_options => {
      :address              => 'smtp.gmail.com',
      :port                 => '587',
      :enable_starttls_auto => true,
      :user_name            => gmail_username,
      :password             => gmail_password,
      :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
      :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
    }
  })
  

end



