require 'sidekiq'
require_relative './database'

class Worker
  include Sidekiq::Worker

  def perform(csv_file)
    Database.process_csv_file(csv_file)
  end
end