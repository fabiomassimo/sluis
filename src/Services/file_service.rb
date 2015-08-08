# Helpers
require_relative '../../helpers/settings'

module FileService
  # Retrieve a list (enumarator) of all projects stored in the filesystem
  def self.retrieve_all_projects(team)
  	return nil, 404, 'INVALID_PROJECT_INPUT', "Team '#{team}' not found" unless File.exist? "#{Settings::Helpers.projects_root}#{team}" 

    list = Dir.glob("#{Settings::Helpers.projects_root}/#{team}/*").map { |file|
      file.split('/').last.strip
    }

    return list , nil, nil, nil
  end

end