server 'TODO', user: 'TODO', roles: %w{web app}, port: 2233

set :rack_env, "staging"

set :deploy_to, '~/www/TODO/htdocs'

set :branch, "staging"
