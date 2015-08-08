require 'sinatra/base'
require 'sinatra/cross_origin'
require 'logger'
require 'rack/parser'

# Helpers
require_relative 'helpers/settings'

# Routes
require_relative 'routes/projects'

# Dependencies
require_relative 'src/requests'

# noinspection RubyResolve
class App < Sinatra::Base
  register Sinatra::CrossOrigin
  register Sinatra::Projects

  helpers Settings::Helpers

  #Logging endpoints
  Logger.class_eval { alias :write :'<<' }
  access_log = ::File.join(settings.root,'log','access.log')
  access_logger = ::Logger.new(access_log)
  errors_logger = File.new("#{settings.root}/log/errors.log",'a+')
  errors_logger.sync = true

  # JSON Parsing
  use Rack::Parser, :parsers => { 'application/json' => proc { |data| JSON.parse data } }

  #Setup redis for resque
  Resque.redis = Redis.new
  Resque.logger.level = Logger::DEBUG

  set :raise_sinatra_param_exceptions, true
  set :show_exceptions, false
  set :raise_errors, true

  configure do

    enable :cross_origin
    set :allow_origin, :any
    set :allow_methods, [:get, :put, :post, :delete, :options]

    use ::Rack::CommonLogger, access_logger
  end

  before do
    env["rack.logger"] = access_logger
    env["rack.errors"] = errors_logger
  end

  helpers do
    def return_error_code(http_code,error_code,message, additional_information=nil)
      content_type :json
      status http_code
      env["rack.errors"].puts( "#{error_code} : #{message} [#{additional_information}]")
      return {:message=>message,:error_code=>error_code,:success=>false}.to_json
    end

    def return_error(http_code,message)
      content_type :json
      status http_code
      logger.error( "#{http_code} : #{message}")
      return {:message=>message,:error_code=>nil,:success=>false}.to_json
    end

    def valid_request?(request_module, request, params)

      valid, message = request_module.grant_access?(request)
      return 401,"UNAUTHORIZED",message unless valid

      valid, message = request_module.valid_parameters?(params)
      return 400,"INVALID_PARAMETERS",message unless valid

      return nil, nil, nil
    end

  end

  options "/*" do
    200
  end
end