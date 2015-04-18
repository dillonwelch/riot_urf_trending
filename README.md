#README

<img src="https://circleci.com/gh/oniofchaos/riot_urf_trending.png?circle-token=9aff1d88b8467554cc766a99765d365b31caf8b8">

To see the live version of the app, visit my website at [urfstatistics.net](http://www.urfstatistics.net/).

# Setup
You will need to have the following installed before running the app locally:
* Ruby 2.2.0 (recommended to use [RVM](https://rvm.io/) for setup)
* Rails 4.2.0 (can use RVM for this too)
* Postgres 9.3 ([Official Website](http://www.postgresql.org/))
* Bundler gem (`gem install bundler`)

All other dependencies are listed in the [Gemfile](https://github.com/oniofchaos/riot_urf_trending/blob/master/Gemfile) and will be installed by running `bundle`. 

To setup the database, run `rake db:create db:migrate`

Copy `example.env` over to `.env` and replace `RIOT_API_KEY` with your personal token.

To populate champion data, run `rake populate_static_champion_data`

You can run a clock process that will poll for URF matches by running `clockwork lib/clock.rb`, 
or you can run `rake backfill_urf_matches` to get all URF match data directly.

Once you've collected all the data, run `rake backfill_calculate_stats` to populate the stats tables 
used to calculate the numbers on site.

#Participant Info
* Bumblingbear, NA Server, California, USA
* Harley, NA Server, California, USA

#Legal

riot_urf_trending/urfstatistics.net isn’t endorsed by Riot Games and doesn’t reflect the views or opinions of
Riot Games or anyone officially involved in producing or managing League of
Legends. League of Legends and Riot Games are trademarks or registered
trademarks of Riot Games, Inc. League of Legends © Riot Games, Inc.
