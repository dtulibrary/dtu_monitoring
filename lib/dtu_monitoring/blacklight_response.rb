require 'json'
module DtuMonitoring
  class BlacklightResponse

    MEASUREMENT = 'solr_response_time'

    def self.monitor(app_name, response, timestamp)
      values = self.parse(response)
      tags = self.tags(app_name)
      DtuMonitoring::InfluxWriter.write(MEASUREMENT, tags, values, timestamp)
    end

    def self.write(app_name, parsed_response, timestamp)
      tags = self.tags(app_name)
      DtuMonitoring::InfluxWriter.write(MEASUREMENT, tags, parsed_response, timestamp)
    end

    def self.parse(response)
      data = JSON.parse(response)
      value = data['responseHeader']['QTime']
      status = data['responseHeader']['status']
      query =  data['responseHeader']['params']['q']
      num_docs = data['response']['numFound']
      { value: value, status: status, q: query, num_docs: num_docs }
    end

    def self.tags(app_name)
      { app: app_name }
    end
  end
end