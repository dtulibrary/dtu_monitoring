module DtuMonitoring
  class BlacklightResponse

    MEASUREMENT = 'solr_response_time'

    def self.monitor(app_name, response, timestamp)
      values = self.parse(response)
      tags = self.tags(app_name)
      DtuMonitoring::InfluxWriter.write(MEASUREMENT, tags, values, timestamp)
    end

    def self.parse(response)
      value = response['responseHeader']['QTime']
      status = response['responseHeader']['status']
      query =  response['responseHeader']['params']['q']
      num_docs = response['response']['numFound']
      { value: value, status: status, q: query, num_docs: num_docs }
    end

    def self.tags(app_name)
      { app: app_name }
    end
  end
end