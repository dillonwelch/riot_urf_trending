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
  every(5.minutes, 'get urf matches') { execute_rake('get_urf_matches') }
end
