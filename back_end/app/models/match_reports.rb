class MatchReports < ActiveRecord::Base
    def self.refresh
      Scenic
        .database
        .refresh_materialized_view(table_name, concurrently: false)
    end
  
    def readonly?
      true
    end
  end