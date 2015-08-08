require 'resque'
require_relative '../helpers/settings'

module DriveLane
  # By setting the @queue class instance variable, this worker will only look for jobs on the :sleep queue.
  @queue = :deploy_queue

  def self.perform(params)
    Dir.chdir("#{Settings::Helpers.projects_root}#{params['team']}/#{params['project_name']}")

    # Load settings
    config = YAML.load(open("#{Settings::Helpers.projects_root}#{params['team']}/#{params['project_name']}/fastlane/fastlane_config.yaml"))
    general_config = OpenStruct.new(config)
    lane_config = general_config[params['lane']]

    ENV["SLACK_URL"] = general_config['slack_url']

    cmd = "fastlane #{params['lane']} xcode_select:#{general_config['xcode_select']} sdk:#{general_config['sdk']} remote_branch:#{lane_config['remote_branch']} team_id:#{lane_config['team_id']}"

    if params['emails']
      cmd.concat(" emails:#{params['emails']}")
    else
      if lane_config['emails']
        cmd.concat(" emails:#{lane_config['emails']}")
      else
        if lane_config['groups']
          cmd.concat(" groups:#{lane_config['groups']}")
        end
      end
    end

    if lane_config['notifications']
      cmd.concat(" notifications:#{lane_config['notifications']}")
    end

    # Printing execution command

    puts '--------' 
    puts "[#{Time.now}] - #{cmd}"
    puts '--------'


    # Execute
    system(cmd)
  end
end

module CloneRepository
  # By setting the @queue class instance variable, this worker will only look for jobs on the :sleep queue.
  @queue = :deploy_queue

  def self.perform(params)
    Dir.chdir("#{Settings::Helpers.projects_root}#{params['team']}")

    cmd = "git clone #{Settings::Helpers.git_address_prefix}:#{params['git_path']}"

    puts '--------'
    puts "[#{Time.now}] - #{cmd}"
    puts '--------'

    # Execute
    system(cmd)

  end

end