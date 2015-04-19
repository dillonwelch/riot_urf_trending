#README

[![Circle CI](https://circleci.com/gh/oniofchaos/riot_urf_trending.png?circle-token=9aff1d88b8467554cc766a99765d365b31caf8b8)](https://circleci.com/gh/oniofchaos/riot_urf_trending)

To see the live version of the app, visit my website at [urfstatistics.net](http://www.urfstatistics.net/), hosted on Heroku and with a domain from GoDaddy.

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

You can run a clock process that will poll for URF matches by running `clockwork lib/clock.rb` (not recommended unless you update the timestamps it looks at), 
or you can run `rake backfill_urf_matches` to get all URF match data directly.

Note that this will get ALL URF matches; if you only want a subset you can edit the start/end times [here](https://github.com/oniofchaos/riot_urf_trending/blob/master/lib/tasks/riot_api_tasks.rake#L71) in the rake task. Use standard Ruby timestamps.

Once you've collected all the data, run `rake backfill_calculate_stats` to populate the stats tables 
used to calculate the numbers on site.

All rake tasks are located in [lib/tasks/riot_api_tasks.rake](https://github.com/oniofchaos/riot_urf_trending/blob/master/lib/tasks/riot_api_tasks.rake).

#Participant Info
* Bumblingbear, NA Server, California, USA
* Harley, NA Server, California, USA

#Specs

You can find my specs in `specs/`. You can run them all by typing `rspec` in the console. There are specs for models, views, controllers, helpers, and even some feature specs. 

#Legal

riot_urf_trending/urfstatistics.net isn’t endorsed by Riot Games and doesn’t reflect the views or opinions of
Riot Games or anyone officially involved in producing or managing League of
Legends. League of Legends and Riot Games are trademarks or registered
trademarks of Riot Games, Inc. League of Legends © Riot Games, Inc.
