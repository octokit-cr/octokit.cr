require "spec"
require "webmock"
require "hi8"
require "../src/octokit"

# WebMock.disable_net_connect(allow: "coveralls.io")

# Configure HI8
HI8.configure do |config|
  config.cabinet_shelf = File.expand_path("./fixtures/cassettes")

  config.on_playback do |recorder, request, response|
    uri = URI.parse(request.uri)
    query = uri.query.to_s
    uri.query = ""
    req_headers = recorder.headers_from_hash(request.headers)
    req_query = HTTP::Params.try(&.parse(query)).to_h
    res_status = response.status.to_i
    res_headers = recorder.headers_from_hash(response.headers)

    # Stub WebMock requests with HI8
    ::WebMock.stub(request.method, uri.to_s)
      .with(query: req_query)
      .to_return(status: res_status, body: response.body, headers: res_headers)
  end
end
