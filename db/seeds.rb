# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'net/http'
require 'uri'
require 'json'

spinner = Enumerator.new do |e|
  loop do
    e.yield '|'
    e.yield '/'
    e.yield '-'
    e.yield '\\'
  end
end

# Construct the API URI
# URL - https://servicodados.ibge.gov.br/api/v1/localidades/estados/41|42|43/municipios
# 41 - Paraná
# 42 - Santa Catarina
# 43 - Rio Grande do Sul

uri = URI.parse('https://servicodados.ibge.gov.br/api/v1/localidades/estados/41%7C42%7C43/municipios')

# Create an HTTP object
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true

# Construct the HTTP request
request = Net::HTTP::Get.new(uri.request_uri)

# Send the request and handle the response
response = http.request(request)

if response.code == '200'

  # Transform keys in symbols
  result = JSON.parse(response.body, { symbolize_names: true })
  count = 0

  result.each do |value|
    hash = value.dig(:microrregiao, :mesorregiao, :UF)
    state = {
      id: hash[:id],
      name: hash[:nome],
      uf: hash[:sigla]
    }
    city = {
      name: value.dig(:nome),
      state_id: state.dig(:id)
    }

    State.where(state).first_or_create!
    City.where(city).first_or_create!

    printf("\rProgress: %-1s%% %s", ((count * 100) / result.count), spinner.next)
    sleep(0.01)

    count += 1
  end
else
  puts "HTTP Request Failed: #{response.code}"
end

# Close the HTTP connection
http.finish if http.started?
