require_relative './test_helper'

describe TeamPie do

  describe 'TeamPieCore' do
    it 'should generate report from fixtures' do
      dir_path = File.expand_path('../fixtures/*.csv', File.dirname(__FILE__))
      teampie = TeamPie::TeamPieCore.run(dir_path, ['hang', 'jing'])
    end
  end
end
