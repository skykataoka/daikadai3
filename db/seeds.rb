CSV.foreach('db/akiya_lists_for_demoday.csv') do |row|
  House.create(address: row[0],
              expenses_status: row[1],#  0 => "賃貸", 1 => "売買", 2 => "両方"
              price: row[2],
              note: row[3],
              release_status: row[4],
              structure: row[5],
              scale: row[6],
              construction: row[7],
              toilet: row[8],
              title: row[9])
  sleep(1)
end
