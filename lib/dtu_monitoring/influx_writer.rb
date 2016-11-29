module DtuMonitoring
  class InfluxWriter

    def self.write(measurement, tags, values, tstamp)
      api = ENV['INFLUX_API']
      return if api.nil? # ENV VAR INFLUX_API not set!
      request_body = self.body(measurement, tags, values, tstamp)
      self.post(api, request_body)
    end

    def self.post(url, body)
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      post = Net::HTTP::Post.new(uri)
      post.body = body
      response = http.request(post)
      fail "Influx Write failed - #{response.code} - #{response.message} #{body}" unless response.code == '204'
      true
    end

    def self.body(measurement, tags, values, tstamp)
      tag_str = self.transform(tags)
      val_str = self.transform(values)
      timestamp = tstamp.to_s.ljust(19, '0')
      "#{measurement},#{tag_str} #{val_str} #{timestamp}"
    end

    def self.transform(h)
      pieces = h.collect do |k,v|
        val = v.is_a?(String) ? "\"#{v}\"" : v # strings need to be surrounded by ""
        "#{k}=#{val}"
      end
      pieces.join(',')
    end
  end
end
