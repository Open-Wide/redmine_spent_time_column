require 'redmine'
require_dependency 'redmine_spent_time_column/hooks'

if Rails::VERSION::MAJOR < 3
  require 'dispatcher'
  object_to_prepare = Dispatcher
else
  object_to_prepare = Rails.configuration
  # if redmine plugins were railties:
  # object_to_prepare = config
end

object_to_prepare.to_prepare do
  Issue.send(:include, RedmineSpentTimeColumn::Patches::IssuePatch) unless Issue.include?(RedmineSpentTimeColumn::Patches::IssuePatch)
  Query.send(:include, RedmineSpentTimeColumn::Patches::QueryPatch) unless Query.include?(RedmineSpentTimeColumn::Patches::QueryPatch)
  QueriesHelper.send(:include, RedmineSpentTimeColumn::Patches::QueriesHelperPatch) unless QueriesHelper.include?(RedmineSpentTimeColumn::Patches::QueriesHelperPatch)
end

Redmine::Plugin.register :redmine_spent_time_column do
  name 'Redmine Spent Time Column'
  author 'Jan Schulz-Hofen, Planio GmbH'
  description 'This plugin adds a spent time column to issue lists.'
  version '2.0.1'

  settings :default => {
    'show_bottom_summary_line_on_issuelists' => '0',
    'show_bottom_summary_line_estimated_hours' => '1',
    'show_bottom_summary_line_spent_hours' => '1',
    'show_bottom_summary_line_calculated_spent_hours' => '1',
    'show_bottom_summary_line_divergent_hours' => '1',
    'show_bottom_summary_line_calculated_remaining_hours' => '1',
    'enable_spent_hours_column' => '1',
    'enable_calculated_spent_hours_column' => '0',
    'enable_divergent_hours_column' => '0',
    'enable_calculated_remaining_hours_column' => '0'
  }, :partial => 'settings/spent_time_column_settings'
end
