def configuration_for(config)
  configuration_file = File.join(File.expand_path(__dir__), '..', 'config', config + '.yml')
  YAML.safe_load(File.read(configuration_file))
end

ENV['DB'] ||= 'development'

###
# DB Initialization
###

db_configuration = configuration_for('database')[ENV['DB']]

ActiveRecord::Base.establish_connection(db_configuration)

###
# Strigil Initialization
###

strigil_configuration = configuration_for('strigil')[ENV['DB']]

Strigil.configure do |config|
  config.user_agent = strigil_configuration['user_agent']
end
