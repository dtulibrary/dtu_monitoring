require 'spec_helper'

describe DtuMonitoring::BlacklightResponse do
  let(:response) { "{\"responseHeader\":{\"status\":0,\"QTime\":206,\"params\":{\"fl\":\"*\",\"echoParams\":\"all\",\"q\":\"{!raw f=cluster_id_ss v=$id}\",\"rows\":\"1\",\"id\":\"46381972\",\"qt\":\"/toshokan_document\",\"wt\":\"ruby\",\"fq\":\"access_ss:dtu\"}},\"response\":{\"numFound\":1,\"start\":0,\"maxScore\":17.672216,\"docs\":[{\"alert_timestamp_dt\":\"2012-11-07T13:22:44.335Z\",\"toc_key_s\":\"15232409|000099|000036|000003\",\"title_ts\":[\"Partnership Sourcing: An Organization Change Management Perspective.\"],\"source_ss\":[\"ebsco\"],\"update_timestamp_dt\":\"2014-03-07T13:08:27.117Z\",\"journal_issue_ssf\":[\"3\"],\"abstract_ts\":[\"Examines organization change implications of partnership sourcing. Dimensions of collaborative relations; Role of senior managers as facilitator of organizational changes; Importance of delivery and logistics management; Function of purchasing professional in supporting the core competency strategy used by an organization.\"],\"issn_ss\":[\"15232409\",\"1745493x\"],\"fulltext_availability_ss\":[\"UNDETERMINED\"],\"source_id_ss\":[\"ebsco:3502594\"],\"journal_vol_ssf\":[\"36\"],\"source_type_ss\":[\"aggregator\"],\"affiliation_associations_json\":\"{\\\"editor\\\":[],\\\"supervisor\\\":[],\\\"author\\\":[null,null]}\",\"access_ss\":[\"aub\",\"dtu\"],\"journal_title_ts\":[\"Journal of Supply Chain Management\"],\"journal_title_facet\":[\"Journal of Supply Chain Management\"],\"member_id_ss\":[\"193645459\"],\"format\":\"article\",\"pub_date_tis\":[2000],\"keywords_ts\":[\"PARTNERSHIP (Business)\"],\"keywords_facet\":[\"PARTNERSHIP (Business)\"],\"journal_page_ssf\":[\"12\"],\"cluster_id_ss\":[\"46381972\"],\"author_ts\":[\"Mclvor, Ronan\",\"McHugh, Marie\"],\"author_facet\":[\"Mclvor, Ronan\",\"McHugh, Marie\"],\"source_ext_ss\":[\"ds1:ebsco\"],\"id\":\"1213100295\",\"_version_\":1529487044876697600,\"timestamp\":\"2016-03-22T07:41:51.964Z\"}]}}"}
  let(:parsed) { described_class.parse(response) }
  let(:test_api) { 'http://influxapi.test.dtu.dk:8089/write?db=dtu' }
  describe 'monitor' do
    it 'should make a http request to influx' do
      ENV['INFLUX_API'] = test_api
      stub = stub_request(:post, test_api).and_return(status: 204)
      described_class.monitor('test_app', response, Time.now.to_i)
      expect(stub).to have_been_requested
    end
  end

  describe 'parse_response' do
    it 'parses a solr response correctly' do
      expect(parsed[:value]).to eql 206
      expect(parsed[:status]).to eql 0
      expect(parsed[:q]).to eql '{!raw f=cluster_id_ss v=$id}'
      expect(parsed[:num_docs]).to eql 1
    end
  end
end
