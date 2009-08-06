require 'helper'

class TestPHPHandler < Phuby::TestCase
  FakeServer = Struct.new(:config)

  class FakeRequest
    attr_accessor :request_uri, :query, :path
    def initialize uri
      @request_uri = URI.parse "http://localhost#{uri}"
      @query = @request_uri.query ? Hash[
        *@request_uri.query.split('&').map { |param| param.split('=') }.flatten
      ] : {}
      @path = @request_uri.path
    end
  end

  class FakeResponse < Struct.new(:body)
  end

  def setup
    @server = FakeServer.new(
      :DocumentRoot => HTDOCS_DIR
    )
  end

  def test_get
    req = FakeRequest.new('/index.php?a=b&c=d')
    res = FakeResponse.new('')

    handler = Phuby::PHPHandler.new @server
    handler.do_GET req, res

    assert_match 'Get Params', res.body
  end
end