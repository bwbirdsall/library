require './lib/book'
require './lib/author'
require './lib/patron'
require './lib/checkout'

def main_menu
  system('clear')
  header
  puts "Press enter for the patron menu, or enter the librarian password for system access."
  mm_choice = gets.chomp
  if mm_choice == 'library123'
    librarian_menu
  else
    patron_menu
  end
end

def patron_menu
  puts "What would you like to do?"
  puts "(C) Check a b"
end

def librarian_menu

end

def header
  puts "\n\n\t*****************************************************\n\t* BEN * and * DAN'S * THOROUGHLY * USEFUL * LIBRARY *\n\t*****************************************************\n\n"
end

def idiot_menu
  system('clear')
  puts "One would think a simple menu wouldn't be too much to handle, but here you are."
end

main_menu
