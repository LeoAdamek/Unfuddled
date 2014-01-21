module Unfuddled
  module REST
    module API
      module Milestones

        # Get a milestone by project_id and milestone_id
        #
        # @param project_id [Integer] Project ID
        # @param milestone_id [Integer] Milestone ID
        # @return [Unfuddled::Milestone]
        def milestone(project_id , milestone_id)
          url = "/api/v1/projects/#{project_id}/milestones/#{milestone_id}.json"

          Unfuddled::Milestone.from_response( send(:get , url)[:body] , self)
        end

        # Gets milestones
        # With an optional filter
        #
        # @return [Array(Unfuddled::Milestone)] Milestones
        def milestones
          process_list_response( send(:get , "/api/v1/milestones.json")[:body] , Unfuddled::Milestone)
        end

      end
    end
  end
end
        
