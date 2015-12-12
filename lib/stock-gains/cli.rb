module StockGains
end 
class StockGains::CLI

  def call
    StockGains::Portfolio.new.call
    start
  end

  def start
    input = ""
    unless input == "exit"
      begin 
        puts "\nTo view more stock information, enter the number(s) associated with"
        puts "the stock or enter 'all' to view all of the stocks in your portfolio."

        puts "(Separate digits with a space)\n\n"
        input = gets.strip.scan(/\w+/)
      end until valid_input?(input)
      input.first == "all" ? find_all(input) : find(input) 
    end
  end

  def valid_input?(input)
    "all".include?(input.first) || input.map(&:to_i).all?{ |n| n.between?(1, StockGains::Stock.all.count)}
  end

  def find_all(stocks)
    print_stock_info(StockGains::Stock.all)
  end

  def find(stock)
    print_stock_info(stock.map(&:to_i).collect{ |s| StockGains::Stock.all[s-1] })
  end

  def print_stock_info(stocks)
    puts "\n"
    stocks.each do |stock|
      puts "#{stock.name}".center(66)
      puts " " + "-" * 66
      puts " Asking Price:     $#{stock.cur_price}          Day's Range:   $#{stock.d_range}"
      puts " Previous Close:   $#{stock.prev_close}          52 Week Range: $#{stock.y_range}"
      puts " Open:             $#{stock.open}          1 Year Target: $#{stock.year_trgt}"
      puts " Day's +/-:        $#{stock.days_value}#{extra_spaces(stock.days_value)}         Shares: #{stock.shares}"
      puts "\n\n"
    end
  end

  def extra_spaces(value)
    value.to_s.each_char.count < 4 ? spaces = " " * (6 - value.to_s.each_char.count) : spaces = " "
  end
end