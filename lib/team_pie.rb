require 'team_pie/file_reader'
require 'team_pie/node'
require 'team_pie/nodes'

require 'pathname'

module TeamPie
  class TeamPieCore
    def self.run(path, member_list)
      relative_file_path_list = Dir.glob(path)
      full_file_path_list = relative_file_path_list.map do |relative_path|
        {
          file_name: Pathname.new(relative_path).sub_ext('').basename.to_s,
          full_path: File.expand_path(relative_path, File.dirname(__FILE__))
        }
      end

      file_reader = FileReader.new
      full_file_path_list.each do |file|
        file_reader.read(file[:full_path], file[:file_name])
      end

      file_reader.assign_tasks(member_list.count, member_list)
      file_reader.clean_assignments
      file_reader.print_clean_assignments
    end
  end
end
