#
# Cookbook Name:: openssh
# Recipe:: audit_sshd
#
# Copyright (C) 2015 Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Note: for demo purposes these controls only work on RHEL-type
# distributions (package names and such are different for Debians)

control_group 'check sshd configuration' do

  control 'sshd package' do
    it 'should be installed' do
      expect(package('openssh-server').to be_installed
    end
  end

  control 'sshd configuration' do
    let(:config_file) { file('/etc/ssh/sshd_config') }
    it 'should exist with the right permissions' do
      expect(config_file).to be_file
      expect(config_file).to be_mode(0644)
      expect(config_file).to be_owned_by('root')
      expect(config_file).to be_grouped_into('root')
    end
    it 'should not permit RootLogin' do
      expect(config_file).to_not match(/^PermitRootLogin yes/)
    end
    it 'should explicitly not permit PasswordAuthentication' do
      expect(config_file).to match(/^PasswordAuthentication no/)
    end
    it 'should force privilege separation' do
      expect(config_file).to match(/^UsePrivilegeSeparation sandbox/)
    end

    # Expected to fail as a demo of rule failures
    it 'should disable X11 forwarding' do
      expect(config_file).to_not match(/^X11Forwarding yes/)
    end
  end
end
