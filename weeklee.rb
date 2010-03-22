require 'rubygems'
require 'pony'


#
# README:
#
#   - install
#     $ gem install pony
#     $ crontab -e
#       * 23 * * 1   /usr/bin/ruby ~/weeklee/weeklee.rb
#
#   - setup: 
#     - add your gmail account in options
#     - add your mailing list email in options
#
#   - usage:
#     - set header and footer for the mail
#     - add events for the week
#

#
# Options
#

options = {}
options[:gmail_user] = "user@gmail.com"
options[:gmail_pass] = "pass2323"
options[:mailing_list] = "tetalab@lists.tetalab.org"

#
# Message
#

mesg = {}
mesg[:header] = "Bonjour tout le monde,\n\nCette semaine au Tetalab:"
mesg[:footer] = "\n\nBonne semaine :)"

#
# Events
#
mesg[:events] = []

# - Artilect
mesg[:events] << {
  :day          => "Lundi",
  :title        => "Rencontre Artilect",
  :description  => "",
  :location     => "Manufacture des Tabacs - 21 Allée de Brienne 31000 Toulouse",
  :date         => "à partir de 18h",
  :web          => "artilect.fr"
}

# - AG Myrys
mesg[:events] << {
  :day          => "Mardi",
  :title        => "AG Mixart-Myrys",
  :description  => "",
  :location     => "Mixart Myrys - 12 Rue Ferdinand Lassalle",
  :date         => "18h30",
  :web          => "mixart-myrys.org"
}

# - Tetalab
mesg[:events] << {
  :day          => "Mercedi",
  :title        => "Soirée Tetalab",
  :description  => "",
  :location     => "Mixart Myrys - Container HyperMedia",
  :date         => "à partir de 20h",
  :web          => "tetalab.org"
}

# - Toulibre
# checker la news en rss: http://www.agendadulibre.org/rss.php?tag=toulibre
# mesg[:events] << {
#   :day          => "Mercredi",
#   :title        => "Toulibre",
#   :description  => "",
#   :location     => "Centre Culturel Bellegarde - 17 rue Bellegarde",
#   :date         => "de 19h à 23h"
#   :web          => "http://toulibre.org"
# }

# - Hackathon
# complete with condition for first weekend
# http://www.ruby-forum.com/topic/125970
# mesg[:events] << {
#   :day          => "Tout le weekend",
#   :title        => "Hackathon",
#   :description  => "",
#   :location     => "Au container",
#   :date         => "à partir de vendredi et tout le weekend"
#   :web          => "http://hackerspaces.org/wiki/Synchronous_Hackathon"
# }

# - MORE
# mesg[:events] << {
#   :day          => "",
#   :description  => "",
#   :location     => "",
#   :date         => ""
#   :web          => ""
# }

#
# Send Mail
#

def send_weeklee_mail(options, mesg)
  
  ml_body = mesg[:header]
  mesg[:events].each do |event|
    ml_body << "\n\n\t# #{event[:day]}: #{event[:title]}"
    ml_body << "\n\t\t #{event[:description]}" unless event[:description].empty?
    ml_body << "\n\t\t - #{event[:date]}"
    ml_body << "\n\t\t - #{event[:location]}"
    ml_body << "\n\t\t - #{event[:web]}"
  end
  ml_body << mesg[:footer]
  
  Pony.mail(:to => options[:mailing_list], :via => :smtp, 
    :smtp => {
      :host   => 'smtp.gmail.com',
      :port   => '587',
      :tls    => true,
      :user   => options[:gmail_user],
      :password   => options[:gmail_pass],
      :auth   => :login, # :plain, :login, :cram_md5, no auth by default
      :domain => "tetalab.org" # the HELO domain provided by the client to the server
    },
    :subject => "Cette semaine au Tetalab",
    :body => ml_body
  )
end

send_weeklee_mail(options, mesg)