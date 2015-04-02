module Lol
  class ApiChallengeRequest < Request
    def self.api_version
      'v4.1'
    end

    def get(date)
      params = { beginDate: date }
      perform_request(api_url('game/ids', params)).parsed_response
    end
  end
end
