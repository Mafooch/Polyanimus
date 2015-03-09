require 'csv'
require 'pry'
require 'pg'
require 'sinatra'

def db_connection
  begin
    connection = PG.connect(dbname: "polyanimus")
    yield(connection)
  ensure
    connection.close
  end
end

def add_to_db(thinker, thought)
  sql_insert = "INSERT INTO quotes (thinker, thought) VALUES ($1, $2)"
  db_connection { |conn| conn.exec_params(sql_insert, [thinker, thought]) }
end

# QUOTE_FILE = "quotes.csv"
#
# csv_quotes = []
# CSV.foreach(QUOTE_FILE) do |row|
#   csv_quotes << { thinker: row[0], thought: row[1] }
# end

# csv has already been added to db. no longer need to run
# csv_quotes.each do |quote|
#   add_to_db(quote[:thinker], quote[:thought])
# end

def check_and_reset_flags
  sql_check_flags = "SELECT COUNT (id) FROM quotes WHERE lookedAt = 'false';"
  sql_reset_flags = "UPDATE quotes SET lookedAt = 'false' "

  false_flag_count = db_connection { |conn| conn.exec(sql_check_flags) }[0]["count"].to_i

  if false_flag_count == 0
    db_connection { |conn| conn.exec(sql_reset_flags)}
  end
end

def select_rand_and_update
  sql_select = "SELECT id FROM quotes WHERE lookedAt = 'false' ORDER BY random() LIMIT 1"
  sql_update = "UPDATE quotes SET lookedAt = 'true'
                WHERE id = (#{sql_select})
                RETURNING *;"
  db_connection { |conn| conn.exec(sql_update).to_a }
end

########
#ROUTES#
########

get '/' do
  redirect '/polyanimus'
end

get '/polyanimus' do
  check_and_reset_flags
  random_quote = select_rand_and_update
  erb :index, locals: { random_quote: random_quote }
end

post '/polyanimus' do

  new_thinker = params["name_box"]
  new_thought = params["quote_box"]
  add_to_db(new_thinker, new_thought)

  # binding.pry

  redirect '/polyanimus'
end
