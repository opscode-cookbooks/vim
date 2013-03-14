#
# Cookbook Name:: vim
# Attributes:: default
#
# Copyright 2010, Opscode, Inc.
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
include_recipe 'mercurial'

source_path           = node['vim']['compile']['source_path']
source_url            = node['vim']['compile']['source_url']
install_path          = "#{node['vim']['compile']['prefix']}/bin/vim"
compile_configuration = node['vim']['compile']['configuration']
dev_dependencies      = node['vim']['compile']['dependencies']

dev_dependencies.each do |dependency|
  package dependency do
    action :install
  end
end

mercurial "#{source_path}/vim" do
  repository source_url
  mode '0755'
  owner 'root'
  reference "tip"
  action :clone
end

bash "build-and-install-vim" do
  cwd source_path
  code <<-EOF
    (cd vim && ./configure #{compile_configuration})
    (cd vim && make && make install)
  EOF
  not_if { ::File.exists?(install_path) }
end

