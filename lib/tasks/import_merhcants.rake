# frozen_string_literal: true

require 'csv'

task :import_merchants, [:csv] => :environment do |_, args|
  count = 0

  CSV.foreach(args[:csv], headers: true).each do |row|
    Merchant.find_or_create_by!(email: row[0]) do |m|
      m.name = row[1]
      m.password = '12345678'
      count += 1
    end
  end

  puts "Imported new #{count} merchants"
end
