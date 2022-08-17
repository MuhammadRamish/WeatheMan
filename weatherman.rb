require 'colorize'
require 'date'

$all_months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

class Month

  attr_reader :max, :max_day, :min, :min_day, :humid_day, :humidity, :highest_avg, :lowest_avg, :humidity_avg

  def initialize(data)
    @data = data
    @max = 0
    @max_day = 0
    @min = 100
    @min_day = 0
    @humidity = 0
    @humid_day = 0
    @highest_avg = 0
    @lowest_avg = 0
    @humidity_avg = 0
  end

  def evaluate
    sum = 0
    num = 0

    for arr in @data do
      arr = arr.split(',')

      if arr[10].class == NilClass
        break
      end

      if arr[1].to_i > @max
        @max = arr[1].to_i
        @max_day = arr[0]
      end

      if arr[3].to_i < @min
        @min = arr[3].to_i
        @min_day = arr[0]
      end

      if arr[7].to_i > @humidity
        @humidity = arr[7].to_i
        @humid_day = arr[0]
      end

      arr[2].to_i < @highest_avg ? 1: @highest_avg = arr[2].to_i
      arr[2].to_i > @lowest_avg ? 1: @lowest_avg = arr[2].to_i
      sum = sum + arr[8].to_i
      num = num + 1
    end
    @humidity_avg = sum/num
  end
end



def red_bar(num)
  num.times do
    print "*".red
  end
end

def blue_bar(num)
  num.times do
    print "*".blue
  end
end



def weather_man(arg)


  full_names = ["January", "February", "March", "April", "May", "June", "July", +
     "August", "September", "October", "November", "December"]


  month_data = {}
  high_temp = {}
  low_temp = {}
  hum_hash = {}

  flag = ARGV[0]
  path = ARGV[2]
  month = ''

  case flag
    when '-e'
      year = ARGV[1]

      for e in $all_months do
        begin
          data = File.read("#{path}#{path[0,path.length-1]}_#{year}_#{e}.txt").split
          inst = Month.new(data[41, data.length])
          inst.evaluate

          high_temp[inst.max] = inst.max_day
          low_temp[inst.min] = inst.min_day
          hum_hash[inst.humidity] = inst.humid_day

          month_data[e] = [inst.highest_avg, inst.lowest_avg, inst.humidity_avg]
        rescue
          1
        end
      end

      day = high_temp[high_temp.keys.max].split('-')
      puts "Highest: #{high_temp.keys.max}C on #{full_names[day[1].to_i-1]} #{day[-1]}"
      day = low_temp[low_temp.keys.min].split('-')
      puts "Lowest: #{low_temp.keys.min}C on #{full_names[day[1].to_i-1]} #{day[-1]}"
      day = hum_hash[hum_hash.keys.max].split('-')
      puts "Humid: #{hum_hash.keys.max}C on #{full_names[day[1].to_i-1]} #{day[-1]}"

    when '-a'
      date = ARGV[1].split('/')
      year = date[0]
      month = $all_months[date[1].to_i - 1]

      begin
        data = File.read("#{path}#{path[0,path.length-1]}_#{year}_#{month}.txt").split
        inst = Month.new(data[41, data.length])
        inst.evaluate

      rescue
        puts "Data for #{month} not present in #{year}"
      end

      puts "Highest Average: #{inst.highest_avg}C"
      puts "Lowest Average: #{inst.lowest_avg}C"
      puts "Average Humidity: #{inst.humidity_avg}%"

    when '-c'
      date = ARGV[1].split('/')
      year = date[0]
      month = $all_months[date[1].to_i - 1]
      puts "#{full_names[date[1].to_i - 1]} #{year}"
      begin
        count = 1
        data = File.read("#{path}#{path[0,path.length-1]}_#{year}_#{month}.txt").split
        for i in data[41, data.length]
          i = i.split(',')
          if i[1].class == NilClass
            break
          end

          print count
          red_bar(i[1].to_i)
          print "#{i[1]}C"
          puts ""
          print count
          blue_bar(i[3].to_i)
          print "#{i[3]}C"
          puts ""
          count += 1
        end
      rescue
        puts "Data for #{month} not present in #{year}"
      end

    when '-b'
      date = ARGV[1].split('/')
      year = date[0]
      month = $all_months[date[1].to_i - 1]
      puts "#{full_names[date[1].to_i - 1]} #{year}"
      begin
        count = 1
        data = File.read("#{path}#{path[0,path.length-1]}_#{year}_#{month}.txt").split
        for i in data[41, data.length]
          i = i.split(',')
          if i[1].class == NilClass
            break
          end

          print count
          blue_bar(i[3].to_i)
          red_bar(i[1].to_i)
          print "#{i[3]}C-#{i[1]}C"
          puts ""

          count += 1
        end
      rescue
        puts "Data for #{month} not present in #{year}"
      end

    end
end


weather_man(ARGV)
