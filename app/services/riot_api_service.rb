class RiotApiService
  attr_reader :client

  def initialize(region='na')
    @client = Lol::Client.new ENV['RIOT_API_KEY'], { region: region }
  end
end
