module RedmineSpentTimeColumn
  module Patches
    module IssuePatch
      
      def calculated_spent_hours
        if self.children?
          @calculated_spent_hours ||= descendants.sum("estimated_hours * done_ratio / 100").to_f || 0.0
        else
          @calculated_spent_hours ||= (estimated_hours.to_f * done_ratio.to_f / 100).to_f || 0.0
        end
      end
      
      def divergent_hours
        @divergent_hours ||= spent_hours - calculated_spent_hours
      end
      
      def calculated_remaining_hours
        if self.children?
          @calculated_remaining_hours ||= descendants.sum("estimated_hours - (estimated_hours * done_ratio / 100)").to_f || 0.0
        else
          @calculated_spent_hours ||= (estimated_hours.to_f - (estimated_hours.to_f * done_ratio.to_f / 100)).to_f || 0.0
        end
      end
      
    end
  end
end