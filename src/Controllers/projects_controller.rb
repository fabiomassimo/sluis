# Services
require_relative '../../src/Services/file_service'
require_relative '../../jobs/jobs'

module ProjectsController

  # Retrieve a list of all managed projects
  # The retuned list is alphabetically ordered.
  def self.retrieve_all_projects(team)
    FileService.retrieve_all_projects team
  end

  def self.deploy_project(project_name, team, lane='development', emails=nil)
    # Retrieve available projects
    list, error_code, error_domain, error_message = FileService.retrieve_all_projects(team)
    return false, error_code, error_domain, error_message if error_code

    return false, 404, 'INVALID_INPUT', "No project named #{project_name} found" unless list.include? project_name

    # The project is available:
    # - Enqueue to proper Resque queue
    Resque.enqueue(DriveLane, { project_name: project_name, lane: lane , emails: emails, team: team })

    return true, nil, nil, nil
  end

  def self.clone_project(git_path, team)

    # The project is available:
    # - Enqueue to proper Resque queue
    Resque.enqueue(CloneRepository, { git_path: git_path, team: team })

    return true, nil, nil, nil
  end

end