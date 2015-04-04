class ApiChallengeService < RiotApiService
  attr_reader :begin_date

  # Time.parse('01 Apr 2015 12:00').to_i
  def initialize(begin_date: 1427871600, region: 'na')
    super(region)
    @begin_date = begin_date
    @request = Lol::ApiChallengeRequest.new(client.api_key,
                                            client.region,
                                            client.cache_store)
  end

  def matches
    @matches ||= request.get(begin_date)
  end

  private

  attr_reader :request
end
