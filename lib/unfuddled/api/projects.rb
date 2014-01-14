module Unfuddled
  module REST
    module API
      module Projects
        
        # Gets the Projcets List
        #
        # @return [Unfuddled::Project
        def projects
          response = send(:get , '/api/v1/projects.json')

          if response[:body].is_a?(Hash) then
            projects = [Unfuddled::Project.from_response(response)]
          else
            projects = []
            response.body.each do |project|
                projects << Unfuddled::Project.new(project)
            end
          end

          projects
        end
        
      end
    end
  end
end
