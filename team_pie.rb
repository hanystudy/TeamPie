$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')

require 'team_pie'

dir_path = File.expand_path('./data/*.csv', File.dirname(__FILE__))

member_list = ['hang', 'jing']

TeamPie::TeamPieCore.run(dir_path, member_list)
