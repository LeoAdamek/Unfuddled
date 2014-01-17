module Unfuddled
  module REST
    module API
      module Projects
        
        # Gets the Projcets List
        #
        # @return [Array[Unfuddled::Project]]
        #
        # @param options  [Hash] Query options for the API call
        # @option options :id    Query by ID
        # @option options :name  Query by name
        # @option options :title Query by title
        def projects(options = {})
          response = send(:get , '/api/v1/projects.json')

          if response[:body].is_a?(Hash) then
            projects = [Unfuddled::Project.from_response(response)]
          else
            if response[:body].is_a?(Array) then
              projects = []
              response[:body].each do |project|
                projects << Unfuddled::Project.new(project)
              end
            end
          end

          projects
        end

        # Gets a single project
        #
        # @return Unfuddled::Project
        # @param options [Hash] Query options
        # @option options :name [String, Symbol] Project `short_name'
        def project(options = {})
          raise Unfuddled::Error.new("No options given for project, cannot query") if options == {}
          
          raise Unfuddled::Error.new("Can only supply one of :id and :name") if options.keys.include?([:id , :name])
          
          url = "/api/v1/projects/#{options[:id]}.json" if options.keys.include?(:id)
          url = "/api/v1/projects/by_short_name/#{options[:name]}.json" if options.keys.include?(:name)

          Unfuddled::Project.from_response( send(:get , url) )
        end

        
      end
    end
  end
end
