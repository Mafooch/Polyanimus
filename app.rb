require 'json'
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

def add_to_db(title, thinker, thought)
  sql_insert = "INSERT INTO quotes (title, thinker, thought) VALUES ($1, $2, $3)"
  db_connection { |conn| conn.exec_params(sql_insert, [title, thinker, thought]) }
end

def check_and_reset_flags
  sql_check_flags = "SELECT COUNT (id) FROM quotes WHERE lookedAt = 'false';"
  sql_reset_flags = "UPDATE quotes SET lookedAt = 'false' "

  false_flag_count = db_connection { |conn| conn.exec(sql_check_flags) }[0]["count"].to_i

  if false_flag_count == 0
    db_connection { |conn| conn.exec(sql_reset_flags)}
  end
end

def select_rand_and_update
  check_and_reset_flags
  sql_select = "SELECT id FROM quotes WHERE lookedAt = 'false' ORDER BY random() LIMIT 1"
  sql_update = "UPDATE quotes SET lookedAt = 'true'
                WHERE id = (#{sql_select})
                RETURNING *;"
  db_connection { |conn| conn.exec(sql_update).to_a }[0]
end

########
#ROUTES#
########

get '/' do
  redirect '/polyanimus'
end

get '/polyanimus' do
  # check_and_reset_flags
  # random_quote = select_rand_and_update
  # binding.pry
  erb :index
end

get '/polyanimus/contribute' do
  erb :post
end

post '/polyanimus' do
  new_title = params["title_box"]
  new_thinker = params["name_box"]
  new_thought = params["quote_box"]

  add_to_db(new_title, new_thinker, new_thought)

  redirect '/polyanimus'
end

get "/thought.json" do
  content_type :json
  select_rand_and_update.to_json
end
