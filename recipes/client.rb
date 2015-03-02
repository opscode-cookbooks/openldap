#
# Cookbook Name:: openldap
# Recipe:: client
#
# Copyright 2008-2009, Chef Software, Inc.
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

ldaputils_pkg = 'ldap-utils'
case node['platform_family']
    when 'debian'
        ldaputils_pkg = 'ldap-utils'
    when 'rhel'
        ldaputils_pkg = 'openldap-clients'
end

package ldaputils_pkg do
  action :upgrade
end

directory node['openldap']['ssl_dir'] do
  mode 00755
  owner "root"
  group "root"
end
