module Requests
  module Projects

    class Deploy < Requests::Base
      def self.protected
        false
      end

      def self.valid_parameters?(params)
        return false if params['lane'].nil?
        true
      end
    end

    class Retrieve < Requests::Base
      def self.protected
        false
      end
    end

    class Clone < Requests::Base
      def self.protected
        false
      end

      def self.schema
        {
            "description"=> "schema for creating a new project",
            "type"=> "object",
            "additionalProperties" => false,
            "required"=>[ "git_path"],
            "properties"=> {
                "git_path" => {
                    "type"=>"string"
                }
            }
        }
      end
    end

    class Delete < Requests::Base
      def self.protected
        false
      end

      def self.valid_parameters?(params)
        #TODO
      end
    end

  end
end