#README

<img src="https://circleci.com/gh/oniofchaos/riot_urf_trending.png?circle-token=9aff1d88b8467554cc766a99765d365b31caf8b8">

Create a .env file in root with your API key:
RIOT_API_KEY="12345"

To set up champion data: rake populate_static_champion_data

To start the process that polls for URF matches: clockwork lib/clock.rb

riot_urf_trending isn’t endorsed by Riot Games and doesn’t reflect the views or opinions of
Riot Games or anyone officially involved in producing or managing League of
Legends. League of Legends and Riot Games are trademarks or registered
trademarks of Riot Games, Inc. League of Legends © Riot Games, Inc.
