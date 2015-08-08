# Controller
require_relative '../src/Controllers/projects_controller'

module Sinatra
  module Projects
    module Helpers

    end

    def self.registered(app)

      app.helpers Projects::Helpers

      app.before do
        content_type :json
      end

      app.get '/projects/:team/?' do |team|
        error_code, error_domain, error_message = valid_request?(Requests::Projects::Retrieve, request, request.params)
        return return_error_code(error_code, error_domain, error_message) if error_code

        success, error_code, error_domain, error_message = ProjectsController.retrieve_all_projects(team)

        return return_error_code(error_code, error_domain, error_message) if error_code
        return success.to_json
      end

      app.put '/projects/:team/:project_name/?' do |team, project_name|
        error_code, error_domain, error_message = valid_request?(Requests::Projects::Deploy, request, request.params)
        return return_error_code(error_code, error_domain, error_message) if error_code

        success, error_code, error_domain, error_message = ProjectsController.deploy_project(project_name, team, params[:lane], params[:emails])

        return return_error_code(error_code,error_domain,error_message) if error_code

        status 204
      end

      app.post '/projects/:team/?' do |team|
        error_code, error_domain, error_message = valid_request?(Requests::Projects::Clone, request, request.params)
        return return_error_code(error_code, error_domain, error_message) if error_code

        success, error_code, error_domain, error_message = ProjectsController.clone_project(params[:git_path], team)

        return return_error_code(error_code,error_domain,error_message) if error_code

        status 201
      end

    end
  end
end