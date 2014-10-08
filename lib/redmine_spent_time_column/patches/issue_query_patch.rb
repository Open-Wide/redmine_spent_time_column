module RedmineSpentTimeColumn
  module Patches
    module IssueQueryPatch
      def self.included(base) # :nodoc:
        base.class_eval do
          unloadable
          alias_method_chain :available_columns, :total_spent_hours
        end
      end
      
      def available_columns_with_total_spent_hours
        available_columns_without_total_spent_hours
        if User.current.allowed_to?(:view_time_entries, project, :global => true)
          @available_columns << QueryColumn.new(:total_spent_hours,
            :sortable => "COALESCE((SELECT SUM(hours) FROM #{TimeEntry.table_name} time_entry LEFT JOIN #{Issue.table_name} child_issue ON time_entry.issue_id = child_issue.id WHERE #{TimeEntry.table_name}.issue_id = #{Issue.table_name}.id OR child_issue.parent_id IS NOT NULL), 0)",
            :default_order => 'desc',
            :caption => :label_total_spent_time
          )
        end
      end
    end
      
  end
end