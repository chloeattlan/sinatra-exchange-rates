require "sinatra"
require "sinatra/reloader"
require "dotenv/load"
require "http"

#ENV.fetch("exchange_key")
get("/") do
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("exchange_key")}"

  # Use HTTP.get to retrieve the API data
  @raw_response = HTTP.get(api_url)

  # Get the body of the response as a string
  @raw_string = @raw_response.to_s

  # Convert the string to JSON
  @parsed_data = JSON.parse(@raw_string) #the raw string
  @currencies = @parsed_data['currencies'].keys
  erb :home
end

get("/:first_curr") do
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("exchange_key")}"
  @raw_response = HTTP.get(api_url)
  @raw_string = @raw_response.to_s
  @parsed_data = JSON.parse(@raw_string) #the raw string
  @currencies = @parsed_data['currencies'].keys

  @first_curr = params['first_curr']
  erb :first_layer
end

get("/:first_curr/:second_curr") do
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("exchange_key")}"
  @raw_response = HTTP.get(api_url)
  @raw_string = @raw_response.to_s
  @parsed_data = JSON.parse(@raw_string) #the raw string
  @currencies = @parsed_data['currencies'].keys
  @first_curr = params['first_curr']
  @second_curr = params['second_curr']

  #new stuff
  api_url2 = "https://api.exchangerate.host/convert?access_key=#{ENV.fetch("exchange_key")}&from=#{@first_curr}&to=#{@second_curr}&amount=1"
  @raw_response2 = HTTP.get(api_url2)
  @raw_string2 = @raw_response2.to_s
  @parsed_data2 = JSON.parse(@raw_string2)
  @conversion = @parsed_data2['result']
  
  erb :second_layer
end
