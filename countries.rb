require "graphql/client"
require "graphql/client/http"

# Country API example wrapper
# Adapted from the graphql-client example
module COUNTRY
  URL = "https://countries.trevorblades.com/"

  # Configure GraphQL endpoint using the basic HTTP network adapter.
  HTTP = GraphQL::Client::HTTP.new(URL) do
    def headers(context)
      # Optionally set any HTTP headers
      { "User-Agent": "Ruby" }
    end
  end

  # Fetch latest schema on init, this will make a network request
  Schema = GraphQL::Client.load_schema(HTTP)

  # However, it's smart to dump this to a JSON file and load from disk
  #
  # Run it from a script or rake task
  #   GraphQL::Client.dump_schema(SWAPI::HTTP, "path/to/schema.json")
  #
  # Schema = GraphQL::Client.load_schema("path/to/schema.json")

  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
end

CountryQuery = COUNTRY::Client.parse <<-'GRAPHQL'
  query {
    countries {
      code name
    }
  }
GRAPHQL

result = COUNTRY::Client.query(CountryQuery)

p result.to_h.count
p result.inspect
