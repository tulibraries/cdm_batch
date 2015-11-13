require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'cdm_batch'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :upload_etd, [:etd_metadata_path] do |t, args|
  form_config_path = File.join('config', "etd_form.yml")
  creds = CdmBatch.get_cdm_credentials
  filler = CdmBatch::FormFiller.new args.etd_metadata_path, form_config_path, creds
  filler.upload_batch

end


