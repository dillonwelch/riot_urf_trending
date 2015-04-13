require './config/boot'
require './config/environment'
require 'clockwork'

def execute_rake(task, file='riot_api_tasks.rake')
  require 'rake'
  rake = Rake::Application.new
  Rake.application = rake
  Rake::Task.define_task(:environment)
  load "#{Rails.root}/lib/tasks/#{file}"
  rake[task].reenable
  rake[task].invoke
end

module Clockwork
  every(5.minutes, 'get urf matches', thread: true) { execute_rake('get_urf_matches') }
  #every(1.day, 'backfill_urf_matches', thread: true) { execute_rake('backfill_urf_matches') }
  every(1.hour, 'calculate_stats', thread: true, at: '**:01') { execute_rake('calculate_stats') }
end
