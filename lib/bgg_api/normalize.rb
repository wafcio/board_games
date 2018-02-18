class BggApi
  class Normalize
    def self.search(res)
      res['items']['item'] = [res['items']['item']].flatten
      res
    end

    def self.thing(res)
      res['items']['item'] = [res['items']['item']].flatten.map do |item|
        item['name'] = [item['name']].flatten
        item['link'] = [item['link']].flatten
        item['videos']['video'] = [item['videos']['video']].flatten
        item
      end
      res
    end
  end
end
