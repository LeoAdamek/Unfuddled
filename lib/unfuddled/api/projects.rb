module Unfuddled
  module REST
    module API
      module Projects
        
        # Gets the Projcets List
        #
        # @return [Array[Unfuddled::Project]]
        def projects
          response = send(:get , '/api/v1/projects.json')

          if response[:body].is_a?(Hash) then
            projects = [Unfuddled::Project.from_response(response)]
          else
            if response[:body].is_a?(Array) then
              projects = []
              response[:body].each do |project|
                projects << Unfuddled::Project.new(project)
              end
            else
              raise Unfuddle::UnexpectedResponseError.from_response(response)
            end
          end

          projects
        end
        
      end
    end
  end
end
