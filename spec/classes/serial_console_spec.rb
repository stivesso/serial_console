require 'spec_helper'

describe 'serial_console' do
  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('serial_console::terminal_config') }
      it { is_expected.to contain_class('serial_console::kernel_config') }
      it { is_expected.to contain_class('serial_console::root_on_console') }
    end
  end
end
