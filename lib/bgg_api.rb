require_relative 'bgg_api/normalize'

class BggApi
  include HTTParty

  base_uri 'www.boardgamegeek.com'

  def self.search(query, options = {})
    query = { query: query }.merge(options)
    result = get('/xmlapi2/search', query: query).parsed_response
    BggApi::Normalize.search(result)
  end

  def self.thing(id, options = {})
    id = id.is_a?(Array) ? id.join(',') : id
    query = { id: id }.merge(options)
    result = get('/xmlapi2/thing', query: query).parsed_response
    BggApi::Normalize.thing(result)
  end
end
