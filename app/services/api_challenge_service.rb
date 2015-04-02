class ApiChallengeService < RiotApiService
  attr_reader :beginDate

  # Time.parse('01 Apr 2015 12:00').to_i
  def initialize(beginDate: 1427871600, region: 'na')
    super(region)
    @beginDate = beginDate
    @request = Lol::ApiChallengeRequest.new(client.api_key,
                                            client.region,
                                            client.cache_store)
  end

  def matches
    @matches ||= request.get(beginDate)
  end

  private

  attr_reader :request
end
