require 'sinatra'
require 'slack-notifier'
require 'json'

class App < Sinatra::Base
  configure do
    enable :cross_origin
  end

  before do
    response.headers['Access-Control-Allow-Origin'] = ENV['CORS_ALLOW_ORIGIN']
  end

  get '/health' do
    "ok"
  end

  post '/send-notification' do
    halt 500 if ENV["PROJECT_NAME"].strip.empty?
    halt 500 if ENV["PROJECT_ENV"].strip.empty?
    halt 500 if ENV["BACKEND_SECRET_KEY"].strip.empty?

    secret = request.env["HTTP_X_SECRET_HEADER"]
    halt 403 unless secret == ENV["BACKEND_SECRET_KEY"]

    payload = JSON.parse(request.body.read)
    message = Rack::Utils.escape_html(payload['message'])

    result_text = "Message from #{ENV['PROJECT_NAME']}-#{ENV['PROJECT_ENV']} - #{message}"

    # Slack integration
    Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL']).tap do |notifier|
      notifier.ping result_text
    end unless ENV['SLACK_WEBHOOK_URL'].empty?

    result_text
  end

  options "*" do
    response.headers["Allow"] = "GET, POST, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type, Accept, X-Secret-Header"
    response.headers["Access-Control-Allow-Origin"] = ENV['CORS_ALLOW_ORIGIN']
    200
  end
end
