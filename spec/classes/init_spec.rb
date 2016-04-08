require 'spec_helper'
describe 'serial_console' do

  context 'with defaults for all parameters' do
    it { should contain_class('serial_console') }
  end
end
