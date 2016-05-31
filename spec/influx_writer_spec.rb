require 'spec_helper'
require 'webmock/rspec'

describe DtuMonitoring::InfluxWriter do
  let(:tags) { { app: 'test_app'} }
  let(:vals) {{ value: 355, status: 0, q: 'fishheads', num_docs: 32}}
  let(:tstamp) { Time.now.to_i }
  let(:req_body) { described_class.body('test_measurement', tags, vals, tstamp) }
  describe 'body' do
    it 'should create a valid request string' do
      expect(req_body).to eql "test_measurement,app=\"test_app\" value=355,status=0,q=\"fishheads\",num_docs=32 #{tstamp.to_s.ljust(19, '0')}"
    end
  end

  describe 'write' do
    let(:test_api) { 'http://influxapi.test.dtu.dk:8089/write?db=dtu' }
    it 'should make a http request' do
      ENV['INFLUX_API'] = test_api
      stub = stub_request(:post, test_api).with(body: req_body).and_return(status: 204)
      described_class.write('test_measurement', tags, vals, tstamp)
      expect(stub).to have_been_requested
    end
  end
end
